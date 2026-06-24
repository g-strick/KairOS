<skill>
  <purpose>Welcoming help skill that surfaces available /kairos-* commands and explains the KairOS system model to new or confused users.</purpose>
  <trigger>/kairos-help</trigger>
  <process>
    1. Read AGENTS.md to surface the skill quick-reference section.
    2. List all available /kairos-* commands with their one-line descriptions.
    3. Explain the engine-vs-vault model: the engine (this repo) holds the system structure — skills, agents, hooks, templates — while your vault (e.g. ~/kairos) holds your personal life data — goals, notes, projects.
    4. Explain the crew-vs-council distinction: the crew (Sorter, Steward, Scribe, Keeper, Concierge) operates the system automatically; the council are advisory models you consult on demand for specific perspectives.
    5. Point to README.md for deeper documentation.
  </process>
  <output>
    A formatted message listing available commands, explaining the system model, and pointing to further resources.
  </output>
</skill>