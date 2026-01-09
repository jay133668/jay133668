

echo "/nim   -sec=sys,rw,access=pdcapp01:pdcapp02:pd2bat01:pd2bat02:pdcdb001:pdcdb002:pdcebkdb01:pdcebkdb02:pdcnim01:pdcnim02,root=`hostname`" >> /etc/exports

keytool -list -v -keystore /usr/java8_64/jre/lib/security/cacerts -storepass changeit | egrep ogc
/usr/java8_64/jre/lib/security/cacerts

keytool -list -v -keystore /usr/java8_64/jre/lib/security/cacerts -storepass changeit | egrep ogc
Alias name: ogcio_rootca256-2
Alias name: ogcio_rootca


keytool -exportcert -alias "ogcio_rootca" -keystore /usr/java8_64/jre/lib/security/cacerts -storepass changeit -rfc -file rca.pem
keytool -exportcert -alias "ogcio_rootca256-2" -keystore /usr/java8_64/jre/lib/security/cacerts -storepass changeit -rfc -file rca2.pem

keytool -import -alias ogcio_rootca -file /tmp/secure/rca.pem -keystore /usr/java8_64/jre/lib/security/cacerts -storepass changeit
keytool -import -alias ogcio_rootca256-2 -file /tmp/secure/rca2.pem -keystore /usr/java8_64/jre/lib/security/cacerts -storepass changeit


‌跳过验证‌（仅调试用）：
openssl s_client -connect uat.int1.cerm.customs.hksarg:8443 -showcerts -verify 0 </dev/null

#这将生成：
openssl s_client -connect uat.int1.cerm.customs.hksarg:8443 -showcerts </dev/null 2>/dev/null | awk '/BEGIN CERTIFICATE/{i++} {print > "cert_" i ".pem"}'
cert_1.pem（服务器证书）
cert_2.pem（中间CA证书，如果有）

#查看证书详情：
openssl x509 -in cert_1.pem -text -noout
#检查有效期‌
openssl x509 -in cert.pem -dates -noout

#edi server:
#在Vcenter 插入 iso 去DVD rom
hbat=`hostname | cut -c1-2`
dev_share_ip=10.122.38.116
sdc_share_ip=10.122.21.101
pdc_share_ip=10.122.6.101
case $hbat in
	de) export sip=$dev_share_ip ;;
	sd)	export sip=$sdc_share_ip ;;
	pd)	export sip=$pdc_share_ip ;;
esac
showmount -e $sip

echo "/mnt/sr1 *(rw,sync,no_root_squash)" >> /etc/exports
mount /dev/sr1 /mnt/sr1

exportfs -v | grep sr1
exportfs -rv | grep sr1
exportfs -v | grep sr1
showmount -e $sip
############################################################################
#bat server：
mkdir /tmp/patch
chmod 777 /tmp/patch
[ ! -d /tmp/patch ] && mkdir -p /tmp/patch && chmod -R 777 /tmp/patch
hbat=`hostname | cut -c1-2`
dev_share_ip=10.122.38.116
sdc_share_ip=10.122.21.101
pdc_share_ip=10.122.6.101

case $hbat in
	de) export sip=$dev_share_ip ;;
	sd)	export sip=$sdc_share_ip ;;
	pd)	export sip=$pdc_share_ip ;;
esac
echo "/tmp/patch:
        dev             = "/mnt/sr1"
        vfs             = nfs
        nodename        = $sip
        mount           = true
        options         = rw,bg,hard,intr,sec=sys
        account         = false" >> /etc/filesystems

#bat nfs server:
mkdir /tmp/os_patch
chmod 777 /tmp/os_patch
hbat=`hostname | cut -c1-2`
echo "/tmp/os_patch   -sec=sys,rw,access=${hbat}capp01:${hbat}2bat01:${hbat}cdb001:${hbat}capp02:${hbat}cdb001:${hbat}cebkdb01,root=${hbat}2bat01" >> /etc/exports
exportfs -v
exportfs -a
exportfs -v

#nfs client:
[ ! -d /tmp/os_patch ] && mkdir -p /tmp/os_patch && chmod -R 777 /tmp/os_patch
cp -p /etc/filesystems /etc/filesystems-`date +%F`
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
####################################################

# aix 上 mount 第二台server 的 nfs :

devedi01 > de2bat01 > devapp01，devdb001，devebkdb01

