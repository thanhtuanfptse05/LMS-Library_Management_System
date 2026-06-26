$libs = (Get-ChildItem -Path allowedlib/*.jar, web/WEB-INF/lib/*.jar | ForEach-Object { $_.FullName }) -join ";"
$classpath = "build/web/WEB-INF/classes;test-build;$libs"

if (-not (Test-Path test-build)) {
    New-Item -ItemType Directory -Force -Path test-build
}

# Compile only F8 test files
$testFiles = (Get-ChildItem -Path test/f8 -Filter *.java -Recurse | ForEach-Object { $_.FullName })
Write-Host "Compiling test files: " $testFiles
javac -encoding UTF-8 -cp $classpath -d test-build $testFiles

if ($LastExitCode -ne 0) {
    Write-Error "Test compilation failed!"
    exit $LastExitCode
}

# Find all F8 test classes
$testClasses = Get-ChildItem -Path test-build/f8 -Filter *Test*.class -Recurse | ForEach-Object {
    $fullName = $_.FullName
    $baseDir = (Get-Item "test-build").FullName
    $rel = $fullName.Substring($baseDir.Length + 1)
    $cls = $rel -replace '\.class$', '' -replace '\\', '.' -replace '/', '.'
    $cls
} | Where-Object { $_ -notmatch '\$' }

Write-Host "Discovered $($testClasses.Count) F8 test classes:"
$testClasses | ForEach-Object { Write-Host " - $_" }

$failed = 0
foreach ($cls in $testClasses) {
    Write-Host "`n========================================"
    Write-Host "Running $cls..."
    Write-Host "========================================"
    java -cp "$classpath" org.junit.runner.JUnitCore $cls
    if ($LastExitCode -ne 0) {
        $failed++
    }
}

if ($failed -gt 0) {
    Write-Error "$failed test suite(s) failed."
    exit 1
} else {
    Write-Host "`nAll F8 tests passed successfully!"
}
