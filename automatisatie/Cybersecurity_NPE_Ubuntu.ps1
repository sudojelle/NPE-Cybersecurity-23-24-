$virtualBoxPath = "C:\Program Files\Oracle\VirtualBox"
if (-not (Test-Path -Path "$env:PATH" -PathType Container -Include $virtualBoxPath)) {
    $env:PATH += ";$virtualBoxPath"
} else {
}

$vm_name="Cybersecurity_NPE_Ubuntu"
$sharedFolder="C:\NPECybersecurity\sharedfolder"
$mediumLocation="C:\NPECybersecurity\medium\Ubuntu 22.04 (64bit).vdi"

# Maak de VM aan
VBoxManage createvm --name $vm_name `
--ostype "Ubuntu22_LTS_64" `
--register `
--groups "/NPE Cybersecurity 23-24"

VBoxManage sharedfolder add $vm_name `
--name scripts `
--hostpath "$sharedFolder" `
--automount 

VBoxManage modifyvm $vm_name `
--memory 4096 `
--cpus 2 `
--vram 128 `

VBoxManage modifyvm $vm_name `
--clipboard-mode bidirectional

VBoxManage modifyvm $vm_name `
--graphicscontroller vmsvga

# Voeg een SATA-controller toe
VBoxManage storagectl $vm_name `
 --name "SATA Controller" `
 --add sata `
 --controller IntelAhci

VBoxManage storageattach $vm_name `
 --storagectl "SATA Controller" `
  --port 0 `
  --device 0 `
  --type hdd `
  --medium $mediumLocation

VBoxManage modifyvm $vm_name --nic1 nat 

VBoxManage startvm $vm_name

