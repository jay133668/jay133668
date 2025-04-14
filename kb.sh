#!/bin/bash

remove_rc_pkg () {
dpkg -l | grep ^rc | cut -d' ' -f3 | sudo xargs dpkg --purge
}


#如何去除UNIX系統下文件中的换行符^M ：
Linux: dos2unix filename
Aix :cat filename | perl -pe '~s/\r//g' > filename
cat file1 | tr -d "^V^M" > file2
或者cat filename | tr -d "\r" > filename

##########################################################################################################################################
ubuntu通过apt-get获取已安装的package的下载链接或将其下载到本地3種方法：
https://www.cnblogs.com/kaopunotes/p/18593236

方法 1: 获取已安装包的下载链接

    检查已安装包的版本： 首先，确认你需要的软件包是否已安装，以及它的版本信息：

    dpkg -l | grep <package_name>

    示例：

    dpkg -l | grep vim

    获取下载链接： 使用 apt-get download 的 --print-uris 选项打印软件包的下载链接：

    apt-get install --reinstall --print-uris -y <package_name>

    示例：

    apt-get install --reinstall --print-uris -y vim

    输出结果中会包含类似以下的链接：

    'http://archive.ubuntu.com/ubuntu/pool/main/v/vim/vim_8.2.2434-3ubuntu3_amd64.deb'

    手动下载： 根据输出的链接使用 wget 或其他工具下载：

    wget http://archive.ubuntu.com/ubuntu/pool/main/v/vim/vim_8.2.2434-3ubuntu3_amd64.deb

方法 2: 直接将包下载到本地

如果你只想将已安装的软件包（包括依赖项）直接下载到本地，可以使用以下步骤：
1. 使用 apt-get download

apt-get download 可以直接下载指定的软件包：

apt-get download <package_name>

示例：

apt-get download vim

下载的 .deb 文件会保存到当前目录。
2. 使用 apt-get 下载依赖项

如果需要同时下载包的依赖项，可以使用以下方法：

    安装 apt-rdepends 工具：

    sudo apt-get install apt-rdepends

    获取软件包及其所有依赖项的下载链接：

    apt-rdepends <package_name> | grep -v "^ " | xargs apt-get download

方法 3: 使用 apt-offline 工具（推荐离线需求）

apt-offline 是一个专门用于离线管理包的工具，适合在一台联网的机器上下载软件包及其依赖项，然后传输到离线的机器上进行安装。

    安装 apt-offline：

    sudo apt-get install apt-offline

    生成请求文件（在目标机器上）：

    apt-offline set package-download.sig --install-packages <package_name>

    在联网机器上下载软件包： 将生成的 package-download.sig 文件复制到联网机器，然后运行以下命令下载软件包和依赖项：

    apt-offline get package-download.sig --bundle package-bundle.zip

    将下载的包安装到目标机器： 将下载的 package-bundle.zip 复制回目标机器，并安装：

    apt-offline install package-bundle.zip

总结

    如果只需要获取单个已安装包的下载链接，使用 apt-get install --print-uris。
    如果需要下载包及其依赖项，使用 apt-get download 或 apt-rdepends。
    如果需要更复杂的离线包管理，推荐使用 apt-offline 工具。

##########################################################################################################################################
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
##########################################################################################################################################
Linux中date 以及date -d命令的详解：
https://blog.csdn.net/wnccmyr/article/details/109325970
##########################################################################################################################################
两台WIN11通过网线连接 一副键鼠/屏幕 控制两台主机+共享网络
https://blog.csdn.net/m0_61367230/article/details/140712562
##########################################################################################################################################
wget命令详解
https://www.jianshu.com/p/2e2ba8ecc22a
##########################################################################################################################################
linux命令sort按照指定的字段排序
https://worktile.com/kb/ask/486014.html
##########################################################################################################################################
Linux的YUM仓库搭建及错误解决方案
https://blog.csdn.net/thetender/article/details/139842127
##########################################################################################################################################
(第16课)Linux基础(shell脚本列表与数组)
https://zhuanlan.zhihu.com/p/483399604
##########################################################################################################################################
