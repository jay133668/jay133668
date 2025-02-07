
#!/bin/bash

#$1     pkg
get_all_depends()
{
        apt-rdepends $1 | grep -v "^ "
}


## 遍历命令行参数，参数应为包名。
for pkg in get_all_depends
do
        echo -e "所有依赖共计"$(get_all_depends | wc -w)"个"
        get_all_depends
        i=0
        for depend in get_all_depends
        do
                i=$((i+1))
                echo -e "\033[1;32m正在下载第$i个依赖："$depend "\033[0m"
                apt-get download $depend
        done
done
