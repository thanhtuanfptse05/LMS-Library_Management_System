param(
    [switch]$SkipCompile,
    [switch]$ForceRefresh
)

$ErrorActionPreference = "Stop"

$projectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$classDir = Join-Path $projectRoot "build\web\WEB-INF\classes"
$classpath = @(
    $classDir,
    (Join-Path $projectRoot "web\WEB-INF\lib\*"),
    (Join-Path $projectRoot "allowedlib\*")
) -join ";"

Write-Host "LMS Book Cover Fetcher" -ForegroundColor Cyan
Write-Host "Project: $projectRoot"
Write-Host ""

if (-not $SkipCompile) {
    $ant = Get-Command ant -ErrorAction SilentlyContinue
    $netBeansAnt = "C:\Program Files\NetBeans-17\netbeans\extide\ant\bin\ant.bat"
    if (-not $ant -and (Test-Path $netBeansAnt)) {
        $ant = Get-Item $netBeansAnt
    }

    if ($ant) {
        Write-Host "Dang compile project bang Ant..." -ForegroundColor Yellow
        $antPath = if ($ant.Source) { $ant.Source } else { $ant.FullName }
        & $antPath -f (Join-Path $projectRoot "build.xml") compile
    } else {
        throw "Khong tim thay Ant de compile. Hay build project trong NetBeans, cai Ant vao PATH, hoac chay lai voi -SkipCompile neu ban chac class da moi."
    }
}

$mainClassFile = Join-Path $classDir "util\BookCoverFetcher.class"
if (-not (Test-Path $mainClassFile)) {
    throw "Chua co $mainClassFile. Hay build project truoc, hoac chay lai sau khi cau hinh Ant."
}

Write-Host "Kiem tra cau hinh Supabase/Gemini..." -ForegroundColor Yellow
Write-Host "SUPABASE_URL=$($env:SUPABASE_URL)"
Write-Host "SUPABASE_BOOK_COVER_BUCKET=$($env:SUPABASE_BOOK_COVER_BUCKET)"
Write-Host "SUPABASE_SERVICE_ROLE_KEY=$(if ($env:SUPABASE_SERVICE_ROLE_KEY) { '<hidden>' } else { '<missing>' })"
Write-Host "GEMINI_API_KEY=$(if ($env:GEMINI_API_KEY -or $env:GEMINI_RECOMMEN_API_KEY) { '<optional configured>' } else { '<optional missing>' })"
Write-Host "FORCE_REFRESH=$(if ($ForceRefresh) { 'enabled' } else { 'disabled' })"
Write-Host ""

$javaArgs = @("-cp", $classpath, "util.BookCoverFetcher")
if ($ForceRefresh) {
    $javaArgs += "--force"
}

java @javaArgs
