# 🧠 Alex Agent Plugin

> **Install Alex's cognitive architecture in VS Code — no extension needed.**

<p align="center">
  <img src="assets/banner.svg" alt="Alex Agent Plugin" width="100%">
</p>

---

## What Is This?

Alex is an AI cognitive architecture that makes GitHub Copilot smarter. Instead of a generic assistant, you get a partner with:

- **84 domain skills** — Deep knowledge on security, testing, debugging, documentation, and more
- **7 specialist agents** — Researcher, Builder, Validator, Documentarian, Azure, M365
- **22 auto-loaded instructions** — Best practices applied automatically based on what you're editing
- **11 prompt workflows** — Reusable `/` commands for common tasks
- **Cognitive tools** — MCP-powered memory, state tracking, and focus management

All without installing a VS Code extension.

---

## Quick Install (30 seconds)

### Windows (PowerShell)

```powershell
# One-liner install
irm https://raw.githubusercontent.com/fabioc-aloha/AlexAgent/main/install.ps1 | iex
```

Or manually:

```powershell
git clone https://github.com/fabioc-aloha/AlexAgent.git $env:USERPROFILE\.alex-agent
```

Then add to your VS Code `settings.json`:

```json
{
  "chat.plugins.paths": {
    "~/.alex-agent/plugin": true
  }
}
```

### macOS / Linux (Bash)

```bash
# One-liner install
curl -fsSL https://raw.githubusercontent.com/fabioc-aloha/AlexAgent/main/install.sh | bash
```

Or manually:

```bash
git clone https://github.com/fabioc-aloha/AlexAgent.git ~/.alex-agent
```

Then add to your VS Code `settings.json`:

```json
{
  "chat.plugins.paths": {
    "~/.alex-agent/plugin": true
  }
}
```

### After Installation

1. **Restart VS Code** (or press `Ctrl+Shift+P` → "Reload Window")
2. **Open Copilot Chat** (`Ctrl+Alt+I`)
3. **Say hello**: Type "Who are you?" — Alex will introduce himself

---

## What You Get

### 🎯 Skills (84)

Skills are domain knowledge Alex loads on demand. Examples:

| Category | Skills |
|----------|--------|
| **Security** | secrets-management, distribution-security, security-review |
| **Testing** | testing-strategies, root-cause-analysis, debugging-patterns |
| **Documentation** | markdown-mermaid, doc-hygiene, knowledge-synthesis |
| **Development** | vscode-extension-patterns, mcp-development, refactoring-patterns |
| **AI/ML** | prompt-engineering, ai-character-reference-generation, image-handling |

Ask Alex about any topic — he'll load the relevant skill automatically.

### 🤖 Agents (7)

Switch personas for specialized tasks:

| Agent | Use When |
|-------|----------|
| **@Alex** | General assistance (default) |
| **@Researcher** | Deep exploration, finding patterns |
| **@Builder** | Implementing features, writing code |
| **@Validator** | Code review, testing, quality assurance |
| **@Documentarian** | Writing docs, READMEs, guides |
| **@Azure** | Azure deployment, infrastructure |
| **@M365** | Microsoft 365, Teams, Graph API |

### 📝 Prompts (11)

Reusable workflows available as `/` commands:

- `/rca` — Root cause analysis workflow
- `/refactor` — Safe refactoring procedure
- `/debug` — Systematic debugging
- `/security-review` — Security audit checklist
- `/knowledge` — Search cross-project knowledge
- And more...

### 📋 Instructions (22)

Auto-loaded rules that apply based on what you're editing:

- Editing `*.test.ts`? Testing best practices load automatically
- Working in `azure/`? Azure deployment patterns activate
- Touching security files? Security review guidelines appear

---

## Requirements

- **VS Code 1.110+** (agent plugins support)
- **GitHub Copilot** subscription (Individual, Business, or Enterprise)
- **Git** (for installation and updates)

### Enable Agent Mode

Make sure these settings are enabled in VS Code:

```json
{
  "chat.agent.enabled": true,
  "chat.plugins.enabled": true
}
```

---

## Updating

Pull the latest version:

```bash
cd ~/.alex-agent  # or wherever you cloned
git pull
```

Then reload VS Code.

---

## Troubleshooting

### "Alex doesn't respond"

1. Check VS Code version: `Help` → `About` → must be 1.110+
2. Verify settings: `chat.agent.enabled` and `chat.plugins.enabled` must be `true`
3. Check plugin path: The path in `chat.plugins.paths` must point to the `plugin/` directory

### "Skills don't load"

1. Reload VS Code: `Ctrl+Shift+P` → "Reload Window"
2. Check plugin directory exists and contains `skills/` folder
3. Try asking directly: "Load the testing-strategies skill"

### "MCP tools unavailable"

The MCP cognitive tools require Node.js. Install from [nodejs.org](https://nodejs.org/).

---

## What's NOT Included

This plugin provides Alex's knowledge and patterns but NOT the full VS Code extension features:

| Feature | Plugin | Extension |
|---------|:------:|:---------:|
| Skills, Agents, Instructions | ✅ | ✅ |
| `@alex` chat participant | ❌ | ✅ |
| Welcome panel with avatar | ❌ | ✅ |
| 90 extension commands | ❌ | ✅ |
| SecretStorage credentials | ❌ | ✅ |
| Episodic memory service | ❌ | ✅ |
| Task detection | ❌ | ✅ |

Want the full experience? Install the [Alex Cognitive Architecture extension](https://marketplace.visualstudio.com/items?itemName=fabioc-aloha.alex-cognitive-architecture) from the VS Code Marketplace.

---

## License

Apache 2.0 — See [LICENSE](LICENSE)

---

## Links

- 🏠 **Main Project**: [Alex Cognitive Architecture](https://github.com/fabioc-aloha/Alex_Plug_In)
- 📦 **VS Code Extension**: [Marketplace](https://marketplace.visualstudio.com/items?itemName=fabioc-aloha.alex-cognitive-architecture)
- 📖 **Documentation**: [User Manual](https://github.com/fabioc-aloha/Alex_Plug_In/blob/main/alex_docs/guides/USER-MANUAL.md)

---

<p align="center">
  <em>Alex — The AI that grows with you</em>
</p>
