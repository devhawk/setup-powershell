function encode-script($file) {
  $command = get-content -raw $file
  $bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
  return [Convert]::ToBase64String($bytes)
}

function write-script($filename, $msg, $script) {
  $encodedScript = encode-script $script
  add-content $filename "echo $msg"
  add-content $filename "powershell -noprofile -EncodedCommand $encodedScript"
}

$filename = "setup-new-machine.bat"

set-content $filename "@echo off"

get-content .\setup-executiion-policy.bat | %{add-content $filename $_}

write-script $filename "Setting up console defaults" "setup-console-defaults.ps1"
write-script $filename "Removing start menu .lnk file console defaults" "remove-console-props.ps1"

add-content $filename "pause"