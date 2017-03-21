VM_NAME="sles12sp1_minimum"
OS_TYPE="Linux"
OS_VARIANT="sles12sp1"
RAM="1024"
VCPUS="1"
DISK_IMG="${VM_NAME}_disk.qcow2"
DISK_SIZE="5G"
CDROM_IMG="SLE-12-SP1-Server-DVD-x86_64-GM-DVD1.iso"
EXTRA_ARGS="netdevice=eth0 netsetup=dhcp autoyast=file:///${VM_NAME}.xml"

qemu-img create -f qcow2 ${DISK_IMG} ${DISK_SIZE}

virsh destroy ${VM_NAME}
virsh undefine ${VM_NAME}

virt-install \
    --name ${VM_NAME} \
    --os-type=${OS_TYPE} \
    --os-variant=${OS_VARIANT} \
    --ram=${RAM} \
    --vcpus=${VCPUS} \
    --disk path=${DISK_IMG},device=disk \
    --graphics vnc,listen=0.0.0.0 \
    --location ${CDROM_IMG} \
    --initrd-inject "${VM_NAME}.xml" \
    --extra-args "${EXTRA_ARGS}"
