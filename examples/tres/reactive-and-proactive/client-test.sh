# Simple script to setup and test tres reactive (virtual sensors)  features
#
# Usage:
#	client-test.sh [ get | toggle | --help ]
#	
#	Without arguments, this script sets the TRes task up (using the configuration below).
#	get - Will issue a GET request on /task/taskname/no
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

task="coap://$N2:$PORT/tasks/halve"

# Virtual sensor resource
new_output="$task/no"

if [ $# -gt 0 ] ; then 
	
	case $1 in 
	"get")
		echo "==> GET on new output"
		coap-client -m get ${new_output}
		exit 0;;
	"toggle")
		echo "==> TOGGLE the task"
                coap-client -m post ${task}
                exit 0;;	
	"--help")
		echo -e "Usage: $0 [ get | toggle | --help ]\n" 
       		echo -e "\tWithout arguments, this script sets the TRes task up (using the configuration within).\n"
       		echo -e "\tget - Will issue a GET request on /task/taskname/no"
       		echo -e "\ttoggle - Will activate or deactivate the task (a POST request to /task/taskname)"
	        echo -e "\t--help - Will print this message"
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

