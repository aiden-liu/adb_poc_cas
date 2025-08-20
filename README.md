# Dev Container Setup

Onboarding

- Set local env vars before opening the IDE (VS Code):
  - CLAUDE_ROUTER_GPT_API_BASE_URL
  - CLAUDE_ROUTER_GPT_API_KEY
  - CLAUDE_ROUTER_ADB_SONNECT_API_BASE_URL
  - CLAUDE_ROUTER_ADB_SONNECT_API_KEY
  - From desktop:
  ```bash
  export CLAUDE_ROUTER_GPT_API_BASE_URL=https://xxxxxx.openai.azure.com/openai/deployments/gpt-5/chat/completions?api-version=2024-12-01-preview && export CLAUDE_ROUTER_GPT_API_KEY=xxxxx && export CLAUDE_ROUTER_ADB_SONNECT_API_BASE_URL=https://xxxxxx.azuredatabricks.net/serving-endpoints/databricks-claude-sonnet-4/invocations && export CLAUDE_ROUTER_ADB_SONNECT_API_KEY=xxxxx && code <current_project_folder>
  ```
- Rebuild/reopen the Dev Container. The setup will generate ~/.claude-code-router/config.json and whitelist the domain derived from CLAUDE_ROUTER_GPT_API_BASE_URL.

Notes

- CLAUDE_ROUTER_API_KEY is sensitive; set it only in your local environment, not in source control.
- For Claude Code, see repo [claude-code](https://github.com/anthropics/claude-code)
- For Claude Code Router, see repo [claude-code-router](https://github.com/musistudio/claude-code-router)
- For other tools:
  - [Context7](https://github.com/upstash/context7)
  - [ccundo](https://github.com/RonitSachdev/ccundo)

Limitations

- This Dev Container config with Claude Code Router is for Azure AI Foundry and Azure Databricks Sonnect model compatibility only.
- This setup does not support Claude extended thinking.
- This setup does not support analysing images.
- This setup does not support web search.

# MCP config

From terminal, by running commandline, we can add local mcp server or remote mcp server.

For local, `claude mcp add <myserver> -- <npx or python> <mcp_package>`, e.g. `claude mcp add context7 -- npx @upstash/context7-mcp`.

For remote, `claude mcp add --transport <protocal> <myserver> <mcp_server_address>`, e.g. `claude mcp add --transport http context7 https://mcp.context7.com/mcp`.

To confirm mcp is properly installed, go to `ccr code` and `/mcp` to see connection status. And test in prompt messages. When inside a devcontainer with firewall settings, remote domains need to be whitelisted, by adding domain names into `.devcontainer/ini-firewall.sh`, line 74.

To remove a mcp `claude mcp remove <myserver>`, e.g. `claude mcp remove context7`.

Note:

- [Github Official MCP](https://github.com/github/github-mcp-server)

# Permissions

From Claude Code (`ccr code`), use `/permissions` to define "Allow"/"Ask"/"Deny"/"Workspace" rules, and choose scope "Project Settings (local)"/"Project Settings"/"User settings".

Example, in allow list, add `Bash(git commit:*)` rule, with active scope of "Project Settings (local)". Now there's a new rule visible at `.claude/settings.local.json`.

Here under .claude, settings.local.json and settings.json, see for [intro](https://docs.anthropic.com/en/docs/claude-code/settings#settings-files), see for [precedence](https://docs.anthropic.com/en/docs/claude-code/settings#settings-precedence).

For internal tools like `Bash`, more from official [here](https://docs.anthropic.com/en/docs/claude-code/settings#tools-available-to-claude)

For managing permission on mcps, simply put `mcp__<mcp_name>` as rule.

Another way, start claud code with `--dangerously-skip-permissions`, like `ccr code --dangerously-skip-permissions`, means claude code don't need to ask for any permission, all permisssions are allowed.

# Custom Commands with '/'

[Official guidance](https://docs.anthropic.com/en/docs/claude-code/slash-commands#custom-slash-commands)

Files under this `.claude/commands/` folder are the custom commands available for Claude Code, and file names are the command names.

Example:

```bash
# Create a project command
mkdir -p .claude/commands
echo "对比这个分支: $ARGUMENTS，与$ARGUMENTS分支的差异，并且提出你的review意见" > .claude/commands/code_review.md
```

After restart Claude Code, you can simply `/code_review feat/br-123-add-page main` where 'feat/br-123-add-page' is the value for the first $ARGUMENTS and 'main' is the value for the second.

# Hook

See [official guide](https://docs.anthropic.com/en/docs/claude-code/hooks)

# Sub Agent

See [official guide](https://docs.anthropic.com/en/docs/claude-code/sub-agents)
