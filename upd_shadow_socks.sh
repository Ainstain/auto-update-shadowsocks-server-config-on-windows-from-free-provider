#/bin/sh

SHADOW_HOME=/c/PortableProgramFiles/Shadowsocks-win-2.5.6/
SHADOW_SITE=https://ishadow.co 

curl $SHADOW_SITE 

configs=`curl $SHADOW_SITE 2>/dev/null | sed -ne '/section id="free"/,/\/section/ {/div class="col-sm-4 text-center"/,/\div/ {s#.*<div class="col-sm-4 text-center".#{#p;s#.*/div.#"remarks": "","auth": false,"timeout": 5},#p;s#.*<h4>.服务器地址:\(.*\)</h4>#"server":"\1",#p;s#.*<h4>端口:\(.*\)</h4>#"server_port":"\1",#p;s#<h4>.密码:\(.*\)</h4>#"password":"\1",#p;s#.*<h4>加密方式:\(.*\)</h4>#"method":"\1",#p}}'  -e '1i configs:[' -e '$i {}],'\
|tr -t '\n' ' ' \
|sed 's/, {}//'
`
if [[ x"$configs" == x ]]; then
	echo "can not update shadowsocks config!"
	exit -1;
fi

sed -i "s/]/\n]/" $SHADOW_HOME/gui-config.json 

sed -i "/.*configs.*/,/]/ c $configs" $SHADOW_HOME/gui-config.json 

cat $SHADOW_HOME/gui-config.json 
