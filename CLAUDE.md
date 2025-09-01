# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **New Zealand Crash Analysis System (CAS)** data engineering project that processes traffic crash data from NZTA. The project demonstrates modern data engineering practices using dbt, Databricks, and Terraform in a containerized development environment with Claude Code integration.

The project includes:

- **CAS Data Pipeline**: dbt models for processing NZ traffic crash data from NZTA
- **Infrastructure as Code**: Terraform for provisioning Azure Data Lake and Databricks resources
- **Dev Container**: Node.js 20 base with Databricks CLI, Python, and data engineering tools
- **Claude Code Integration**: Custom agents and Center of Excellence (CoE) configurations
- **Data Engineering Standards**: CoE practices for naming, testing, and data quality

## Environment Setup

### Required Environment Variables

Set these environment variables before opening VS Code:

- `CLAUDE_ROUTER_GPT_API_BASE_URL` - Azure OpenAI GPT-5 endpoint
- `CLAUDE_ROUTER_GPT_API_KEY` - Azure OpenAI API key
- `CLAUDE_ROUTER_ADB_SONNET_API_BASE_URL` - Azure Databricks Sonnet endpoint
- `CLAUDE_ROUTER_ADB_SONNET_API_KEY` - Azure Databricks API key

Example setup command:

```bash
export CLAUDE_ROUTER_GPT_API_BASE_URL=https://xxxxxx.openai.azure.com/openai/deployments/gpt-5/chat/completions?api-version=2024-12-01-preview && export CLAUDE_ROUTER_GPT_API_KEY=xxxxx && export CLAUDE_ROUTER_ADB_SONNET_API_BASE_URL=https://xxxxxx.azuredatabricks.net/serving-endpoints/databricks-claude-sonnet-4/invocations && export CLAUDE_ROUTER_ADB_SONNET_API_KEY=xxxxx && code <current_project_folder>
```

### Dev Container Setup

- Rebuild/reopen the dev container after setting environment variables
- The setup automatically generates `~/.claude-code-router/config.json`
- Domains are automatically whitelisted based on the API base URLs

## Claude Code Router Configuration

The router is configured with two providers:

- **azure-gpt5**: Routes to Azure OpenAI GPT-5 (default)
- **azure-SONNET**: Routes to Azure Databricks Claude Sonnet 4

Configuration is automatically generated from environment variables during container startup.

## Permission Management

Current permissions (`.claude/settings.local.json`):

- **Allow**: `Bash(git commit:*)`, `WebSearch`
- Use `/permissions` command to modify rules
- Scope options: "Project Settings (local)", "Project Settings", "User settings"
- For MCP permissions, use format: `mcp__<mcp_name>`

Alternative: Start with `--dangerously-skip-permissions` to allow all operations.

## Databricks Integration

### Workspace Configuration

The project includes Databricks workspace configuration via `databricks.yml`:

- **Bundle Name**: workspace
- **Default Target**: dev (development mode)
- **Workspace Host**: Pre-configured Azure Databricks endpoint

### Databricks CLI

- Automatically installed during container setup
- Version check: `databricks -v`
- Configuration managed through bundle files

## Custom Agents

Available agents in `.claude/agents/examples/`:

- **code-reviewer**: Expert code review with security, performance, and maintainability analysis
- Enhanced with data engineering Center of Excellence (CoE) practices

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

### Common Development Commands

- **Databricks CLI**: `databricks -v` to check version, configured in dev container
- **Git Configuration**: Pre-configured with bot user for commits
- **Python Environment**: UV package manager installed for Python dependencies
- **Container Management**: Persistent volumes for bash history and Claude config

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

### Container Configuration

- **Base Image**: Node.js 20 with development tools
- **Shell**: Zsh with powerline10k theme and fzf integration
- **Tools**: git-delta, GitHub CLI, Databricks CLI, UV package manager
- **Persistent Storage**: Bash history and Claude config via Docker volumes
- **Security**: Firewall configuration with iptables/ipset support

### VS Code Integration

- **Extensions**: ESLint, Prettier, GitLens, Python, Jupyter, Terraform, Databricks
- **Settings**: Format on save, ESLint auto-fix, zsh as default terminal
- **Capabilities**: NET_ADMIN and NET_RAW for network management

### File Structure

```
/workspace/                 # Project root
├── .devcontainer/         # Dev container configuration
│   ├── Dockerfile         # Container build definition
│   ├── devcontainer.json  # VS Code dev container settings
│   └── setup-*.sh         # Initialization scripts
├── .claude/               # Claude Code configuration
│   ├── agents/           # Custom agents (code-reviewer, weather-forecaster)
│   └── settings.local.json # Local permissions and MCP settings
├── databricks.yml         # Databricks workspace configuration
└── CLAUDE.md             # This file
```

