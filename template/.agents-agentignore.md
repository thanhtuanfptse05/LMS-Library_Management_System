# .agentignore — Cline và một số agent tools hỗ trợ
# Files trong list này agent KHÔNG được read trừ khi hỏi rõ

# Build artifacts (không relevant cho logic)
dist/
build/
*.exe
*.dll
*.so

# Dependencies (agent không cần đọc source code của libs)
node_modules/
vendor/     # Go vendor directory
.pnp.*

# Version control (agent không cần git internals)
.git/
.gitignore

# IDE config (không phải project context)
.vscode/
.idea/
*.swp
*.swo

# Logs và debug (noise, không phải context)
*.log
logs/
tmp/
coverage/

# Large generated files
*.pb.go
*_gen.go
docs/swagger.json

# Binary files (agent cannot read anyway)
*.png
*.jpg
*.gif
*.ico
*.wasm

# Sensitive (agent should NOT read)
.env
.env.*
*.pem
*.key
*.secret
secrets/