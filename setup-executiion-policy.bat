echo Updating PowerShell execution Policy
%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -noprofile Set-ExecutionPolicy RemoteSigned -Force

IF NOT EXIST %SystemRoot%\syswow64\WindowsPowerShell\v1.0\powershell.exe  GOTO SkipWow64
echo Updating WOW64 PowerShell execution Policy
%SystemRoot%\syswow64\WindowsPowerShell\v1.0\powershell.exe -noprofile Set-ExecutionPolicy RemoteSigned -Force

:SkipWow64
