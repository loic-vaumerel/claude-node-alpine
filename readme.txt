Claude Code in a Node Alpine container
======================================

Files
-----
  Dockerfile           node:22-alpine image with the Claude CLI installed.
                       It runs as the non-root "node" user (UID 1000).
  docker-compose.yml   Runs the container interactively. It mounts:
                         - the "claude-config" named volume at /home/node/.claude
                           (your login and settings are kept between runs)
                         - a project folder at /workspace
  .env.claude          Optional. Login credentials, for example:
                         ANTHROPIC_API_KEY=...
                       or
                         CLAUDE_CODE_OAUTH_TOKEN=...
                       If this file is missing, run /login inside Claude once.


Build
-----
  cd <<instrall_folder>>
  docker compose build

Build again after you change the Dockerfile. To update the Claude CLI,
rebuild without the cache:
  docker compose build --no-cache


Run
---
Use "run" (not "up") so your terminal connects to the interactive prompt.
"--rm" deletes the container when you exit.

  # Mount the current directory (run this from the compose folder)
  docker compose run --rm claude

  # Mount another folder (it must be an absolute path)
  WORKSPACE=/home/<<user>>/projects/foo docker compose run --rm claude

  # Pass arguments to the Claude CLI (the entrypoint is "claude")
  docker compose run --rm claude -p "explain this repo"


Shortcut: claude-docker (defined in ~/.bashrc)
----------------------------------------------
(details in install.txt)

  claude-docker                         # mounts the current folder
  claude-docker ~/projects/foo          # mounts a specific folder (relative paths work)
  claude-docker ../repo -p "summarize"  # folder plus Claude arguments
  claude-docker . --version             # Claude options for the current folder

The first argument is always the folder to mount.


Without compose
---------------
  docker build -t claude-node-alpine <<instrall_folder>>
  docker run -it --rm \
    --env-file <<instrall_folder>>/.env.claude \
    -v claude-config:/home/node/.claude \
    -v /path/to/project:/workspace \
    claude-node-alpine

Note: plain docker gives the volume the exact name "claude-config", but compose
names its volume "claude-node-alpine_claude-config". The two do not share a
login.


Reset the login and settings
----------------------------
  docker volume rm claude-node-alpine_claude-config
