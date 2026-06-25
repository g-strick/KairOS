---
name: kair-help
description: Lists available slash commands and explains the KairOS engine-vs-vault model. Use when the user runs /kair-help or is new to KairOS.
disable-model-invocation: true
---

# /kair-help — Help Skill

## Purpose

Surfaces available slash commands and explains the KairOS engine-vs-vault model.

## Process

1. Read AGENTS.md to surface the Skills table.
2. List each command with its one-line description.
3. Explain engine vs vault: the engine (public KairOS repo) holds skills, hooks, and templates; the Kairos Vault (e.g. ~/kairos-vault) holds your inbox, profile, and daily notes.
4. Point to docs/EXPANSIONS.md in the engine for planned features not yet shipped.
5. Point to README.md for setup and development discipline.

## Output

A short formatted message: available commands, engine/vault split, where to read more.
