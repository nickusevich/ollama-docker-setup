# 🦙 Ollama Docker Models

> **Fix for:** `ollama pull` works in interactive shell but fails in Dockerfile `RUN` commands

## 🐛 The Problem

```dockerfile
# ❌ This doesn't work
FROM ollama/ollama
RUN ollama pull mistral   # Fails - no server running during build
```

When building a Docker image, `ollama pull` fails because the Ollama server isn't running during the build phase. The server only starts at container runtime.

## ✅ The Solution

Move model pulling from **build time** to **runtime** via an entrypoint script:

```
┌─────────────────────────────────────────────────────────────┐
│  docker build (RUN)      →  No server running  →  ❌ Fails │
│  docker run (entrypoint) →  Server running     →  ✅ Works │
└─────────────────────────────────────────────────────────────┘
```

**How it works:**
1. Container starts → `entrypoint.sh` runs
2. Script starts `ollama serve` in background
3. Waits for server to initialize (15 seconds)
4. Pulls configured models
5. Keeps container alive with `tail -f /dev/null`

## 🚀 Quick Start

```bash
git clone https://github.com/yourusername/ollama-docker-models.git
cd ollama-docker-models
docker compose up -d

# Watch the model downloads
docker logs -f ollama

# Verify
curl http://localhost:11434/api/tags
```

## ⚙️ Configuration

Edit `entrypoint.sh` to choose your models:

```bash
# Uncomment what you need
pull "mistral"
pull "llama3"
# pull "qwen3:8b"
```

Models are stored in a Docker volume — they persist across container restarts.

## 🔧 Custom Model Configurations

Create models with extended context windows or custom parameters.

```bash
# In entrypoint.sh:
create "qwen3-8b-12kcontext" "Modelfile_qwen3_8b_12kcontext"
```

The base model (`qwen3:8b`) is pulled automatically if not already present.

Example Modelfile (`modelfiles/Modelfile_qwen3_8b_12kcontext`):
```
FROM qwen3:8b
PARAMETER num_ctx 12000
```

## 📁 Project Structure

```
ollama-docker-models/
├── Dockerfile
├── docker-compose.yml
├── entrypoint.sh                 ← Configure models here
├── modelfiles/
│   ├── Modelfile_qwen3_8b_12kcontext
│   └── Modelfile_gemma3_12b_12kcontext
└── README.md
```

## 📚 Resources

- [Ollama Docker Hub](https://hub.docker.com/r/ollama/ollama)
- [Ollama Model Library](https://ollama.com/library)
- [Modelfile Reference](https://docs.ollama.com/modelfile)

## 📄 License

MIT
