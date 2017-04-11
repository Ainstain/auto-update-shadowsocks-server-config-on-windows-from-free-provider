#/bin/sh

# shadowsocks path
SHADOW_HOME=/c/PortableProgramFiles/Shadowsocks-win-2.5.6/

# ishadowsocks web site url 1
SHADOW_SITE=`curl http://isx.yt 2>&0 | grep "The document has moved" | sed -ne 's#.*href="\(.*\)/".*#\1#p'`

# ishadowsocks web site url 2
[[ "$SHADOW_SITE" == "" ]] && SHADOW_SITE=`curl http://isx.tn 2>&0 | grep "The document has moved" | sed -ne 's#.*href="\(.*\)/".*#\1#p'`

[[ "$SHADOW_SITE" == "" ]] && echo "not known ishadowsocks web site url !" && exit -1

echo "==============================================================================="
echo "ishadowsocks web site url:"$SHADOW_SITE
echo "==============================================================================="

GET_SHADOW_CMD="curl ${SHADOW_SITE} 2>&0"

configs=`eval ${GET_SHADOW_CMD} | sed -ne '/Portfolio Section/,/Team Section/ {/div class="hover-text"/,/\/div/ {s#.*div class="hover-text".*#{#p;s#.*/div.#"remarks": "","auth": false,"timeout": 5},#p;s#.*<h4>.*IP Address:<span id="[^"]\+">\([^<]\+\)<.*#"server":"\1",#p;  s#.*<h4>Port：\(.*\)</h4>.*#"server_port":"\1",#p;s#.*<h4>Password:<span id="[^"]\+">\([^<]\+\)</span>.*#"password":"\1",#p;s#.*<h4>Method:\(.*\)</h4>.*#"method":"\1",#p}}'  -e '1i configs:[' -e '$i {}],'\
|tr -t '\n' ' ' \
|sed 's/, {}//'
`
if [ x"$configs" = x ]; then
	echo "can not update shadowsocks config!"
	exit -1;
fi

sed -i "s/]/\n]/" $SHADOW_HOME/gui-config.json 

sed -i "/.*configs.*/,/]/ c $configs" $SHADOW_HOME/gui-config.json 

cat $SHADOW_HOME/gui-config.json 
