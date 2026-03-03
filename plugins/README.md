# Plugin Marketplace

This directory is a Claude Code **plugin marketplace** — a Git-hosted registry that teams can add to distribute skills, hooks, and agents.

## What's Included

### `ws-piv-loop` — PIV Loop Workflow Plugin

A complete Plan → Implement → Validate workflow packaged as a plugin.

**Skills:**

| Command | Purpose |
|---------|---------|
| `/ws-piv-loop:ws-plan-feature` | Generate an implementation plan |
| `/ws-piv-loop:ws-implement` | Execute plan with validation loops |
| `/ws-piv-loop:ws-validate` | Run lint, type-check, tests |
| `/ws-piv-loop:ws-review` | Code review with severity ratings |
| `/ws-piv-loop:ws-install` | Set up dependencies, start servers |
| `/ws-piv-loop:ws-prime` | Load codebase context |

**Hooks:**

| Hook | Event | Purpose |
|------|-------|---------|
| `guard-bash.sh` | PreToolUse | Blocks dangerous commands, protects main branch |
| `guard-files.sh` | PreToolUse | Blocks writes to secrets and credentials |
| `notify-done.sh` | Stop | macOS notification when Claude finishes |

## Installing This Marketplace

```bash
# Add the marketplace (one-time setup)
/plugin marketplace add Widinglabs/workshop-project-1

# Install the plugin
/plugin install ws-piv-loop@workshop-marketplace
```

Or via CLI:

```bash
claude plugin install ws-piv-loop@workshop-marketplace
```

## Pre-configuring for Your Team

Add to your project's `.claude/settings.json` so every team member gets the marketplace automatically:

```json
{
  "extraKnownMarketplaces": {
    "workshop-marketplace": {
      "source": {
        "source": "github",
        "repo": "Widinglabs/workshop-project-1"
      }
    }
  },
  "enabledPlugins": {
    "ws-piv-loop@workshop-marketplace": true
  }
}
```

To restrict teams to only approved marketplaces (admin-controlled):

```json
{
  "strictKnownMarketplaces": [
    { "source": "github", "repo": "Widinglabs/workshop-project-1" }
  ]
}
```

---

## Creating Your Own Plugin

### 1. Create the directory structure

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json          # Manifest (required)
├── skills/
│   └── my-skill/
│       └── SKILL.md         # Skill instructions
├── agents/
│   └── my-agent.md          # Custom subagent definitions
├── hooks/
│   ├── hooks.json           # Hook configuration
│   └── my-hook.sh           # Hook scripts
├── .mcp.json                # MCP server configs (optional)
└── README.md
```

### 2. Write the manifest

`.claude-plugin/plugin.json`:

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "What this plugin does",
  "author": { "name": "Your Name" },
  "keywords": ["relevant", "tags"]
}
```

Required: `name` only. Everything else is optional but recommended.

### 3. Add skills

Each skill is a directory with a `SKILL.md` entrypoint:

```markdown
---
description: What this skill does
argument-hint: <what to pass>
---

# My Skill

Instructions for Claude to follow when this skill is invoked.

**Input**: $ARGUMENTS
```

### 4. Add hooks (optional)

`hooks/hooks.json` — uses `${CLAUDE_PLUGIN_ROOT}` for portable paths:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/my-guard.sh",
            "timeout": 3
          }
        ]
      }
    ]
  }
}
```

Hook scripts receive JSON on stdin. Exit `0` to allow, `2` to block (stderr sent to Claude).

### 5. Test locally

```bash
claude --plugin-dir ./my-plugin
```

This loads the plugin without installing it. Verify skills appear with `/` and hooks fire correctly.

### 6. Create a marketplace

To distribute multiple plugins, create a marketplace manifest at the repo root:

`.claude-plugin/marketplace.json`:

```json
{
  "name": "my-marketplace",
  "owner": { "name": "Your Team" },
  "plugins": [
    {
      "name": "my-plugin",
      "source": "./my-plugin",
      "description": "What it does"
    }
  ]
}
```

Push to Git. Teams add it with:

```bash
/plugin marketplace add your-org/your-repo
```

### 7. Version and distribute

- Use semantic versioning in `plugin.json`
- Pin versions in marketplace entries with `ref` and `sha` for stability
- Private repos work with `GITHUB_TOKEN` / `GITLAB_TOKEN` environment variables
- Submit to the official Anthropic marketplace at https://platform.claude.com/plugins/submit

---

## Enterprise Pattern: Organization-Wide Distribution

For companies like SAP distributing to hundreds of engineers:

```
sap-claude-plugins/               # Private GitHub repo
├── .claude-plugin/
│   └── marketplace.json          # Registry of all approved plugins
├── plugins/
│   ├── sap-abap-standards/       # ABAP coding conventions
│   ├── sap-hana-mcp/             # SAP HANA database integration
│   ├── sap-security-review/      # Security audit agents
│   ├── sap-deployment-checks/    # Pre-deployment validation
│   └── sap-incident-response/    # Runbook-as-skill for incidents
```

Then in every project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "sap-internal": {
      "source": { "source": "github", "repo": "sap-org/claude-plugins" }
    }
  },
  "strictKnownMarketplaces": [
    { "source": "github", "repo": "sap-org/claude-plugins" }
  ],
  "enabledPlugins": {
    "sap-abap-standards@sap-internal": true,
    "sap-security-review@sap-internal": true
  }
}
```

Every engineer gets the same guardrails, skills, and agents. Standards enforced automatically. Updates ship by pushing to the marketplace repo.
