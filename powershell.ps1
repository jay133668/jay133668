 
 #查看已安裝的軟件 ， 顯示Name,Version
 Get-WmiObject -Class Win32_Product | Select-Object Name,Version