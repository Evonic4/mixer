#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

fhome=/usr/share/mixer/
fPID=$fhome"pid.txt"


function Init() 
{
name=$(sed -n 1"p" $fhome"settings.conf" | tr -d '\r')
sec=$(sed -n 2"p" $fhome"settings.conf" | tr -d '\r')
base_url=$(sed -n 3"p" $fhome"settings.conf" | tr -d '\r')
login=$(sed -n 4"p" $fhome"settings.conf" | tr -d '\r')
password=$(sed -n 5"p" $fhome"settings.conf" | tr -d '\r')
structure=$(sed -n 6"p" $fhome"settings.conf" | tr -d '\r')
MessageId=$(sed -n 7"p" $fhome"settings.conf" | tr -d '\r')
rqses=$(sed -n 8"p" $fhome"settings.conf" | tr -d '\r')
proxy=$(sed -n 9"p" $fhome"settings.conf" | tr -d '\r')
domenn=$(sed -n 10"p" $fhome"settings.conf" | tr -d '\r')
wm=$(sed -n 11"p" $fhome"settings.conf" | tr -d '\r')
plus_day=$(sed -n 12"p" $fhome"settings.conf" | tr -d '\r')
TOKEN=""
Errorer="0"
pushg_ip=$(sed -n 13"p" $fhome"settings.conf" | tr -d '\r')
pushg_port=$(sed -n 14"p" $fhome"settings.conf" | tr -d '\r')

AirShopping_eikr1="0"
AirShopping_eikr2="0"	#Сервис временно недоступен
AirShopping_eikr3="0"
}


