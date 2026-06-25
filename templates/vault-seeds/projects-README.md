# Project file format

Each active project is one markdown file in `projects/`.

```markdown
# Project name

## Outcome
What done looks like.

## Next action
- [ ] @Computer Single physical next step
```

Only the unchecked task under `## Next action` is filed into `next-actions.md` by `/kair-triage`, and published by `/kair-publish` to your execution bridge.
