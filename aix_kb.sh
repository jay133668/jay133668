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