function logger()
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`
echo $date1" mixer_"$name": "$1
}

constructor_login ()
{
local dgod=`date '+%Y-%m-%d'`
local dch=`date '+%H:%M:%S'`
logger "start constructor_login"
echo > $fhome$out".txt"

echo "#!/bin/bash" > $fhome$out".sh"
echo "export PATH=\"$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin\"" >> $fhome$out".sh"

if [ -z "$proxy" ]; then
echo "curl -w \"@curl-format.txt\" -i -m "$wm" --location --request POST 'https://"$base_url"/api/Accounts/login' \\" >> $fhome$out".sh"
else
echo "curl -w \"@curl-format.txt\" -i --proxy "$proxy" -m "$wm" --location --request POST 'https://"$base_url"/api/Accounts/login' \\" >> $fhome$out".sh"
fi

echo "--header 'appId: <string>' \\" >> $fhome$out".sh"
echo "--header 'Content-Type: application/xml' \\" >> $fhome$out".sh"
echo "--data '<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> $fhome$out".sh"

echo "<MixEnv:Envelope xmlns:MixEnv=\"https://www."$domenn".com/API/XSD/"$domenn"_envelope/1_05\">" >> $fhome$out".sh"
echo "    <Header/>" >> $fhome$out".sh"
echo "    <Body id=\"ID1\">" >> $fhome$out".sh"
echo "        <MessageInfo MessageId=\""$MessageId"\" TimeSent=\""$dgod"T"$dch"Z\" />" >> $fhome$out".sh"
echo "        <AppData>" >> $fhome$out".sh"
echo "            <auth:Auth xmlns:auth=\"https://www."$domenn".com/API/XSD/"$domenn"_auth/1_01\">" >> $fhome$out".sh"


echo "                <Login>"$login"</Login>" >> $fhome$out".sh"
echo "                <Password>"$password"</Password>" >> $fhome$out".sh"
echo "                <StructureUnitID>"$structure"</StructureUnitID>" >> $fhome$out".sh"
echo "            </auth:Auth>" >> $fhome$out".sh"
echo "        </AppData>" >> $fhome$out".sh"
echo "    </Body>" >> $fhome$out".sh"
echo "</MixEnv:Envelope>' > "$fhome$out".txt" >> $fhome$out".sh"

$fhome"setup.sh"

#echo $(date -d "$RTIME 23 hours" +%Y%m%d%H%M%S | tr -d '\r') > $fhome"token_date.txt"
}



constructor_AirShopping ()
{
local dgod=`date '+%Y-%m-%d'`
local dch=`date '+%H:%M:%S'`
go="1"
logger "start constructor_AirShopping"
echo > $fhome$out".txt"

local data_sh=`date -d "$RTIME $plus_day day" +%Y-%m-%d`
logger $remark" data_sh="$data_sh
str_col=$(grep -cv "^---" $fhome"lk.txt")
rnd=$((1 + $RANDOM % $str_col))
me=$(sed -n $rnd"p" $fhome"lk.txt" | tr -d '\r')
me1=$(echo $me | awk '{print $1}' )
me2=$(echo $me | awk '{print $2}' )
logger $remark" me1="$me1
logger $remark" me2="$me2

TOKEN=$(sed -n 1"p" $fhome"token.txt" | tr -d '\r')
if [ -z "$TOKEN" ]; then
	logger $remark" ERROR1 TOKEN=NULL"
	start_login;
	TOKEN=$(sed -n 1"p" $fhome"token.txt" | tr -d '\r')
	if [ -z "$TOKEN" ]; then
		#токена нет 2 раза
		logger $remark" ERROR2 TOKEN=NULL"
		go="0"
	fi
fi


if [ "$go" == "1" ]; then
echo "#!/bin/bash" > $fhome$out".sh"
echo "export PATH=\"$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin\"" >> $fhome$out".sh"

if [ -z "$proxy" ]; then
echo "curl -w \"@curl-format.txt\" -i -m "$wm" --location --request POST 'https://"$base_url"/api/Order/airshopping' \\" >> $fhome$out".sh"
else
echo "curl -w \"@curl-format.txt\" -i --proxy "$proxy" -m "$wm" --location --request POST 'https://"$base_url"/api/Order/airshopping' \\" >> $fhome$out".sh"
fi

echo "--header 'appId: <string>' \\" >> $fhome$out".sh"
echo "--header 'Content-Type: application/xml' \\" >> $fhome$out".sh"
echo "--header 'Authorization: Bearer "$TOKEN"' \\" >> $fhome$out".sh"
echo "--data '<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> $fhome$out".sh"

echo "<MixEnv:Envelope xmlns:MixEnv=\"https://www."$domenn".com/API/XSD/"$domenn"_envelope/1_06\">" >> $fhome$out".sh"
echo "    <Header/>" >> $fhome$out".sh"
echo "    <Body>" >> $fhome$out".sh"
echo "        <MessageInfo MessageId=\""$MessageId"\" TimeSent=\""$dgod"T"$dch"Z\" />" >> $fhome$out".sh"
echo "        <AppData>" >> $fhome$out".sh"
echo "            <shop:Mixvel_AirShoppingRQ xmlns:shop=\"https://www."$domenn".com/API/XSD/Mixvel_AirShoppingRQ/1_01\">" >> $fhome$out".sh"
echo "                <Request>" >> $fhome$out".sh"
echo "                    <FlightRequest>" >> $fhome$out".sh"
echo "                        <FlightRequestOriginDestinationsCriteria>" >> $fhome$out".sh"
echo "                            <OriginDestCriteria>" >> $fhome$out".sh"
echo "                                <CabinType>" >> $fhome$out".sh"
echo "                                    <CabinTypeCode>Economy</CabinTypeCode>" >> $fhome$out".sh"
echo "                                    <PrefLevel>" >> $fhome$out".sh"
echo "                                        <PrefLevelCode>Required</PrefLevelCode>" >> $fhome$out".sh"
echo "                                    </PrefLevel>" >> $fhome$out".sh"
echo "                                </CabinType>" >> $fhome$out".sh"
echo "                                <DestArrivalCriteria>" >> $fhome$out".sh"

echo "                                    <IATA_LocationCode>"$me2"</IATA_LocationCode>" >> $fhome$out".sh"
echo "                                </DestArrivalCriteria>" >> $fhome$out".sh"
echo "                                <OriginDepCriteria>" >> $fhome$out".sh"
echo "                                    <DateRangeStart>"$data_sh"</DateRangeStart>" >> $fhome$out".sh"
echo "                                    <DateRangeEnd>"$data_sh"</DateRangeEnd>" >> $fhome$out".sh"
echo "                                    <IATA_LocationCode>"$me1"</IATA_LocationCode>" >> $fhome$out".sh"

echo "                                </OriginDepCriteria>" >> $fhome$out".sh"
echo "                            </OriginDestCriteria>" >> $fhome$out".sh"
echo "                        </FlightRequestOriginDestinationsCriteria>" >> $fhome$out".sh"
echo "                    </FlightRequest>" >> $fhome$out".sh"
echo "                    <Paxs>" >> $fhome$out".sh"
echo "                        <Pax>" >> $fhome$out".sh"
echo "                            <PaxID>Pax-1</PaxID>" >> $fhome$out".sh"
echo "                            <PTC>ADT</PTC>" >> $fhome$out".sh"
echo "                        </Pax>" >> $fhome$out".sh"
echo "                    </Paxs>" >> $fhome$out".sh"
echo "                </Request>" >> $fhome$out".sh"
echo "            </shop:Mixvel_AirShoppingRQ>" >> $fhome$out".sh"
echo "        </AppData>" >> $fhome$out".sh"
echo "    </Body>" >> $fhome$out".sh"
echo "</MixEnv:Envelope>' > "$fhome$out".txt" >> $fhome$out".sh"

$fhome"setup.sh"
fi
}



post_processing ()
{
logger "start post_processing "$out"("$remark")"
err=""
$fhome$out".sh" 1>$fhome$out".out" 2>$fhome$out"1.out"
time_total=$(grep "time_total" $fhome$out".txt" | awk -F":" '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')
logger $remark" time_total="$time_total
httprscode=$(grep "HTTP/2" $fhome$out".txt" | awk '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
logger $remark" httprscode="$httprscode

[ -z "$httprscode" ] && httprscode=0

if [ "$httprscode" -eq "200" ]; then
	if [ "$(grep -c "ErrorType" $fhome$out".txt")" -gt "0" ]; then
		#ERROR2 no RS
		logger $remark" ERROR2 no RS"
		cat $fhome$out".out"
		Errorer="2"
		err=$(grep "DescText" $fhome$out".txt" | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed 's/^[ \t]*//;s/[ \t]*$//')
		if [ "$(echo $err | grep -c "Сервис временно недоступен")" -gt "0" ]; then
			Errorer="3"
			#situ1=$((situ1+1))
			logger $remark" ERROR3 err="$err
			else
			logger $remark" ERROR2 err="$err
		fi
	else #нет ошибок
		logger $remark" MessageId="$(grep MessageId $fhome$out".txt" | awk -F"=" '{print $2}' | awk '{print $1}' | sed 's/\"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
		[ "$remark" == "Login" ] && TOKEN=$(grep Token $fhome$out".txt" | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed 's/^[ \t]*//;s/[ \t]*$//') && echo $TOKEN > $fhome"token.txt"
		Errorer="0"
	fi
else
#ERROR1 RQS CODE NOT 200
logger $remark" ERROR1 RQS code="$httprscode
Errorer="1"
cat $fhome$out".txt"

#err=$(grep "DescText" $fhome$out".txt" | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed 's/^[ \t]*//;s/[ \t]*$//')
if [ "$(grep -c "invalid_token" $fhome$out".txt")" -gt "0" ]; then
	Errorer="4"
fi

fi

logger "Errorer="$Errorer
}


zapushgateway ()
{
logger $remark" start zapushgateway "
#[ "$httprscode" -ne "200" ] && time_total=0
echo $remark"_time_namelookup "$(grep "time_namelookup" $fhome$out".txt" | awk -F":" '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//') | curl --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$name
echo $remark"_time_connect "$(grep "time_connect" $fhome$out".txt" | awk -F":" '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//') | curl --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$name
echo $remark"_time_appconnect "$(grep "time_appconnect" $fhome$out".txt" | awk -F":" '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//') | curl --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$name
echo $remark"_time_pretransfer "$(grep "time_pretransfer" $fhome$out".txt" | awk -F":" '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//') | curl --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$name
echo $remark"_time_redirect "$(grep "time_redirect" $fhome$out".txt" | awk -F":" '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//') | curl --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$name
echo $remark"_time_starttransfer "$(grep "time_starttransfer" $fhome$out".txt" | awk -F":" '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//') | curl --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$name
echo $remark"_time_total "$time_total | curl --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$name

echo $remark"_httprscode "$httprscode | curl --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$name

#ERROR1 RQS CODE NOT 200
echo $remark"_eikr1 "$login_eikr1 | curl --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$name
echo $remark"_eikr1 "$AirShopping_eikr1 | curl --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$name
#ERROR2 no RS
echo $remark"_eikr2 "$login_eikr2 | curl --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$name
echo $remark"_eikr2 "$AirShopping_eikr2 | curl --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$name
#Сервис временно недоступен Service is temp unavailable
echo $remark"_eikr3 "$login_eikr3 | curl --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$name
echo $remark"_eikr3 "$AirShopping_eikr3 | curl --data-binary @- "http://"$pushg_ip":"$pushg_port"/metrics/job/"$name
}



start_login ()
{
Errorer="0"
login_eikr1="0"
login_eikr2="0"		#Сервис временно недоступен
login_eikr3="0"
out="1"
remark="Login"
logger "start "$remark
constructor_login;
post_processing;
[ "$Errorer" == "1" ] && login_eikr1="1"
[ "$Errorer" == "2" ] && login_eikr2="1"
[ "$Errorer" == "3" ] && login_eikr3="1"
zapushgateway;
if [ "$Errorer" != "0" ]; then
	sleep $sec
	start_login;
else
	sleep $sec
	time_total=0
	zapushgateway;
fi
}

start_AirShopping ()
{
AirShopping_eikr1="0"
AirShopping_eikr2="0"	#Сервис временно недоступен
AirShopping_eikr3="0"
Errorer="0"
out="2"
remark="AirShopping"
logger "start "$remark
constructor_AirShopping;
[ "$go" == "0" ] && time_total=0 && httprscode=0
post_processing;
[ "$Errorer" == "1" ] && AirShopping_eikr1="1"
[ "$Errorer" == "2" ] && AirShopping_eikr2="1"
[ "$Errorer" == "3" ] && AirShopping_eikr3="1"
[ "$Errorer" == "4" ] && start_login;

}




#START
PID=$$
echo $PID > $fPID
Init;
logger "----"
logger "start mixer_"$name
start_login;


while true
do
logger "---"
start_AirShopping
zapushgateway;

sleep $sec
done
rm -f $fPID
