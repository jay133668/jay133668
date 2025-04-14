#!/bin/bash

remove_rc_pkg () {
dpkg -l | grep ^rc | cut -d' ' -f3 | sudo xargs dpkg --purge
}


#如何去除UNIX系統下文件中的换行符^M ：
Linux: dos2unix filename
Aix :cat filename | perl -pe '~s/\r//g' > filename
cat file1 | tr -d "^V^M" > file2
或者cat filename | tr -d "\r" > filename

dpkg 狀態解析：
dpkg -l
每条记录对应一个软件包，每条记录的第一， 二， 三个字符是软件包的状态标识， 后边依此是软件包名称，版本号, 和简单描述
。关于每个状态，可以参考man dpkg-query关于每个状态的描述，可以参考man dpkg # 搜索 Package states

第一个字符为期望值，它包括：
u (Unknown) 状态未知，这意味着软件包未安装，并且用户也未发出安装请求。
i (Install) 用户请求安装软件包。
r (Remove) 用户请求卸载软件包。
p (Purge) 用户请求清除软件包。
h (Hold) 用户请求保持软件包版本锁定。
第二个字符是软件包的当前状态，它包括：
n (Not-installed) 软件包未安装。
i (Installed) 软件包安装并完成配置。
c (Config-files) 软件包以前安装过，现在删除了，但是它的配置文件还留在系统中。
U (Unpacked) 软件包被解包，但还未配置。
F (Half-configured) 试图配置软件包，但是失败了。
H (Half-installed)软件包安装，但是但是没有成功。
第三个字符是错误状态，有四种状态。
第一种状态标识没有问题，为空。
其它三种包括：R (Reinst-required) 软件包被破坏
