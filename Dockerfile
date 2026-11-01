FROM node:22-alpine

# Claude Code needs these on Alpine (musl)
RUN apk add --no-cache bash git ripgrep libgcc libstdc++ ca-certificates

# Install the Claude CLI
RUN npm install -g @anthropic-ai/claude-code

# Use Alpine's ripgrep and keep all Claude config inside one folder
ENV USE_BUILTIN_RIPGREP=0
ENV CLAUDE_CONFIG_DIR=/home/node/.claude

# Run as a non-root user and create the config folder it owns
# (the named volume inherits this ownership on first use)
USER node
RUN mkdir -p /home/node/.claude

WORKDIR /workspace
ENTRYPOINT ["claude"]
