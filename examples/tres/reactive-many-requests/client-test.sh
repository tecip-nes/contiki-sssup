# Simple script to test tres reactive (virtual sensors)  features
#
# Usage:
#	client-test.sh [ get [n] | toggle | --help ]
#	
#	Without arguments, this script sets the TRes task up (using the configuration below).
#	get [n] - Will issue n parallel GET requests on /task/taskname/no (n defaults to 3 if not specified)
#	toggle - Will activate or deactivate the task (a POST request to /task/taskname)
#	--help - Will print this message
#

# Contiki home folder
CONT=/home/user/contiki-tres

# COAP client (supporting version 13) 
client=/home/user/libcoap-4.0.1/examples/coap-client

setup_script=$CONT/apps/tres/tools/tres-client-13

# TRES application's bytecode
bytecode="$CONT/examples/tres/bin/halve.pyc"

# COAP Rest Server port
PORT=5683

# Addresses of the motes
N2=[aaaa::200:0:0:2]
N3=[aaaa::200:0:0:3]
N4=[aaaa::200:0:0:4]

# Reactive mote (where the virtual sensor virtually resides) resource
task_uri="coap://$N2:$PORT/tasks/halve"

# Input sensor resource
input_uri="<coap://$N3/sensor>"

# Output sensor resource
#output_uri="<coap://$N4/actuator>"

# Virtual sensor resource
new_output="$task_uri/no"

if [ $# -gt 0 ] ; then 
	
	case $1 in 
	"get")
		par_req=3
		if [ $# -gt 1 ] ; then
			par_req=$2
		fi
		responses=()
		echo "Sending $par_req requests in parallel"
		for i in `seq $par_req` ; do
			coap-client -m get ${new_output} 2>&1 >/tmp/tres-res-$i &
		done
		sleep 3
		for f in $(ls /tmp/ | grep "tres-res") ; do
			echo >>$f
		done
                cat /tmp/tres-res-*
		echo
		exit 0;;
	"toggle")
		echo "==> TOGGLE the task"
                coap-client -m post ${task}
                exit 0;;	
    "--help")
		echo -e "Usage:	client-test.sh [ get [n] | toggle | --help ]\n"
		echo -e "\tWithout arguments, this script sets the TRes task up (using the configuration within)."
		echo -e "\tget [n] - Will issue n parallel GET requests on /task/taskname/no (n defaults to 3 if not specified)"
		echo -e "\ttoggle  - Will activate or deactivate the task (a POST request to /task/taskname)"
		echo -e "\t--help  - Will print this message"
		exit 0;;
	esac
fi

echo "==> Setting up the taks"
# ${setup_script} ${task_uri} ${bytecode} ${input_uri} ${output_uri}

echo "Creating ${task_uri}"
coap-client -m put ${task_uri}

echo "Setting ${task_uri}/pf"
coap-client -m put ${task_uri}/pf -b 64 -f ${bytecode}

echo "Setting ${task_uri}/is"
coap-client -m put ${task_uri}/is -e "${input_uri}"

if [ -n "${output_uri}" ]
then
echo "Setting ${task_uri}/od to ${output_uri}"
echo -n "${output_uri}" | ${MYDIR}/bin/coap-client -m put $1/od -f -
fi

#echo "Start T-Res Task"
#coap-client -m post ${task_uri}

