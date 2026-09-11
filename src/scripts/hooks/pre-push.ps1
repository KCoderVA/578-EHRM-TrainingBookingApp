# =============================================================================
#  pre-push.ps1 — repository pre-push validation hook (re-enabled v1.1.20)
# -----------------------------------------------------------------------------
#  Runs before each push. Lightweight, non-fatal consistency checks so a release
#  push doesn't go out with mismatched version metadata. WARN-only by default;
#  set $StrictMode = $true to make the version/CHANGELOG mismatch blocking.
# =============================================================================
$ErrorActionPreference = 'Stop'
$StrictMode = $false
$repoRoot = (git rev-parse --show-toplevel) 2>$null
if (-not $repoRoot) { exit 0 }

$warn = 0

# ---- Check 1: VERSION exists and is SemVer ---------------------------------
$versionPath = Join-Path $repoRoot 'VERSION'
if (-not (Test-Path -LiteralPath $versionPath)) {
    Write-Host "[pre-push] WARN: VERSION file not found." -ForegroundColor Yellow
    $warn++
} else {
    $version = (Get-Content -LiteralPath $versionPath -Raw).Trim()
    if ($version -notmatch '^\d+\.\d+\.\d+$') {
        Write-Host "[pre-push] WARN: VERSION '$version' is not MAJOR.MINOR.PATCH." -ForegroundColor Yellow
        $warn++
    }

    # ---- Check 2: top CHANGELOG entry matches VERSION ----------------------
    $changelogPath = Join-Path $repoRoot 'CHANGELOG.md'
    if (Test-Path -LiteralPath $changelogPath) {
        $firstEntry = Select-String -LiteralPath $changelogPath -Pattern '^\s*##\s*\[(\d+\.\d+\.\d+)\]' |
            Select-Object -First 1
        if ($firstEntry -and $firstEntry.Matches[0].Groups[1].Value -ne $version) {
            Write-Host "[pre-push] WARN: newest CHANGELOG entry [$($firstEntry.Matches[0].Groups[1].Value)] != VERSION ($version)." -ForegroundColor Yellow
            $warn++
        }
    }
}

# ---- Check 3: no dist/ build artifacts tracked -----------------------------
$trackedDist = @(git ls-files 'dist/**') | Where-Object { $_ }
if ($trackedDist.Count -gt 0) {
    Write-Host "[pre-push] WARN: $($trackedDist.Count) file(s) under dist/ are tracked (should be git-ignored)." -ForegroundColor Yellow
    $warn++
}

if ($warn -gt 0 -and $StrictMode) {
    Write-Host "[pre-push] Push blocked ($warn warning(s), StrictMode on)." -ForegroundColor Red
    exit 1
}
if ($warn -eq 0) { Write-Host "[pre-push] OK" -ForegroundColor Green }
exit 0
