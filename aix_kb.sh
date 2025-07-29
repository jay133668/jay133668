#aix vio 進入 root：
oem_setup_env

# 獲取power ha info:
#vios:
oem_setup_env
[ ! -d /tmp/to-ibm ] && mkdir /tmp/to-ibm || echo "folder already exsit"
lspv >> /tmp/to-ibm/script-`hostname`.txt
lsdev -Cc disk >> /tmp/to-ibm/script-`hostname`.txt
gzip /tmp/to-ibm/script-`hostname`.txt
chmod -R 777 /tmp/to-ibm
du -sk /tmp/to-ibm/script-`hostname`.txt.gz
scp /tmp/to-ibm/script-`hostname`.txt.gz emts02@10.122.5.119:/tmp/to-ibm/

#aix:
[ ! -d /tmp/to-ibm ] && mkdir /tmp/to-ibm || echo "folder already exsit"
lspv >> /tmp/to-ibm/script-`hostname`.txt
lsdev -Cc disk >> /tmp/to-ibm/script-`hostname`.txt
cd /usr/es/sbin/cluster/utilities/ 
cldisp >> /tmp/to-ibm/script-`hostname`.txt
cltopinfo >> /tmp/to-ibm/script-`hostname`.txt
clshowres >> /tmp/to-ibm/script-`hostname`.txt
clmgr verify cluster &>> /tmp/to-ibm/script-`hostname`.txt
gzip /tmp/to-ibm/script-`hostname`.txt
chmod -R 777 /tmp/to-ibm
du -sk /tmp/to-ibm/script-`hostname`.txt.gz

################################################################################################
################################################################################################
#nfs server:
hbat=`hostname | cut -c1-2`
echo "/tmp/os_patch   -sec=sys,rw,access=${hbat}vapp01:${hbat}2bat01:${hbat}vdb001:${hbat}app02:${hbat}vdb001:${hbat}ebkdb01,root=${hbat}2bat01" >> /etc/exports
exportfs -v
exportfs -a
exportfs -v
################################################################################################
#nfs client:
[ ! -d /tmp/os_patch ] && mkdir -p /tmp/os_patch && chmod -R 777 /tmp/os_patch
hbat=`hostname | cut -c1-2`
dev_share_ip=10.122.43.115
sdc_share_ip=10.122.20.119
pdc_share_ip=10.122.5.119

case $hbat in
	de) export sip=$dev_share_ip ;;
	sd)	export sip=$sdc_share_ip ;;
	pd)	export sip=$pdc_share_ip ;;
esac

echo "/tmp/os_patch:
        dev             = "/tmp/os_patch"
        vfs             = nfs
        nodename        = $sip
        mount           = true
        options         = rw,bg,hard,intr,sec=sys
        account         = false" >> /etc/filesystems

mount /tmp/os_patch

lsfs -l /tmp/os_patch
ll /tmp/os_patch
