#!/bin/bash

remove_rc_pkg () {
dpkg -l | grep ^rc | cut -d' ' -f3 | sudo xargs dpkg --purge
}


#如何去除UNIX系統下文件中的换行符^M ：
Linux: dos2unix filename
Aix :cat filename | perl -pe '~s/\r//g' > filename
或者cat filename | tr -d "\r" > filename
