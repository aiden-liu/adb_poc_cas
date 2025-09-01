#!/bin/sh
set -eu
dir="/home/node/.claude-code-router"
file="$dir/config.json"
GPT_API_BASE="${CLAUDE_ROUTER_GPT_API_BASE_URL:-}"
GPT_API_KEY="${CLAUDE_ROUTER_GPT_API_KEY:-}"
ADB_SONNET_API_BASE="${CLAUDE_ROUTER_ADB_SONNET_API_BASE_URL:-}"
ADB_SONNET_API_KEY="${CLAUDE_ROUTER_ADB_SONNET_API_KEY:-}"
if [ -z "$GPT_API_BASE" ] || [ -z "$GPT_API_KEY" ]; then
  echo "CLAUDE_ROUTER_GPT_API_BASE_URL or CLAUDE_ROUTER_GPT_API_KEY not set; skipping router config"
  exit 0
fi
if [ -z "$ADB_SONNET_API_BASE" ] || [ -z "$ADB_SONNET_API_KEY" ]; then
  echo "CLAUDE_ROUTER_ADB_SONNET_API_BASE_URL or CLAUDE_ROUTER_ADB_SONNET_API_KEY not set; skipping router config"
  exit 0
fi
tmp="$(mktemp)"
cat > "$tmp" <<'JSON'
{
  "LOG": true,
  "API_TIMEOUT_MS": 600000,
  "NON_INTERACTIVE_MODE": false,
  "Providers": [
    {
      "name": "azure-gpt5",
      "api_base_url": "__GPT_API_BASE_URL__",
      "api_key": "__GPT_API_KEY__",
      "models": ["gpt-5"],
      "transformer": { "use": ["maxcompletiontokens"] }
    },
    {
      "name": "azure-SONNET",
      "api_base_url": "__ADB_SONNET_API_BASE_URL__",
      "api_key": "__ADB_SONNET_API_KEY__",
      "models": ["databricks-claude-sonnet-4"]
    }
  ],
  "Router": { "default": "azure-gpt5,gpt-5" }
}
JSON
sed -i "s|__GPT_API_BASE_URL__|${GPT_API_BASE}|g" "$tmp"
sed -i "s|__GPT_API_KEY__|${GPT_API_KEY}|g" "$tmp"
sed -i "s|__ADB_SONNET_API_BASE_URL__|${ADB_SONNET_API_BASE}|g" "$tmp"
sed -i "s|__ADB_SONNET_API_KEY__|${ADB_SONNET_API_KEY}|g" "$tmp"
mv "$tmp" "$file"
chown -R node:node "$dir"
echo "$file"