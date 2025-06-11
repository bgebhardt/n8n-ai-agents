#!/bin/bash

# script to run my local install of n8n
. "$HOME/.nvm/nvm.sh"
export N8N_RUNNERS_ENABLED=true
nvm use 20 && npx n8n
