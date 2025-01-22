
#下載網頁內所有 .deb 結尾的安裝包
# wget  -r -l1 -A.deb --np http://10.26.177.137/samba/base-deb/b/ -e robots=off

#下載網頁內所有 .deb 結尾的安裝包后，再安裝
# wget  -r -l1 -A.deb --np http://10.26.177.137/samba/base-deb/b/ -e robots=off && dpkg -i *

#
 # wget  -r -l0 -A.deb --no-parent http://10.26.177.137/samba/ -e robots=off


 wget_info () {
    echo """-r, —recursive（递归） specify recursive download.（指定递归下载）

-k, —convert-links（转换链接） make links in downloaded HTML point to local files.（将下载的HTML页面中的链接转换为相对链接即本地链接）

-p, —page-requisites（页面必需元素） get all images, etc. needed to display HTML page.（下载所有的图片等页面显示所需的内容）

-np, —no-parent（不追溯至父级） don’t ascend to the parent directory.

-a<日志文件>：在指定的日志文件中记录资料的执行过程；

-A<后缀名>：指定要下载文件的后缀名，多个后缀名之间使用逗号进行分隔；

-b：进行后台的方式运行wget； -B<连接地址>：设置参考的连接地址的基地地址；

-c：继续执行上次终端的任务；

-C<标志>：设置服务器数据块功能标志on为激活，off为关闭，默认值为on；

-d：调试模式运行指令；

-D<域名列表>：设置顺着的域名列表，域名之间用“，”分隔；

-e<指令>：作为文件“.wgetrc”中的一部分执行指定的指令；

-h：显示指令帮助信息； -i<文件>：从指定文件获取要下载的URL地址；

-l<目录列表>：设置顺着的目录列表，多个目录用“，”分隔； -L：仅顺着关联的连接；

-r：递归下载方式；

-nc：文件存在时，下载文件不覆盖原有文件；

-nv：下载时只显示更新和出错信息，不显示指令的详细执行过程；

-q：不显示指令执行过程；

-nh：不查询主机名称；

-v：显示详细执行过程；

-V：显示版本信息；

—passive-ftp：使用被动模式PASV连接FTP服务器;

—follow-ftp：从HTML文件中下载FTP连接文件。"""
 }
 wget_info
