INSTALL_IMG="SLE-12-SP2-Server-DVD-x86_64-GM-DVD1.iso"
OS_VARIANT="sles12sp2"
BASE_NAME="sles12sp2_minimum"

NOW=$(date '+%Y-%m-%d_%H-%M-%S')
VM_NAME="${BASE_NAME}_${NOW}"

OS_TYPE="Linux"
RAM="1024"
VCPUS="1"

DISK_IMG="${VM_NAME}_disk.qcow2"
DISK_SIZE="5G"
EXTRA_ARGS="netdevice=eth0 netsetup=dhcp autoyast=file:///${BASE_NAME}.xml"

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
    --location ${INSTALL_IMG} \
    --initrd-inject "${BASE_NAME}.xml" \
    --extra-args "${EXTRA_ARGS}"
