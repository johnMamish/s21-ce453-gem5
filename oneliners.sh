################################
# use mnt to move files into disk image
# run fdisk to get offset of partition we want.
fdisk -lu x86root-parsec.img

    ...
    Device              Boot Start     End Sectors Size Id Type
    x86root-parsec.img1         63 4194287 4194225   2G 83 Linux

# offset is 63. pass that into the mount command.

mkdir mnt
sudo mount -o loop,offset=$[63*512] x86root-parsec.img mnt

# now you can copy whatever files you want into mnt. might need to use sudo
# cp files ./mnt

# unmount saves stuff to the image
sudo umount
rmdir mnt


################################
# Starting qemu
qemu-system-x86_64 -kernel ../proj1-gem5/images/kernel/bzImage -hda ./linux-images/x86root-parsec.img -m 1024 -append "root=/dev/hda console=ttyS0 earlyprintk=ttyS0" -serial stdio

################################
# Notes on compiling gem5
# I needed to alias scons to something. it was using the wrong PYTHON_CONFIG file
alias scons3="/usr/bin/env python3 $(which scons) PYTHON_CONFIG=$(which python3-config)"

################################
# run gem5 opt with 2 images
./build/X86/gem5.opt configs/example/fs.py --kernel ../x86_64-vmlinux-2.6.28.4-smp --disk-image ../linux-images/x86root-parsec.img --disk-image ./bench

# and then we mounted it with
mount /dev/hdb1 /mnt/bench
