#!/usr/bin/env bash
# kair-fetch-engine.sh — fetch KairOS engine from GitHub (or local path) for update.sh
#
# Usage (source or run):
#   kair_fetch_engine REMOTE BRANCH DEST_DIR
#   kair_resolve_engine_remote [VAULT_ROOT]
#   kair_resolve_engine_branch [VAULT_ROOT]

set -euo pipefail

KAIR_DEFAULT_ENGINE_REMOTE="${KAIR_DEFAULT_ENGINE_REMOTE:-https://github.com/g-strick/KairOS.git}"
KAIR_DEFAULT_ENGINE_BRANCH="${KAIR_DEFAULT_ENGINE_BRANCH:-main}"

# kair_read_config_line FILE — first non-empty, non-comment line
kair_read_config_line() {
  local file="$1"
  [[ -f "$file" ]] || return 1
  local line
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    line="$(printf '%s' "$line" | tr -d '[:space:]')"
    [[ -n "$line" ]] || continue
    printf '%s' "$line"
    return 0
  done < "$file"
  return 1
}

# kair_github_slug REMOTE — owner/repo from URL or slug
kair_github_slug() {
  local remote="$1"
  remote="${remote%.git}"
  if [[ "$remote" =~ github\.com[:/]([^/]+)/([^/]+)$ ]]; then
    printf '%s/%s' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
    return 0
  fi
  if [[ "$remote" =~ ^[^/]+/[^/]+$ ]]; then
    printf '%s' "$remote"
    return 0
  fi
  return 1
}

kair_resolve_engine_remote() {
  local vault="${1:-}"
  if [[ -n "${KAIROS_ENGINE_REMOTE:-}" ]]; then
    printf '%s' "$KAIROS_ENGINE_REMOTE"
    return 0
  fi
  if [[ -n "$vault" ]]; then
    local from_file
    if from_file="$(kair_read_config_line "$vault/.engine-remote")"; then
      printf '%s' "$from_file"
      return 0
    fi
  fi
  printf '%s' "$KAIR_DEFAULT_ENGINE_REMOTE"
}

kair_resolve_engine_branch() {
  local vault="${1:-}"
  if [[ -n "${KAIROS_ENGINE_BRANCH:-}" ]]; then
    printf '%s' "$KAIROS_ENGINE_BRANCH"
    return 0
  fi
  if [[ -n "$vault" ]]; then
    local from_file
    if from_file="$(kair_read_config_line "$vault/.engine-branch")"; then
      printf '%s' "$from_file"
      return 0
    fi
  fi
  printf '%s' "$KAIR_DEFAULT_ENGINE_BRANCH"
}

# kair_is_engine_root DIR
kair_is_engine_root() {
  [[ -f "${1%/}/templates/allowlist.txt" ]]
}

# kair_fetch_engine REMOTE BRANCH DEST
kair_fetch_engine() {
  local remote="$1"
  local branch="$2"
  local dest="$3"

  mkdir -p "$dest"

  # Local directory (tests / offline)
  if [[ "$remote" == file://* ]]; then
    local src="${remote#file://}"
    [[ -d "$src" ]] || { echo "ERROR: local engine not found: $src" >&2; return 1; }
    cp -R "$src"/. "$dest/"
    kair_is_engine_root "$dest"
    return
  fi
  if [[ -d "$remote" ]] && kair_is_engine_root "$remote"; then
    cp -R "$remote"/. "$dest/"
    return 0
  fi

  # git clone (preferred when available)
  if command -v git >/dev/null 2>&1; then
    if git clone --depth 1 --branch "$branch" "$remote" "$dest" 2>/dev/null; then
      kair_is_engine_root "$dest" && return 0
      rm -rf "$dest"/*
    fi
    # SSH URL failed — try HTTPS slug
    local slug
    if slug="$(kair_github_slug "$remote")"; then
      local https="https://github.com/${slug}.git"
      if git clone --depth 1 --branch "$branch" "$https" "$dest" 2>/dev/null; then
        kair_is_engine_root "$dest" && return 0
        rm -rf "$dest"/*
      fi
    fi
  fi

  # curl + tar fallback (sandbox-friendly)
  local slug
  slug="$(kair_github_slug "$remote")" || {
    echo "ERROR: cannot parse GitHub remote: $remote" >&2
    return 1
  }

  if ! command -v curl >/dev/null 2>&1; then
    echo "ERROR: need git or curl to fetch engine from $remote" >&2
    return 1
  fi

  local url="https://github.com/${slug}/archive/refs/heads/${branch}.tar.gz"
  local tmp
  tmp="$(mktemp -t kair-engine.XXXXXX.tar.gz)"
  if ! curl -fsSL "$url" -o "$tmp"; then
    rm -f "$tmp"
    echo "ERROR: failed to download $url" >&2
    return 1
  fi

  tar -xzf "$tmp" -C "$dest" --strip-components=1
  rm -f "$tmp"
  kair_is_engine_root "$dest" || {
    echo "ERROR: downloaded engine missing templates/allowlist.txt" >&2
    return 1
  }
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  case "${1:-}" in
    fetch)
      [[ $# -ge 4 ]] || { echo "Usage: $0 fetch REMOTE BRANCH DEST" >&2; exit 1; }
      kair_fetch_engine "$2" "$3" "$4"
      ;;
    *)
      echo "Usage: $0 fetch REMOTE BRANCH DEST" >&2
      exit 1
      ;;
  esac
fi