‌#2. 解决方案‌
‌#步骤1：修改NFS保留端口设置‌
‌#临时生效‌（立即生效，重启后失效）：
nfso -o nfs_use_reserved_ports=1

#永久生效‌（需重启后保持配置）：
nfso -p -o nfs_use_reserved_ports=1

# 還有可能 devedi01 上的nfs 有問題 出現下面Warning：
systemctl status nfs-server.service

Warning: Journal has been rotated since unit was started. Log output is incomplete or unavailable. 


mount /tmp/os_patch

upgrade前準備backup:

lspv
echo
lsvg
echo
lsvg -o
echo
df -g
echo
for i in `lsvg -o`; do echo $i >> /tmp/secure/`hostname`-vg-`date +%F` ; lsvg -l $i ; done
echo
for i in `lsdev -Cc disk | awk '{print $1}'`; do  lsmpio -ql $i ;done

lspv | sort -k3 >> /tmp/secure/`hostname`-upos-`date +%F`
echo >> /tmp/secure/`hostname`-upos-`date +%F`
lsvg | sort >> /tmp/secure/`hostname`-upos-`date +%F`
echo >> /tmp/secure/`hostname`-upos-`date +%F`
df -g >> /tmp/secure/`hostname`-upos-`date +%F`
for i in `lsdev -Cc disk | awk '{print $1}'`; do  lsmpio -ql $i >> /tmp/secure/`hostname`-pv-`date +%F`; done
for i in `lsvg | sort`; do echo $i >> /tmp/secure/`hostname`-vg-`date +%F` ; lsvg -l $i >> /tmp/secure/`hostname`-vg-`date +%F`; done
chmod 777 /tmp/secure/`hostname`*



lslpp -l cluster.es.server.rte
lssrc -g cluster
clRGinfo
/usr/es/sbin/cluster/utilities/cltopinfo

# check & stop powerha mon:
#check：
/usr/sbin/rsct/bin/hags_listdms -s cthags
#stop：
/usr/sbin/rsct/bin/hags_disable_client_kill -s cthags
/usr/sbin/rsct/bin/hags_stopdms -s cthags

smitty clstop
clstop -n pdcdb002

# start 
/usr/sbin/rsct/bin/hags_enable_client_kill -s cthags
/usr/sbin/rsct/bin/hags_startdms -s cthags

cp -p /usr/java8_64/jre/lib/security/cacerts /usr/java8_64/jre/lib/security/cacerts-`date +%F`
ll /usr/java8_64/jre/lib/security/cacerts*
inutoc /tmp/os_patch
ls -l /tmp/os_patch/aix7200-05-09/.toc
/tmp/os_patch/aix7200-05-09/.toc
smitty update_all
shutdown -rF

# pdcdb001 uograde reboot 后:
dbbkvg=`lspv | egrep -v "rootvg|concurrent|active" | awk '{print $3}' | sort -k3 | uniq`
for i in `$dbbkvg`
do
varyonvg $i
done

#db:
lspv
lsvg
lsdev -Cc disk
lsvg -o
lsmpio -ql hdisk4
lscfg -lv hdisk4 


root@devdb001(/)# rmdev -dl hdisk6
hdisk6 deleted
root@devdb001(/)# rmdev -dl hdisk7
hdisk7 deleted
root@devdb001(/)# rmdev -dl hdisk8
hdisk8 deleted

#exportvg orabin11vg
#exportvg orabinvg
#exportvg oradatavg


root@sdcebkdb01(/tmp/os_patch/aix7200-05-09)# df -g | egrep "datauplv|dbbin12lv|orabin11glv"
/dev/bkdatauplv    398.00     65.01   84%     1564     1% /bk/db1/11gdata
/dev/bkorabin11glv     18.00      2.73   85%    43317     6% /bk/db1/11gd01
/dev/bkdbbin12lv     48.00     21.38   56%   146938     3% /bk/u01

importvg -y bkorabinvg -n hdisk6
importvg -y bkoradatavg -n hdisk7
importvg -y bkorabin11vg -n hdisk8

varyonvg bkorabinvg
varyonvg bkoradatavg
varyonvg bkorabin11vg

mount /db1/11gd01
mount /db1/11gdata
mount /bk/u01

umount /bk/u01           # 卸载现有文件系统（若已挂载）  
backup_data /bk/u01      # 备份数据（如需保留）  
rmfs /bk/u01             # 删除冲突文件系统  
crfs -v jfs2 -d /dev/dbbin12lv -m /bk/u01 -A yes  # 新建文件系统  
mount /bk/u01

