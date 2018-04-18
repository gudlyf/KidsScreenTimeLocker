# KidsScreenTimeLocker

- Place KidsScreenTimeLocker in `C:\`

- Create shortcut to KidscreenTime PS1 script.

- Right-click shortcut and select "Properties."

- Edit "Target" field with the following:

`C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -WindowStyle hidden -File "C:\KidsScreenTimeLocker.ps1"`

- To run the lock script, double-click the shortcut and set the time in minutes before screen lock.

- Closing the timer window will immediately lock the computer.

- You may want to disable the ability to use Task Manager, as any tech-savvy kid can find and kill the PowerShell process and end the timer.
