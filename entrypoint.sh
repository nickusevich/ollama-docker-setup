#!/bin/sh

# ============================================================
#  Ollama Docker Entrypoint
#  
#  Solves: "ollama pull works interactively but not in Dockerfile"
#  Why: ollama pull needs the server running, which doesn't 
#       happen during docker build - only at runtime.
# ============================================================

pull() {
    echo "  → Pulling $1"
    ollama pull "$1" || echo "  ✗ Failed: $1"
}

create() {
    echo "  → Creating $1"
    ollama create "$1" -f "/ollama/modelfiles/$2" || echo "  ✗ Failed: $1"
}

echo "┌────────────────────────────────────────┐"
echo "│  Ollama Docker                         │"
echo "└────────────────────────────────────────┘"

echo ""
echo "[1/3] Starting server..."
ollama serve &
sleep 15

echo ""
echo "[2/3] Pulling models..."

# ─────────────── MODELS ───────────────
# Uncomment the models you need

# Chat models
# pull "mistral"
# pull "llama3"
# pull "qwen3:8b"
# pull "qwen3:14b"
# pull "gemma3:12b"

# Embedding models
# pull "mxbai-embed-large:latest"
# pull "nomic-embed-text"

# Code models
# pull "codellama:7b"

# ─────────────── CUSTOM MODELS ───────────────
# Create models with custom context windows.
# Base model is pulled automatically if not present.

create "qwen3-8b-12kcontext" "Modelfile_qwen3_8b_12kcontext"
# create "gemma3-12b-12kcontext" "Modelfile_gemma3_12b_12kcontext"

echo ""
echo "[3/3] Ready!"
echo "┌────────────────────────────────────────┐"
echo "│  API:  http://localhost:11434          │"
echo "│  Tags: http://localhost:11434/api/tags │"
echo "└────────────────────────────────────────┘"
echo ""
echo "Installed models:"
ollama list

tail -f /dev/null
