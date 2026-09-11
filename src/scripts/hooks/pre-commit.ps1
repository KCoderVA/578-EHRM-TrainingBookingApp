# =============================================================================
#  pre-commit.ps1 — repository pre-commit validation hook (re-enabled v1.1.20)
# -----------------------------------------------------------------------------
#  Runs before each commit. Philosophy for THIS repo:
#    * HARD BLOCK (exit 1) only on things that are unambiguously wrong:
#        - staged build artifacts under dist/
#        - true secrets (private keys, passwords, API tokens/PATs, connection pwds)
#    * WARN (never blocks) on values this repo KNOWINGLY publishes in unpacked
#      Power Apps source (tenant/environment GUIDs, *.sharepoint.com URLs,
#      @va.gov emails) — these are expected, so they only print a reminder.
#
#  To make the "warn" categories blocking too, set $StrictMode = $true below.
# =============================================================================
$ErrorActionPreference = 'Stop'
$StrictMode = $false          # $true => treat WARN categories as blocking errors
$fail = $false

# Staged, added/copied/modified files only (ignore deletions).
$staged = @(git diff --cached --name-only --diff-filter=ACM)
if (-not $staged) { exit 0 }

# ---- HARD BLOCK 1: never commit build artifacts under dist/ -----------------
$distFiles = $staged | Where-Object { $_ -match '^dist/' }
if ($distFiles) {
    Write-Host "[pre-commit] ERROR: build artifacts under dist/ are staged (should be git-ignored):" -ForegroundColor Red
    $distFiles | ForEach-Object { Write-Host "    $_" -ForegroundColor Red }
    $fail = $true
}

# ---- Secret / PII scanning over staged text content ------------------------
# HARD patterns = real credentials that must never be committed.
$hardPatterns = @(
    '-----BEGIN [A-Z ]*PRIVATE KEY-----',              # private keys
    '(?i)\bpassword\s*[:=]\s*[''"]?[^\s''"]{4,}',       # password = ...
    '(?i)\bpwd\s*=\s*[^\s;]{4,}',                        # connection string pwd=
    'ghp_[A-Za-z0-9]{20,}',                              # GitHub PAT (classic)
    'github_pat_[A-Za-z0-9_]{20,}',                      # GitHub PAT (fine-grained)
    'AKIA[0-9A-Z]{16}',                                  # AWS access key id
    '(?i)\bBearer\s+[A-Za-z0-9\-_\.]{20,}'              # bearer tokens
)
# SOFT patterns = expected-in-this-repo; warn only (unpacked app source has these).
$softPatterns = @(
    '[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}',  # GUIDs
    '[A-Za-z0-9._-]+\.sharepoint\.com',                                              # SharePoint URLs
    '(?i)[A-Za-z0-9._%+-]+@va\.gov'                                                   # VA emails
)

$softHits = 0
foreach ($f in $staged) {
    if (-not (Test-Path -LiteralPath $f)) { continue }
    if ($f -match '\.(msapp|msapr|zip|pbix|pbit|png|jpg|jpeg|gif|ico|pdf|xlsx|xls)$') { continue }
    $content = Get-Content -LiteralPath $f -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    foreach ($p in $hardPatterns) {
        if ($content -match $p) {
            Write-Host "[pre-commit] ERROR: possible secret in $f (pattern: $p)" -ForegroundColor Red
            $fail = $true
        }
    }
    foreach ($p in $softPatterns) {
        if ($content -match $p) { $softHits++; break }
    }
}
if ($softHits -gt 0) {
    Write-Host "[pre-commit] NOTE: $softHits staged file(s) contain environment values (GUIDs / SharePoint URLs / VA emails)." -ForegroundColor Yellow
    Write-Host "             Expected for unpacked Power Apps source; sanitize before any PUBLIC push." -ForegroundColor Yellow
    if ($StrictMode) { $fail = $true }
}

if ($fail) {
    Write-Host "[pre-commit] Commit blocked. Resolve the ERROR items above." -ForegroundColor Red
    exit 1
}
Write-Host "[pre-commit] OK" -ForegroundColor Green
exit 0