#app:
varyonvg datavg
varyoffvg datavg

cat /etc/exports
/data/ftp/pub -sec=sys,rw,access=sdcapp01:sd2bat01:sdcdb001,root=sdcapp01
/data/prodenv -sec=sys,rw,access=sdcapp01:sd2bat01:sdcdb001,root=sdcapp01

showmount -e localhost
exportfs -v
exportfs -a
exportfs -v


fallback OS：
hmc open console > restart aix > press 1 進入 SMS 模式

1.   Select Install/Boot Device
3.   Hard Drive
1.   SCSI

aix 如何把rootvg_bk 加入 boot list ，在HMC 中選擇:
lspv | grep rootvg_bk    # 确认hdiskX属于rootvg_bk
lslv -m hd5             # 检查引导盘hd5位置
bosboot -ad /dev/hdisk4  # 在rootvg_bk磁盘创建引导记录
bootlist -m normal hdisk0 hdiskX cd0

extendvg rootvg hdisk4    # 若未加入需先执行
mklv -t boot -y hd5 rootvg 1 hdisk4  # 在hdisk4上创建hd5
bosboot -ad /dev/hdisk4   # 重新执行引导镜像创建
bootlist -m normal hdisk0 hdisk4 cd0  # 添加hdisk4到启动顺序
bootinfo -B hdisk4        # 返回1表示可引导

chlv -n hd5_bak hd5      # 将原hd5重命名备份
mklv -t boot -y hd5 rootvg 1 hdisk4  # 重新执行创建
bosboot -ad /dev/hdisk4   # 生成引导镜像
bootlist -m normal hdisk4 # 更新启动列表

fallback OS:

lscfg -l hdisk4 -v
mkvg -f -y rootvg_bk hdisk4 
chlv -n hd5_bak hd5
mklv -t boot -y hd5 rootvg_bk 1 hdisk4
bosboot -ad /dev/hdisk4 

########################################################################################################################################################
# powerha 轉移節點后 ，aix vg clean cache:
F1000C0230320000 0000002A bk18cvg
00CBE21000004B00000001998FA1B511

F1000C0230324800 0000002C bkoravg
00CBE21000004B00000001998FA19378

F1000C0230329000 0000002C bkarchvg
00CBE21000004B00000001998FA1A712

# 查看處理vg緩存
echo vg | kdb
root@pdcebkdb01(/)# kdb
0000000000001000 0000000007150000 start+000FD8
(0)> vg
F1000C023032B000 0000002B bk18cvg
(0)> vg F1000C023032B000
vg_id.............. 00CBE20000004B0000000199932C6059
root@pdcebkdb01(/)# lvaryoffvg -g 00CBE20000004B0000000199932C6059
########################################################################################################################################################
exportvg bk18cvg
importvg -fy bk18cvg hdisk0

# root@pdcebkdb02(/)# varyoffvg bk18cvg
# varyoffvg bkoravg
# varyoffvg bkora18cvg
 
varyonvg bk18cvg
chfs -a mountguard=no /bk/oradata/ebkprod/arch

# 如果vg 裏面沒有lv,要建立 lv 和 文件系統
importvg [vg]   + smitty mklv > smitty jfs2 > mount folder 

# 如果提示delete mountguard
[mount: /dev/bkoraarchlv  on /bk/d01/app/oracle
0506-365 Cannot mount guarded filesystem.
The filesystem is potentially mounted on another node.]

chfs -a mountguard=no /bk/d01/app/oracle
 mount -o noguard  /bk/d01/app/oracle
 mount /bk/oradata/ebkprod/arch
########################################################################################################################
####！！！ vg mount point 異常時候處理step
root@pdcebkdb01(/script/system/snapshot)# lsvg -l bkoravg

bkoravg:
LV NAME             TYPE       LPs     PPs     PVs  LV STATE      MOUNT POINT
bkorabinlv          jfs2       48      48      1    closed/syncd  #
bkoradatalv         jfs2       40      40      1    open/syncd    /bk/oradata
bkloglv00           jfs2log    1       1       1    open/syncd    N/A

