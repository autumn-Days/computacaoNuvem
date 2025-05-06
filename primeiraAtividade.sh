#if (install)
sudo apt-get update
sudo apt-get install qemu-kvm
#baixar imagem 1
wget -O imagemVM1.img https://download.cirros-cloud.net/0.6.3/cirros-0.6.3-x86_64-disk.img
#fazer copia da imagem 1 para uma imagem 2
touch imagemVM2.img
cp imagemVM1.img imagemVM2.img
#configurar a 1° VM
qemu-img create -f qcow2 imagemVM1.img 128M
#configurar a 2° VM
qemu-img create -f qcow2 imagemVM2.img 128M
#criar a primeira interface TAP & fazer o launch da primeira VM
qemu-system-x86_64 -device e1000,netdev=user0 -netdev user,id=user0,hostfwd=tcp::2221-:22 -device e1000,netdev=net0,mac=00:00:00:00:00:01 -netdev tap,id=net0,ifname=tap1,script=no,downscript=no -m 256 -drive file=imagemVM1.img, media=disk,cache=writeback -vnc :1 -daemonize
#criar a segunda interface TAP & fazer o launch da segunda VM
qemu-system-x86_64 -device e1000,netdev=user0 -netdev user,id=user0,hostfwd=tcp::2222-:22 -device e1000,netdev=net0,mac=00:00:00:00:00:02 -netdev tap,id=net0,ifname=tap2,script=no,downscript=no -m 256 -drive file=imagemVM2.img,media=disk,cache=writeback -vnc :2 -daemonize
#acessar VM1 por SSH
ssh man@localhost -p 2221
#acessar VM2 por SSH
ssh man@localhost -p 2222
