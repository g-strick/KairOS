# Action bridges

KairOS skills call bridge adapters here — not vendor CLIs directly from skill markdown.

| Bridge | Command | macOS only |
|--------|---------|------------|
| Apple Reminders | [`rem.sh`](rem.sh) via [rem](https://github.com/BRO3886/rem) | Yes |

Future: `todoist.sh`, `m365.sh` — selected by `KAIROS_ACTIONS_BRIDGE` when more than one ships.

Install rem (macOS 13+):

```bash
brew tap BRO3886/tap && brew install rem-cli
```

Also requires `jq`.
