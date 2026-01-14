FROM ollama/ollama

WORKDIR /ollama

COPY modelfiles/ ./modelfiles/
COPY entrypoint.sh .
RUN chmod +x /ollama/entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
