 
 #查看已安裝的軟件 ， 顯示Name,Version
 Get-WmiObject -Class Win32_Product | Select-Object Name,Version
 
#查看已安装程序的详细列表
 msinfo32