$virtualBoxPath = "C:\Program Files\Oracle\VirtualBox"
if (-not (Test-Path -Path "$env:PATH" -PathType Container -Include $virtualBoxPath)) {
    $env:PATH += ";$virtualBoxPath"
} else {
}

$vm_name="Cybersecurity_NPE_Kali"
$sharedFolder="C:\NPECybersecurity\sharedfolder"
$mediumLocation="C:\NPECybersecurity\medium\Kali Linux 2024.1 (64bit).vdi"

# Maak de VM aan
VBoxManage createvm --name $vm_name `
--ostype "Debian_64" `
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
--graphicscontroller vboxsvga

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

$interface = (Get-WmiObject -Query "SELECT * FROM Win32_NetworkAdapter WHERE NetEnabled = true AND Name LIKE '%Wireless%'").Name

VBoxManage modifyvm $vm_name --nic1 bridged --bridgeadapter1 $interface

VBoxManage startvm $vm_name

