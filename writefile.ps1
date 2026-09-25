# Demo: Principle of Least Privilege
# This script attempts to write a file into C:\Windows\System32
# Under a basic account, it should fail.
# Under an admin account, it will succeed.

$targetPath = "C:\Windows\System32\PrivilegeTest.txt"
$content = "This file shows what happens when you run with elevated rights."

try {
    Set-Content -Path $targetPath -Value $content -ErrorAction Stop
    Write-Host "SUCCESS: File created at $targetPath"
} catch {
    Write-Host "FAILED: Could not create file in System32. Error: $($_.Exception.Message)"
}

# Cleanup step (only works if file was created)
if (Test-Path $targetPath) {
    Remove-Item $targetPath -Force
    Write-Host "Cleanup: Test file removed."
}