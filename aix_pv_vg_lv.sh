
1.storage 建立新lun map to server:
2.on server run cmd:
cfgmgr -v
lspv

chdev -l {newhdisk} -a pv=yes 
lspv
mkvg -y newvg {newhdisk}
or
extendvg myvg {newhdisk}

mklv -y mylv -t jfs2 -s n myvg 10G 
or
mklv -y mylv -t jfs2 -s n myvg 100 

crfs -v jfs2 -d mylv -m /data -A yes

# crfs 有問題的話 # 修复文件系统再 crfs
fsck -y /dev/dbbaklv
crfs -v jfs2 -d mylv -m /data -A yes

# 检查并修复文件系统
sysdumpdev -l                   # 确认dump设备‌
fuser -ku /dbbak && umount /dbbak  # 终止进程并卸载
fsck -y /dev/dbbaklv            # 修复文件系统
logform /dev/loglv              # 修复日志设备‌
mount /dbbak                    # 重新挂载‌

#######################################
extend mount point size:
1.storage 建立新lun map to server:
2.on server run cmd:
cfgmgr -v
lspv
hdisk1          00f87d7a4fe73cd8                    oravg           active
hdisk0          00cbe2208350c6e1                    rootvg          active
hdisk3          none                                None

chdev -l hdisk3 -a pv=yes

lsvg rootvg | grep "FREE PPs"  
extendvg rootvg hdisk3
lsvg rootvg | grep "FREE PPs"  

lslv <lv_name> | grep "MAX LPs"  # 查看最大 LP 限制  
lslv <lv_name> | grep "LPs"      # 查看已用 LP 数量  
#若遇到 0516-787 extendlv: Maximum allocation 错误，需扩展 LV 的 LP 容量上限：
chlv -x <new_max_lps> <lv_name>  # 修改最大 LP 数量 
extendlv <lv_name> <新增PP数量>
extendlv d01lv 20

chfs -a size=+20G /d01
or
chfs -a size=46G /d01
################################################

#查看vg ,lv ,mount point屬於哪個:
#!/bin/bash
all_mount_point () {
        all_mp=`df -g |awk '{print $7}' | grep /`
        echo -e "`hostname` all mount point:\n$all_mp"
}
empty_out () {
        echo -e "parameter cant not empty !!! \neg: $0 {mount point} \neg: $0 /home"
        all_mount_point
        exit 1
}

export mp=$1
mplv=`df -g $mp |awk '{print $1}' | sed -n 2p | awk -F '/' '{print $3}'`
all_vg=`lspv | egrep "active|concurrent" |awk '{print $3}' | uniq`

[ -z $1 ] && empty_out

for vg in $all_vg
do
vgstat=`lsvg $vg | egrep -i "total|free|used" | egrep -i pps`
vgmsg () {
echo ; echo -e "mount_point: $mp \nlv: $mplv \nvg: $vg" ; echo ; echo -e "$vgstat"
}
lsvg -l $vg | egrep -wi $mplv ; [ $? == 0 ] && vgmsg
done


##########################################

bootinfo -s hdisk1

1. 重新扫描硬盘设备‌
运行 cfgmgr 命令强制系统重新检测磁盘配置，适用于存储扩容或设备属性变更的场景23：


cfgmgr -v
#此命令会扫描所有设备并更新磁盘信息（包括容量变更）。

‌2. 查看磁盘更新后的大小‌
确认 hdisk1 的新容量是否已识别：

# 方法一：使用 bootinfo 直接显示容量（单位：GB）
bootinfo -s hdisk1

# 方法二：通过 lspv 查看详细信息
lspv hdisk1 | grep "TOTAL PP"
输出示例：

text
Copy Code
TOTAL PPs:            546 (34 gigabytes)  # 若容量已更新，此处数值会变化
‌3. 特殊情况处理‌
若存储扩容后 cfgmgr 未生效，可能需要手动重置磁盘属性：

# 删除并重新配置设备
rmdev -l hdisk1 -d  # 移除设备
cfgmgr -v           # 重新扫描并加载设备
‌4. 验证卷组信息（如磁盘属于卷组）‌
若 hdisk1 已加入卷组（VG），需确保卷组信息同步更新78：

# 检查卷组剩余空间
lsvg <vg_name> | grep "FREE PP"
# 若需扩展卷组容量
chvg -g <vg_name>


