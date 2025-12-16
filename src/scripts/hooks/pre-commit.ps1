# pre-commit.ps1
Write-Host ""[pre-commit] Validating repository content...""
# Example: prevent committing dist/ binaries
\ = git diff --cached --name-only
if (\ | Where-Object { \ -match '^dist/' }) {
  Write-Host ""Do not commit files under dist/"" -ForegroundColor Red
  exit 1
}
