#!/bin/bash
. "$HOME/.nvm/nvm.sh"
export N8N_RUNNERS_ENABLED=true
nvm use 20 && npx n8n