del /etc/filesystems 裏面的 /bk/d01/app/oracle  &  /bk/oradata 相關cfg
#建立文件系統在 /etc/filesystems 
crfs -v jfs2 -d bkorabinlv -m /bk/d01/app/oracle -A yes
crfs -v jfs2 -d bkoradatalv -m /bk/oradata -A yes
#根據 folder 更改文件系統 mount point
chlv -L {new_folder} {old_folder}
chfs -m /bk/d01/app/oracle /dev/bkorabinlv
chfs -m /bk/oradata /dev/bkoradatalv
#根據 lv 更改文件系統 mount point
chlv -L {new_folder} {lv}
chlv -L /bk/d01/app/oracle bkorabinlv
chlv -L /bk/oradata bkoradatalv

hddd=hdisk23
# 查看 ODM PVID数据  pvid： 00CBE200 96A8F09F 
odmget -q "name=$hddd and attribute=pvid" CuAt | egrep value
# 直接从磁盘物理读取 PVID
lquerypv -h /dev/$hddd 80 10
00000080   00CBE200 96A8F09F 00000000 00000000  |................|
# 查看磁盘 VGDA 记录的 PVID
readvgda $hddd | grep pv_id
pv_id:          00cbe20096a8f09f

lqueryvg -Ptp $hddd
Physical:       00cbe20096a8f09f                2   0

#同步VGDA 的 pvid 到 ODM： 如果物理磁盘上有 PVID 但 ODM 缺失（显示为 none），可运行以下命令强制 ODM 重新读取磁盘：
chdev -l $hddd -a pv=yes

# 处理 PVID 改变：如前所述，若 PVID 已变且与 VGDA 不符，请直接使用 recreatevg 而非 importvg
hddd=hdisk10
odmget -q "name=$hddd and attribute=pvid" CuAt | egrep value
readvgda $hddd | grep pv_id
lqueryvg -Ptp $hddd
lquerypv -h /dev/$hddd 80 10
#######################################################################################################
#同步VGDA 的 pvid 到 ODM script:
for i in {hdisk10,hdisk13}
do
	old_pvid=`lspv | egrep $i | awk '{print $2}'`
	new_pvid=$(readvgda $i | grep pv_id | awk '{print $2}')
	odmget -q "name=$i and attribute=pvid" CuAt > /script/system/snapshot/odm/${i}CuAt_backup.txt
	odmget -q "name=hdisk10 and attribute=pvid" CuAt | sed "s/$old_pvid/$new_pvid/" > /script/system/snapshot/odm/${i}CuAt_new.txt
	odmchange -o CuAt -q "name=$i and attribute=pvid" /script/system/snapshot/odm/${i}CuAt_new.txt
done

#######################################################################################################
# power ha manage vg error：
root@pdcebkdb01(/script/system/snapshot)# lspv
hdisk2          00f87d7a4fe73cd8                    oravg           concurrent
hdisk6          00f87d7a4fe73cd8                    oravg           concurrent

chdev -l hdisk2 -a pv=clear

hdisk2          none                                None
recreatevg -y bkoravg -Y bk -L /bk -O hdisk2

########################################################################################################################################################

root@pdcebkdb01(/)# smitty mklv
[TOP]                                                   [Entry Fields]
  Logical volume NAME                                [bkoraarchlv]
* VOLUME GROUP name                                   bk18cvg
* Number of LOGICAL PARTITIONS                       [36]
  PHYSICAL VOLUME names                              []
  Logical volume TYPE                                [jfs2]


root@pdcebkdb01(/)# smitty mklv
[TOP]                                                   [Entry Fields]
  Logical volume NAME                                [bkloglv03]
* VOLUME GROUP name                                   bk18cvg
* Number of LOGICAL PARTITIONS                       [1]
  PHYSICAL VOLUME names                              []
 Logical volume TYPE                                [jfs2log]

root@pdcebkdb01(/)# smitty jfs2
                                            [Entry Fields]
* LOGICAL VOLUME name                                 bkoraarchlv
* MOUNT POINT                                        [/bk/oradata/ebkprod/arch]

################################################################################

 mount /bk/oradata/ebkprod/arch
 
 df -g /bk/oradata/ebkprod/arch
 /dev/bkoraarchlv      0.28      0.28    1%        4     1% /bk/oradata/ebkprod/arch

 
 root@pdcebkdb01(/)# smitty chlv
  MAXIMUM NUMBER of LOGICAL PARTITIONS               [5120]  # 512 > 5120

chfs -a size=4608M /bk/oradata/ebkprod/arch

df -g /bk/oradata/ebkprod/arch
/dev/bkoraarchlv      4.50      4.50    1%        4     1% /bk/oradata/ebkprod/arch
################################################################################
