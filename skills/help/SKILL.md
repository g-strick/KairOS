<skill>
  <purpose>Surfaces available slash commands and explains the KairOS engine-vs-vault model.</purpose>
  <trigger>/help</trigger>
  <process>
    1. Read AGENTS.md to surface the Skills table.
    2. List each command with its one-line description.
    3. Explain engine vs vault: the engine (public repo) holds skills, hooks, and templates; the vault (e.g. ~/kairos) holds your inbox, profile, and daily notes.
    4. Point to docs/EXPANSIONS.md in the engine for planned features not yet shipped.
    5. Point to README.md for setup and development discipline.
  </process>
  <output>
    A short formatted message: available commands, engine/vault split, where to read more.
  </output>
</skill>
