
###################################################################
emf=`date +%B`
curyear=`date +%Y`
curmon=`date +%m`
mon=`date "+%b %Y"`
hardlink=https://www.govcert.gov.hk/en/rss_security_alerts.xml
msg_file=/tmp/get_alerts/info/`date +%F`-alert.msg
atf=/tmp/get_alerts/info/all_title_msg
acve=/tmp/get_alerts/info/all_cvenum.msg
alink=/tmp/get_alerts/info/link.msg
aan=/tmp/get_alerts/info/all_alert_num.msg
curl -s $hardlink | egrep -B15 "$mon" | egrep "pubDate|title|guid" > $msg_file
egrep title $msg_file | cut -d ":" -f2  | sed "s#</title>##g" > $atf
egrep title $msg_file | egrep -o "[a-Z][0-9][0-9]-$curmon-[0-9][0-9]" > $acve
egrep guid $msg_file | sed  "s/<guid>//g" | sed  "s#</guid>##g" | awk '{print $1}' > $alink
egrep guid $msg_file | egrep -o "[0-9]{4,}" > $aan
#############################################
for link in `cat $alink`
do
tp=/tmp/get_alerts/info
nf=/$tp/$num-all.msg
cnf=$tp/$num-cve.msg
descf=$tp/$num-desc.msg
detailf=$tp/$num-detailf.msg
link=${link%$'\r'}
curl -s $link -o /tmp/get_alerts/info/$num-all.msg
alnum=`echo $link  | egrep -o "[0-9]{4,}"` 
egrep "<title>" $nf | egrep -o "[a-Z][0-9]{2,}-[0-9]{2,}-[0-9]{2,}" > $cnf
egrep "<title>" $nf | cut -d ":" -f2  | sed "s#</title>##g" > $descf
egrep -i "successful" $nf  > $detailf
dd=`egrep -o "[0-9]{2} $emf $curyear" 1629-all.msg`
echo $dd ; echo $alnum 
cat $cnf $descf $detailf
echo
done
