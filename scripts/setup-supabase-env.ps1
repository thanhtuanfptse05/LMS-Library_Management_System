$ErrorActionPreference = "Stop"

$supabaseUrl = "https://wukwrfwdrbstyoqissjz.supabase.co"
$bucket = "book-covers"

Write-Host "Cau hinh Supabase Storage cho LMS" -ForegroundColor Cyan
Write-Host "Script se set Environment Variables cho user Windows hien tai."
Write-Host ""

$secureKey = Read-Host "Nhap SUPABASE_SERVICE_ROLE_KEY" -AsSecureString
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureKey)
try {
    $serviceRoleKey = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
} finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
}

if ([string]::IsNullOrWhiteSpace($serviceRoleKey)) {
    Write-Error "SUPABASE_SERVICE_ROLE_KEY khong duoc de trong."
    exit 1
}

setx SUPABASE_URL $supabaseUrl | Out-Null
setx SUPABASE_BOOK_COVER_BUCKET $bucket | Out-Null
setx SUPABASE_SERVICE_ROLE_KEY $serviceRoleKey | Out-Null

Write-Host ""
Write-Host "Da luu Environment Variables:" -ForegroundColor Green
Write-Host "SUPABASE_URL=$supabaseUrl"
Write-Host "SUPABASE_BOOK_COVER_BUCKET=$bucket"
Write-Host "SUPABASE_SERVICE_ROLE_KEY=<hidden>"
Write-Host ""
Write-Host "Hay dong mo lai NetBeans/Tomcat de Java nhan bien moi." -ForegroundColor Yellow
