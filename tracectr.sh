#!/usr/bin/env bash


# -funcions-
func_trace() {
    traceroute -n $1 | tail -n +2 | egrep -o "[0-9]{,3}\.[0-9]{,3}\.[0-9]{,3}\.[0-9]{,3}" > $traced
}
func_trace_country() {
    for ip in $(cat $traced); do
        CTRY=$(curl -s ipinfo.io/$ip | jq -r '.country')
        ORG=$(curl -s ipinfo.io/$ip | jq -r '.org')
        echo "$ip:$CTRY:$ORG"
    done
}

# -variables-
traced="trace_ips.txt"


# -messages-

JQ_MSG="
[ 'jq' ] Not Installed !!!!

    use: apt install jq 

        exit...
"

CURL_MSG="
[ 'curl' ] Not Installed !!!

    use: apt install curl 

        exit...
"

TRACE_MSG="
[ 'traceroute' ] Not Installed !!!

    use: apt install traceroute 

        exit...
"

# -exception-
if [[ $(which jq | echo $?) -eq 1 ]]; then 
    echo -e "$JQ_MSG"
    exit 1
fi
if [[ $(which curl | echo $?) -eq 1 ]]; then 
    echo -e "$CURL_MSG"
    exit 1
fi
if [[ $(which traceroute | echo $?) -eq 1 ]]; then
    echo -e "$TRACE_MSG"
    exit 1
fi

# -main-

func_trace $1
func_trace_country



