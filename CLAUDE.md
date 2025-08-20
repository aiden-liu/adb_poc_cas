# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a template project for setting up Claude Code in a dev container with backend routing to Azure GPT-5 or Azure Databricks Sonnet 4. It demonstrates how to configure Claude Code to work with Azure AI services through a custom router configuration.

## Environment Setup

### Required Environment Variables
Set these environment variables before opening VS Code:
- `CLAUDE_ROUTER_GPT_API_BASE_URL` - Azure OpenAI GPT-5 endpoint
- `CLAUDE_ROUTER_GPT_API_KEY` - Azure OpenAI API key  
- `CLAUDE_ROUTER_ADB_SONNECT_API_BASE_URL` - Azure Databricks Sonnet endpoint
- `CLAUDE_ROUTER_ADB_SONNECT_API_KEY` - Azure Databricks API key

Example setup command:
```bash
export CLAUDE_ROUTER_GPT_API_BASE_URL=https://xxxxxx.openai.azure.com/openai/deployments/gpt-5/chat/completions?api-version=2024-12-01-preview && export CLAUDE_ROUTER_GPT_API_KEY=xxxxx && export CLAUDE_ROUTER_ADB_SONNECT_API_BASE_URL=https://xxxxxx.azuredatabricks.net/serving-endpoints/databricks-claude-sonnet-4/invocations && export CLAUDE_ROUTER_ADB_SONNECT_API_KEY=xxxxx && code <current_project_folder>
```

### Dev Container Setup
- Rebuild/reopen the dev container after setting environment variables
- The setup automatically generates `~/.claude-code-router/config.json`
- Domains are automatically whitelisted based on the API base URLs

## Claude Code Router Configuration

The router is configured with two providers:
- **azure-gpt5**: Routes to Azure OpenAI GPT-5 (default)
- **azure-sonnect**: Routes to Azure Databricks Claude Sonnet 4

Configuration is automatically generated from environment variables during container startup.

## Permission Management

Current permissions (`.claude/settings.local.json`):
- **Allow**: `Bash(git commit:*)`, `WebSearch`
- Use `/permissions` command to modify rules
- Scope options: "Project Settings (local)", "Project Settings", "User settings"
- For MCP permissions, use format: `mcp__<mcp_name>`

Alternative: Start with `--dangerously-skip-permissions` to allow all operations.

## Custom Agents

Available agents in `.claude/agents/`:
- **code-reviewer**: Expert code review with security, performance, and maintainability analysis
- **weather-forecaster**: Weather information and forecasting

## MCP Integration

### Adding MCP Servers
- Local: `claude mcp add <mcp_name> -- <npx or python> <mcp_package>`
- Remote: `claude mcp add --transport <protocol> <mcp_name> <mcp_server_address>`

### Managing MCPs
- Check status: `/mcp` command in Claude Code
- Remove: `claude mcp remove <mcp_name>`
- For firewall issues, whitelist domains in `.devcontainer/init-firewall.sh` line 74

## Custom Commands

Create custom slash commands in `.claude/commands/`:
- File names become command names
- Use `$ARGUMENTS` for parameters
- Example: `/code_review feat/branch main` compares branches

## Development Workflow

### Starting Claude Code
```bash
ccr code  # Standard mode
ccr code --dangerously-skip-permissions  # Skip permission prompts
```

### Key Commands
- `/permissions` - Manage tool permissions
- `/mcp` - Check MCP server status
- Custom commands available based on `.claude/commands/` files

## Limitations

This dev container setup has the following limitations:
- No Claude extended thinking support
- No image analysis capabilities  
- No web search functionality (router limitation)
- Azure AI Foundry and Azure Databricks compatibility only

## Architecture Notes

- Uses Node.js 20 base image with development tools
- Includes git-delta, zsh, and common CLI tools
- Persistent volumes for bash history and Claude config
- Firewall configuration for network security
- VS Code extensions: ESLint, Prettier, GitLens