## Repository Architecture

### Data Pipeline (Root Level)

- **dbt_project.yml**: Main dbt project configuration for CAS data models
- **dbt_profiles/profiles.yml**: Databricks connection profiles (dev/prod targets)
- **resources/cas.job.yml**: Databricks job definition with daily scheduling
- **src/**: dbt source code structure
  - **ingestion/cas_bronze_ingestion.ipynb**: Notebook for loading raw CAS CSV data to Delta tables
  - **models/**: dbt models directory (bronze/silver/gold layers)
  - **macros/**: Custom dbt macros for CAS-specific transformations
  - **tests/**: Custom dbt tests for data quality validation

### Infrastructure as Code

- **iac/**: Terraform configuration for Azure resources
  - **providers.tf**: Azure and Databricks provider configuration
  - **variables.tf, locals.tf, data.tf, main.tf**: Infrastructure definitions
  - **configs/iac/dev_config.tfvars**: Environment-specific variables
  - Creates: Azure Data Lake Gen2 storage, Databricks catalogs/schemas, external volumes

### Data Engineering Standards

- **configs/coe/**: Center of Excellence configuration files
  - **mandatory-standards.yml**: Non-negotiable naming and data type rules
  - **advisory-guidelines.yml**: Best practice recommendations for dbt and performance
  - **project-specific.yml**: CAS-specific rules (NZ coordinates, crash severity codes, etc.)

### Development Environment

- **databricks.yml**: Workspace bundle configuration for dev/prod deployment
- **.devcontainer/**: Container setup with Databricks CLI, Python, and data tools

## Development commands

### CAS Data Pipeline (dbt)

- **Setup** (from project root):
  ```bash
  python3 -m venv .venv
  . .venv/bin/activate
  pip install -r requirements-dev.txt
  ```
- **Local Development**:
  ```bash
  dbt seed    # Load seed data
  dbt run     # Execute all models
  dbt test    # Run data quality tests
  ```
- **Single Model Operations**:
  ```bash
  dbt run --model model_name
  dbt test --select model_name
  ```
- **Databricks Deployment**:
  ```bash
  databricks bundle deploy --target dev   # Deploy to development
  databricks bundle deploy --target prod  # Deploy to production
  ```
- **Data Ingestion**: Run `src/ingestion/cas_bronze_ingestion.ipynb` to load raw CAS CSV files
- **Configuration**: Profiles use `DBT_HOST` and `DBT_ACCESS_TOKEN` environment variables
- **Catalogs**: dev_bronze (development), transport_cas schema for all CAS tables

### Infrastructure (Terraform)

- **Setup and Planning**:
  ```bash
  cd iac
  terraform init
  terraform plan -var-file=../configs/iac/dev_config.tfvars
  ```
- **Deployment**:
  ```bash
  terraform apply -var-file=../configs/iac/dev_config.tfvars
  ```
- **Provisions**: Azure Data Lake Gen2 storage paths, Databricks catalogs/schemas, external volumes

## Data Engineering Standards

### Center of Excellence (CoE) Configuration

The project implements data engineering best practices through YAML configuration files:

- **Mandatory Standards** (`configs/coe/mandatory-standards.yml`):

  - Table naming: singular nouns, snake_case, no abbreviations
  - Datetime fields: UTC timezone required for all metadata columns
  - Primary keys: string-based IDs preferred over integers
  - Documentation: required descriptions for tables and business logic columns

- **Advisory Guidelines** (`configs/coe/advisory-guidelines.yml`):

  - dbt patterns: layer separation (bronze/silver/gold), 80% documentation coverage
  - Performance: partition tables >10GB, Z-ORDER optimization for filtered columns
  - Testing: primary key tests, referential integrity, business rule validation

- **CAS-Specific Rules** (`configs/coe/project-specific.yml`):
  - Crash severity codes: F (Fatal), S (Serious), M (Minor), N (Non-injury)
  - Geographic constraints: NZMG coordinates with WGS84 datum, TLA boundaries
  - Vehicle classifications: standard NZTA vehicle type categories
  - Data validation: coordinate bounds, casualty count consistency, speed limit values

### Usage in Development

- Reference CoE configs when creating new models or reviewing code
- Use configurations to validate naming conventions and data types
- Apply CAS-specific business rules for crash data validation
