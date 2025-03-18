
ip -4 -o addr show scope global | awk '{print $4}' | cut -d/ -f1 | head -n1

i use ubuntu 22.04.
i have a file that its named start with `system` and end with `.edn` like system.edn or system-1.edn or system-0.edn and etc ... .
this file is located in home in directiry that start with prefix van-buren- (like: van-buren-bubbles-wallex/resources/definitions/system.edn) 

consider below sample of head 20 line of this file is something like :

```
:type          :SYSTEM-v2
 :artifact      [:hermes.lib.system/core "0.1.5-SNAPSHOT"]
 ;;  :timbre-config    "resources/definitions/TC.edn"
 ;;  :exit-after-ms       1000
 :exit-after-ms 1000
 :base-url      "wss://stream.binance.com:9443/stream?streams="
 :proxy-config  {
                 :proxy-host "127.0.0.1";;#env CFG_BINANCE_PROXY_HOST_1
                 :proxy-port 1080       ;;#long #env CFG_BINANCE_PROXY_PORT_1
                 }
 :use-proxy?    true
 :-Striations#  1
 :events#       10
 :exchange      #env CFG_RABBIT_EXCHANGE_RLC
 :components-m1 :hermes.lib.system.components/m1
 :cur-artifact  :hermes.van-buren/rlc-router-foreign
 :config        {:name :test-ring-v4-compatible-amqp-emitter
                 ;; ------------------------------- ;;
                 ;; ------------------------------- ;;

```
i want to write script that edit this file inplace that :
where ever see `use-proxy?    true` patern , replace it with `use-proxy?    false`
or 
where ever see `Set-Proxy?            true` patern , replace it with `Set-Proxy?            false`



no your script changes all the `system*.edn` file that exist in home and its sub directory that start with van-buren- . 
i just want to change only the folder that in home directory and start wiht van-buren- . 
for example content of these bellow folder should not change : 
/home/amin/Downloads/Telegram Desktop/sample-service/van-buren-bubbles-wallex/resources/definitions/system.edn
/home/amin/transfer/van-buren-bubbles-wallex/resources/definitions/system-1.edn

=======================================================================================================


ok.
ok. now lets make it more profetioanal.
i want to run this script from my local system (ubuntu 22.04) the vm with ip and username and port that must be take from user as input. 
the default value must be : 
DEST_USER=amin
DEST_IP=10.10.20.201
DEST_PORT=22


and alsow first it have to check the ip with this command :
`ip -4 -o addr show scope global | awk '{print $4}' | cut -d/ -f1 | head -n1`

the output of this command is ip. 
and if the ip started with `172.20.` , it have to be true and if not it have to be false .
i mean if he ip started with `172.20.` and the bulean value in patern is false , it have to change to true. and if bulean value in patern is true , it have not to change. 
and vise versa for other ips. (i mean if the ip do not started with `172.20.` it have to be false. (if it was true it have to change to false))


=======================================================================================================

ok. it worked well.
now i want add some action. (to scenario: )

1- i want when Network: Internal (172.20.*) : 
i want to copy `env.sh` file from my local system to destination vm. 
(the source directory that contain `env.sh` is : `/home/ubuntu/ansible/env/`
and destination directory is `/etc/profile.d/` 
)
this file i mean `env.sh` contain enviroonment variable , so it nedds to be source. 
so after the copy complete, this command needs to be run : 
`source /etc/profile.d/env.sh`
and then add this command to the end of the `.bashrc` and then `source .bashrc`.

2- and i want when Network: External : 
i want to copy `env-newpin.sh` file from my local system to destination vm.
(the source directory that contain `env-newpin.sh` is : `/home/ubuntu/ansible/env/newpin/`
and destination directory is `/etc/profile.d/` 
)
this file i mean `env-newpin.sh` contain enviroonment variable , so it nedds to be source. 
so after the copy complete, this command needs to be run : 
`source /etc/profile.d/env-newpin.sh`
and then add this command to the end of the `.bashrc` and then `source .bashrc`.

where ever i got mistake you correct it. 
so rewrite script. 

rewrite the script that define username. 
dont change any functionality of this script. the script must do actions like before correctly. 



    scp -P "$DEST_PORT" /home/amin/transfer/env/env.sh "${DEST_USER}@${DEST_IP}:/tmp/env.sh"
    scp -P "$DEST_PORT" /home/amin/transfer/env/newpin/env-newpin.sh "${DEST_USER}@${DEST_IP}:/tmp/env-newpin.sh"

rsync -avz -e "ssh -p 22" ubuntu@185.204.171.190:/home/ubuntu/ansible/env /home/amin/transfer/env
take folder from main:
rsync -avz -e "ssh -p 22" ubuntu@172.20.90.2:/home/ubuntu/chrony_exporter/ /home/amin/transfer/chr


=======================================================================================================

ok.
i want to make some changes.
first the variable must change from :
TARGET_USER
TARGET_IP
TARGET_PORT
TARGET_FOLDER

to: 
DEST_USER
DEST_IP
DEST_PORT
DEST_PATH

and alsow define bellow variable: 
SOURCE_USER
SOURCE_IP
SOURCE_PORT
SOURCE_PATH


all these 8 variable that must be take from user as input and 
all these variable have default values. that default values read from the ralated file:
the default valure for DEST variable must read from Info_Dest.txt
and 
the default valure for SOURCE variable must read from Info_Source.txt

Info_Dest.txt and Info_Source.txt is in the /Info directory. you can set Info_Directory variable like : Info_path="$(dirname "$0")/Info"

and after the value taken from user , the script must ask user that which vm doese he want that actions will be done (the source vm or dest vm)

and then the user select the actions (from menue)
and then the action must be done in the vm that user choose earlier in previous steps.


=======================================================================================================

now i want to change the actions. 


i want to change the script :
dont change the logic of code at all. 
there are four action. i mean each action is a script. 
consider that the 4 scripts (actions) in the directory /deployment_scripts. you can set INFO_PATH variable like : deployment_scripts_path="$(dirname "$0")/deployment_scripts"
the scripts`s name are:
deploy_all.sh start_all.sh stop_all.sh purge_all.sh

i want just change the actions like bellow: 
just rewrite the code that change actions be like :

action 1: run deploy_all.sh that located in  deployment_scripts_path 
description : This script automates running 111-ACTION-deploy-services.sh in all directories starting with van-buren, if the script exists and is executable.
action 2: run start_all.sh (that located in  deployment_scripts_path)
description : This script automates running 222-ACTION-start-services.sh in all directories starting with van-buren, if the script exists and is executable.
action 3: run stop_all.sh (that located in  deployment_scripts_path)
description : This script automates running 000-ACTION-stop-services.sh in all directories starting with van-buren, if the script exists and is executable.
action 4: run purge_all.sh (that located in  deployment_scripts_path)
description : This script automates running 999-ACTION-purge-services.sh in all directories starting with van-buren, if the script exists and is executable.

=======================================================================================================

ok. now i want to remove the Info_Source.txt and Info_Dest.txt. all default information must be read from servers.conf. (that locate in the same old directory INFO_PATH="$(dirname "$0")/Info")
here is the context of servers.conf:
# servers.conf - Server Configuration File
wich Format of each line in servers.conf  file is: datacenter|vm_name|ip|host|username|port

arvan|cr1arvan|185.204.170.177|cr1arvan.stellaramc.ir|ubuntu|22
arvan|cr2arvan|185.204.171.190|cr2arvan.stellaramc.ir|ubuntu|22
arvan|cr3arvan|185.204.170.246|cr3arvan.stellaramc.ir|ubuntu|22
arvan|cr4arvan|185.204.168.198|cr4arvan.stellaramc.ir|ubuntu|22
arvan|cr5arvan|185.204.169.190|cr5arvan.stellaramc.ir|ubuntu|22
arvan|cr6arvan|185.204.170.134|cr6arvan.stellaramc.ir|ubuntu|22

cloudzy|cr1cloudzy|172.86.68.12|cr1cloudzy.stellaramc.ir|ubuntu|22
cloudzy|cr2cloudzy|216.126.229.35|cr2cloudzy.stellaramc.ir|ubuntu|22
cloudzy|cr3cloudzy|216.126.229.33|cr3cloudzy.stellaramc.ir|ubuntu|22
cloudzy|cr4cloudzy|216.126.229.36|cr4cloudzy.stellaramc.ir|ubuntu|22
cloudzy|cr5cloudzy|172.86.94.38|cr5cloudzy.stellaramc.ir|ubuntu|22
cloudzy|cr6cloudzy|172.86.93.39|cr6cloudzy.stellaramc.ir|ubuntu|22

azma|cr1azma|172.20.10.31|172.20.10.31|ubuntu|22
azma|cr2azma|172.20.10.32|172.20.10.32|ubuntu|22
azma|cr3azma|172.20.10.33|172.20.10.33|ubuntu|22
azma|cr4azma|172.20.10.34|172.20.10.34|ubuntu|22
azma|cr5azma|172.20.10.35|172.20.10.35|ubuntu|22
azma|cr6azma|172.20.10.36|172.20.10.36|ubuntu|22


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INFO_PATH="$(dirname "$0")/Info"
SERVERS_CONF="$INFO_PATH/servers.conf"



option for datacenter must fetched from servers.conf. (in this case options are : 1- arvan 2- cloudzy 3- azma)
so all the needed value must read from servers.conf. and do not ask user this pre defined value either. 
the user just have to determine three thing (as input)
1- choose source data center( Among the options available for data centers ).
2- choose destionation data center(Among the options available for data centers ).
3- based on source data center that chosed in step 1 , related vm_name have to show to user and user pick one of theme.
for example if cloudzy datacenter chosed as source data center, the option in stage 3 must be : 
1. cr1cloudzy
2. cr2cloudzy
3. cr3cloudzy
4. cr4cloudzy
5. cr5cloudzy
6. cr6cloudzy


so for example use these variable name: 
DEST_USER=ubuntu
DEST_IP=cr3arvan.stellaramc.ir
DEST_PORT=22

so now imagine this scenario that user chosed this : 
source data center = cloudzy
destionation data center = arvan
vm_name = cr3cloudzy

so you have to set value that need in script based on information in servers.conf and these three input.
each line of servers.conf have Format: datacenter|vm_name|ip|host|username|port
so in this sample scenario these valu must set :
SOURCE_USER=ubuntu
SOURCE_IP=cr3cloudzy.stellaramc.ir
SOURCE_PORT=22
SOURCE_PATH=/home/ubuntu/

DEST_USER=ubuntu
DEST_IP=cr3arvan.stellaramc.ir
DEST_PORT=22
DEST_PATH=/home/ubuntu/

the ip must fetche from servers.conf based on host column. i mean for example vm_name was cr3cloudzy and related host in servers.conf was `cr3cloudzy.stellaramc.ir`

the dest info set based on destionation data center and vm_name . (i mean it have to detect by script, for example if vm_name = cr3cloudzy and destionation data center = arvan, then DEST_IP must be `cr3arvan.stellaramc.ir` [fetched from servers.conf] )

so now SOURCE_* and DEST_* is determine.

now for the chosing sequential action:
first action 1 (deploy_all.sh) and then action 2 (start_all.sh) must be done in dest vm.
and 
then action 3 (stop_all.sh) and then action 4 (purge_all.sh) must be done in source vm.


so rewrite the script. 

=======================================================================================================

ok. well. now give me overview of whole thing in script (about what doese it do in detail and what is the structure of input , service.config file and how the variable related togheder and anything you think usefull.) consider that i want to explain it to someone that doesent know any thing about it. from top to end.
=======================================================================================================
Okay. Now, give me a detailed script overview—what it does, the structure of the input and `service.config` file, how variables are related, and any other useful details. Assume I'm explaining it to someone with no prior knowledge, from start to finish.
=======================================================================================================

now i want to change script :
as you know :
the user just have to determine three thing (as input)
1- choose source data center( Among the options available for data centers ).
2- choose destionation data center(Among the options available for data centers ).
3- based on source data center that chosed in step 1 , related vm_name have to show to user and user pick one of theme.
for example if cloudzy datacenter chosed as source data center, the option in stage 3 must be : 
1. cr1cloudzy
2. cr2cloudzy
3. cr3cloudzy
4. cr4cloudzy
5. cr5cloudzy
6. cr6cloudzy

so now imagine this scenario that user chosed this : 
source data center = cloudzy
destionation data center = arvan

now i want that in stage three (i mean user pick one of vm_name) change that to user be able to chose multipli item. i mean if user enter `6145` , it means cr6cloudzy and cr1cloudzy and cr4cloudzy and cr5cloudzy are selected sequentially .  
so you have to set value that need in script based on information in servers.conf and these three input.
i mean cr6arvan and cr1arvan and cr4carvan and cr5carvan are selected related to vm_name sequentially. 

so it mean 4 job must be do sequentially in a loop. for example job_1 is :

so in this sample scenario these valu must set for job_1 :
SOURCE_USER=ubuntu
SOURCE_IP=cr6cloudzy.stellaramc.ir
SOURCE_PORT=22
SOURCE_PATH=/home/ubuntu/

DEST_USER=ubuntu
DEST_IP=cr6arvan.stellaramc.ir
DEST_PORT=22
DEST_PATH=/home/ubuntu/

the ip must fetch from servers.conf based on host column. i mean for example vm_name was cr6cloudzy and related host in servers.conf was `cr6cloudzy.stellaramc.ir`

the dest info set based on destionation data center and vm_name . (i mean it have to detect by script, for example if vm_name = cr6cloudzy and destionation data center = arvan, then DEST_IP must be `cr6arvan.stellaramc.ir` [fetched from servers.conf] )

so now SOURCE_* and DEST_* is determine jor job_1.

now for the chosing sequential action jor job_1:
first action 1 (deploy_all.sh) and then action 2 (start_all.sh) must be done in dest vm.
and 
then action 3 (stop_all.sh) and then action 4 (purge_all.sh) must be done in source vm.

this means the job_1 is finished and job_2 must start after it .
in this scenario valu for job_2 is : 
SOURCE_USER=ubuntu
SOURCE_IP=cr1cloudzy.stellaramc.ir
SOURCE_PORT=22
SOURCE_PATH=/home/ubuntu/

DEST_USER=ubuntu
DEST_IP=cr1arvan.stellaramc.ir
DEST_PORT=22
DEST_PATH=/home/ubuntu/

now for the chosing sequential action jor job_2:
first action 1 (deploy_all.sh) and then action 2 (start_all.sh) must be done in dest vm.
and 
then action 3 (stop_all.sh) and then action 4 (purge_all.sh) must be done in source vm.

and the same for job_3 and job_4 must be do.


so rewrite the script with minimal changes. 

=======================================================================================================


i want to add two feature :
feature 1 :
after user input the sequence number (for example 1645) it have to show Configuration Summary and final approval by user. 
for example : 

Configuration Summary:
Source: cloudzy - Server Order: (1- cr1cloudzy 2- cr6cloudzy 3- cr4cloudzy 4- cr5cloudzyr ) 
Destination: arvan - Server Order: (1- cr1arvan 2- cr6arvan 3- cr4arvan 4- cr5arvan)
Continue? (y/n): 

feature 2:

for showing the option in stage 3, add `all` option in the end of the listfor example in this scenario the option in stage 3 must be : 
1. cr1cloudzy
2. cr2cloudzy
3. cr3cloudzy
4. cr4cloudzy
5. cr5cloudzy
6. cr6cloudzy
7. all

the `all` option must do jobs for all other options in this list sequentialy. (i mean when user chose `all` option it is equivalent with user chosing `123456` in this scenario. )

so rewrite code .

=======================================================================================================


in ubuntu 22.04 
i want to install zip , unzip , openjdk-17-jdk, telnet, chrony, prometheus-node-exporter . 
make it as bash script. 

write script that (in ubuntu 22.04 ) :
i want to run this script from my local ubuntu to perform some actions to another vm (alsow ubuntu 22.04) that i have ssh access to it.
write script that do these step :
1- update it
2- upgrade it
3- reboot it
4- install zip unzip openjdk-17-jdk telnet chrony prometheus-node-exporter 



forget about getting input from user. 
just use default value :
DEFAULT_USER="ubuntu"
DEFAULT_IP="185.204.169.226"
DEFAULT_SSH_PORT="22"

=======================================================================================================

now i want to add three feature:

1- automatic Configures SSH options forr all remote connections
SSH_OPTS="-o StrictHostKeyChecking=no" → Prevents SSH from asking about new host keys (useful for automation but can be a security risk).

2- in sequential action for each job :
there have to 10 second sleep (i mean 10 second  pause) between actions in source asnd dest vm, i mean  for example :

first action 1 (deploy_all.sh) and then action 2 (start_all.sh) must be done in dest vm.
then : 10 second sleep (i mean 10 second  pause) 
and 
then : action 3 (stop_all.sh) and then action 4 (purge_all.sh) must be done in source vm.


3- the script use two file for save logs: service_timestamps*.log and service_actions*.log . 
the  service_timestamps*.log is not nececary . so remove it.
but thi format of loging in the ervice_actions_*.log  have to be something like this : 

------------------------------------------------------------
|         Service Transfer Operation - Job 1              |
------------------------------------------------------------

[2025-03-05 17:54:45] ──▶ [Action 1] Deploy All Services  | Server: cr7cloudzy | STATUS: Started  
[2025-03-05 17:55:05] ✅  [Action 1] Deploy All Services  | Server: cr7cloudzy | STATUS: Completed  

[2025-03-05 17:55:05] ──▶ [Action 2] Start All Services   | Server: cr7cloudzy | STATUS: Started  
[2025-03-05 17:55:21] ✅  [Action 2] Start All Services   | Server: cr7cloudzy | STATUS: Completed  

[2025-03-05 17:55:21] ──▶ [Action 3] Stop All Services    | Server: cr7arvan   | STATUS: Started  
[2025-03-05 17:55:30] ✅  [Action 3] Stop All Services    | Server: cr7arvan   | STATUS: Completed  

[2025-03-05 17:55:30] ──▶ [Action 4] Purge All Services   | Server: cr7arvan   | STATUS: Started  
[2025-03-05 17:55:40] ✅  [Action 4] Purge All Services   | Server: cr7arvan   | STATUS: Completed  

------------------------------------------------------------
|         Service Transfer Operation - Job 2              |
------------------------------------------------------------

[2025-03-05 17:55:40] ──▶ [Action 1] Deploy All Services  | Server: cr8cloudzy | STATUS: Started  
[2025-03-05 17:55:47] ✅  [Action 1] Deploy All Services  | Server: cr8cloudzy | STATUS: Completed  

[2025-03-05 17:55:47] ──▶ [Action 2] Start All Services   | Server: cr8cloudzy | STATUS: Started  
[2025-03-05 17:55:54] ✅  [Action 2] Start All Services   | Server: cr8cloudzy | STATUS: Completed  

[2025-03-05 17:55:54] ──▶ [Action 3] Stop All Services    | Server: cr8arvan   | STATUS: Started  
[2025-03-05 17:55:59] ✅  [Action 3] Stop All Services    | Server: cr8arvan   | STATUS: Completed  

[2025-03-05 17:55:59] ──▶ [Action 4] Purge All Services   | Server: cr8arvan   | STATUS: Started  
[2025-03-05 17:56:05] ✅  [Action 4] Purge All Services   | Server: cr8arvan   | STATUS: Completed  

------------------------------------------------------------
|           All Service Transfer Operations Completed      |
------------------------------------------------------------

=======================================================================================================


now i want to get approval after 10-second pause between destination VM actions (deploy/start) and source VM actions (stop/purge). 
i mean after destination VM actions (deploy/start) done , i want to when the  command `sudo systemctl status van-buren-*` must run and then based on its output the proccess can continue in source VM actions (stop/purge). if it was not seccessfull the proccess must stop. with related warning message. 

the command `sudo systemctl status van-buren-*` if not seccessfull something like this will be show: 

ubuntu@cr7arvan-t2:~$ sudo systemctl status van-buren-rlc-router-binance-3-shared-0.service 
Unit van-buren-rlc-router-binance-3-shared-0.service could not be found.

but if seccessfull something like bellow is shown :

ubuntu@cr7cloudzy-t1:~$ sudo systemctl status van-buren-rlc-router-binance-3-shared-0.service 
● van-buren-rlc-router-binance-3-shared-0.service - van-buren-rlc-router-binance-3-shared-0
     Loaded: loaded (/etc/systemd/system/van-buren-rlc-router-binance-3-shared-0.service; enabled; vendor preset: enabled)

and because of i dont khnow exactly what is the name of service is, the script must detect it itself , but i am sure the prefix of the service name is : `van-buren-`. 
and the maybe multiple service start with `van-buren-` and all of the must seccessfull. 

If there is no active service with a name starting with van-buren-, that means the first step has failed and the actions in source vm should not be run.
=======================================================================================================

ok. 
there is problem in log file. 

in the server section it dosent show a good output  (what is `%-15s` ?   ) : 

[2025-03-06 17:07:08] ──▶ [Action 1] Deploy All Services       | Server: %-15s | STATUS: Started cr7arvan
[2025-03-06 17:07:18] ✅  [Action 1] Deploy All Services       | Server: %-15s | STATUS: Completed cr7arvan



and alsow i want to add approval after source VM actions (stop/purge) action as well .
i mean after the (stop/purge) action done in source VM there have to bo no service availablethat started with `van-buren-` . and if it is the related warning message must show and log. and it dosent go to next job and the next job should not be run. 

=======================================================================================================

each time i connect to remot vm from my local machine (main machine) , the shh connection is Slow. 
So the fewer shhs I do and the more I can make the requests in one ssh, the better for speeding things up. This script needs to be rewritten to speed things up in this and other ways. So rewrite it. 
=======================================================================================================

Do you think there is a difference between options 1 and 2 for the rsync command? (i mean in Transfer options:
1. Transfer a specific file from source VM to destination VM
2. Transfer a specific folder from source VM to destination VM)
Do these two options have to be provided separately?

make it in one integrated option. 

whe i want synce folder from sorce VM to dest while ensuring that the entire folder structure and contents are exactly replicated on the destination VM. Specifically:
When I specify a source directory (e.g., /home/ubuntu/999-test-tr), the destination VM should have an identical directory with the same name (999-test-tr) and all its contents.
The synchronization should ensure that the destination folder is a perfect copy of the source, meaning any new files, changes, or deletions should be reflected.
=======================================================================================================
no.
it is worng. i enter /home/ubuntu/999-test-tr/333-test-sub for folder on source vm , but `/home/ubuntu/333-test-sub` created in dest vm. 
i want the script create the same directory path in the destination vm .

for example if i enter `/home/ubuntu/999-test-tr/333-test-sub` (when `specific file or folder on source VM:` apears), it have to create `999-test-tr/333-test-sub` directory in home directory in dest vm . and the content of  333-test-sub must synce. 

other sample : 
folder on source vm: /etc/chrony
related folder on dest vm: /etc/chrony

another hypotetical example : (asume that username amin and ubuntu must fetch from service.config based on related vm name that user input in previous steps)
folder on source vm: /home/amin/temp_SCR/SCR
related folder on dest vm: /home/unubtu/temp_SCR/SCR

another example :(asume that username ubuntu and ubuntu must fetch from service.config based on related vm name that user input in previous steps)
folder on source vm: /home/ubuntu/van-buren-rlc-router-binance-3-shared/resources
related folder on dest vm: /home/ubuntu/van-buren-rlc-router-binance-3-shared/resources
=======================================================================================================


i want make some chage in code:

1- the `Choose source datacenter` and `Choose destination datacenter` and `Choose source VM` must ramain unchange. but Choose destination VM must add as option input for user base on related vm that are available in the destination datacenter (in old script, destination detected aoutomaticlally, not by user )

2- in old script, option 1 designed for Transfer a specific file or folder from source VM to destination VM .i want to add Transfer options for main machine. as you know this script is run in a Main machine (Ubuntu 20.04.6 LTS) that have access to all other vm in all datadenter. i want to Transfer a specific file or folder from Main machine to another VMs in other datacenter . and transfer a specific file or folder from VMs in other datacenter to Main machine . (so it is on your choise that make this as a new Transfer option integrate it with option 1 in Transfer options (with updating the service.conf or the code)  )

=======================================================================================================
this is a piec of code from long bash script:
```

```
i want to transfer whole folder instead of its content . 
give me proper solution with minimum changes. 


=======================================================================================================

in transferring folders (in all option) , i want to Copies the entire directory (including the directory itself) to the remote location. 
in this code
in transering option , 
=======================================================================================================
the series of showing option is not good.
i run the script and here is the workflow : 

Enter a number (0, 1, 2, 3, 4, 5): 3
Running sync.sh...
Available datacenters:
1. arvan
2. azma
3. cloudzy
Choose source datacenter (1-3): 2
Choose destination datacenter (1-3): 3
Available VMs in azma datacenter:
1. cr1azma
2. cr2azma
3. cr3azma
4. cr4azma
5. cr5azma
6. cr6azma
Choose source VM (1-6): 1
Available VMs in cloudzy datacenter:
1. cr1cloudzy
2. cr2cloudzy
3. cr3cloudzy
4. cr4cloudzy
5. cr5cloudzy
6. cr6cloudzy
Choose destination VM (1-6): 2

Configuration Summary:
Source: azma - Server: cr1azma (172.20.10.31)
Destination: cloudzy - Server: cr2cloudzy (cr2cloudzy.stellaramc.ir)
Continue? (y/n): y

Transfer options:
1. Transfer a specific file or folder from source VM to destination VM
2. Transfer specific files/folders from home directory based on patterns
   (van-buren-* directories, .sh files, .secret/ folder)
3. Transfer a specific file or folder from main machine to destination VM
4. Transfer a specific file or folder from source VM to main machine


but whene i want to transfer from main to another vm (or from another vm to main) its not neccessary to determine Choose source datacenter and Choose destination datacenter. so if the source is main just determine dest datacenter and dest vm (and alsow  if the dest is main just determine source datacenter and source vm). 
so the user input must reorder. 

=======================================================================================================
two things needs to be solve: 
one: 
in :
{
VM-to-VM Transfer options:
1. Transfer a specific file or folder from source VM to destination VM
}
the script ask for Enter the path to the specific file or folder on source VM, but it does not ask for path in destination.it have to ask from user to enter the destination path.

two : 
Each time I connect to a remote VM from my local machine, the SSH connection is slow. To improve efficiency, I want to minimize the number of SSH connections and execute as many requests as possible within a single session. The script needs to be optimized to reduce SSH overhead and improve performance in other ways. Please rewrite it to achieve these improvements. the speed is important.

=======================================================================================================

there are foure state that can i enter the bellow command (with or without /) :
rsync -avz -e "ssh -p 22" ubuntu@172.20.90.2:/home/ubuntu/chrony_exporter/ /home/amin/transfer/chr
rsync -avz -e "ssh -p 22" ubuntu@172.20.90.2:/home/ubuntu/chrony_exporter/ /home/amin/transfer/chr/
rsync -avz -e "ssh -p 22" ubuntu@172.20.90.2:/home/ubuntu/chrony_exporter /home/amin/transfer/chr
rsync -avz -e "ssh -p 22" ubuntu@172.20.90.2:/home/ubuntu/chrony_exporter /home/amin/transfer/chr

difference between theme consice in a table . 
and make tree example. concise 
=======================================================================================================

the logic of geting input for VM-to-VM Transfer options:
1. Transfer a specific file or folder from source VM to destination VM
must have to be the same as the 2. Main machine to VM transfer and 3. VM to Main machine transfer . so rewrite the 1. Transfer a specific file or folder from source VM to destination VM section in VM-to-VM Transfer. 
=======================================================================================================
ok. now i want to write a new script based on previous sscript [i will refer it as script_2 in this chat if i need it. ]
write a new very simple concise script that : 
use Predefined Patterns (in mean Transfer specific files/folders from home directory based on patterns (van-buren-* directories, .sh files, .secret/ folder) ) , in home directory of vm1 (source vm)  to copy those files and folder to spesific destination in dest vm.

the script is run on main machine.
source vm can be any vm in servers.conf and must fetch from servers.conf file. 
dest vm is main machin. 
main machin have access to all vms. 

the dest directory must define dynamicly base on bellow logic :
for example :
if cr1azma have chosed , dest directory must be  `/home/ubuntu/1111-binance-services/cr1` . 
if cr2azma have chosed , dest directory must be  `/home/ubuntu/1111-binance-services/cr2` . 
if cr3azma have chosed , dest directory must be  `/home/ubuntu/1111-binance-services/cr3` . 
if cr5cloudzy have chosed , dest directory must be  `/home/ubuntu/1111-binance-services/cr5` . 
if cr3cloudzy have chosed , dest directory must be  `/home/ubuntu/1111-binance-services/cr3` . 
and so on ....

=======================================================================================================
ok. script_2 is worked well. (i will refer parent and big script that priviously we discusing about it, as script_1 in this chat if i need it.)
i want add some feature in script_2. 
in Choose source VM , there have to be multi chosing available for user. i mean :
whene 
{
Available VMs in cloudzy datacenter:
1. cr1cloudzy
2. cr2cloudzy
3. cr3cloudzy
4. cr4cloudzy
5. cr5cloudzy
6. cr6cloudzy
Choose source VM (1-6):
}
apeare , user can in put `246` and that means 3 sycronization must run suquentially (for cr2cloudzy, cr4cloudzy, cr6cloudzy).
alsow i want additionall option : `all`. that meane user chosed all vm in the list. 

=======================================================================================================
ok good. (Until now we have two scripts script_1 and script_2)
i want to werite new script. [i will refer it as script_3 in this chat if i need it.]
now i want vise versa approach. 
i mean in this aproach the source vm is main machine (that have access to all other vm), and the dest vms is on datacenters. 
i mean in this new script i want to synce from `/home/ubuntu/1111-binance-services/cr$VM_NUMBER` and dest directory is home direcory of destiantion vm. 
so user must first chose datacenters that he want to synce data from main to that datacenter, then select vms (multi chosing with all option ), and then from related path in main machine (source machine) data must synce. 
=======================================================================================================
the hermes-env.sh file in `/etc/profile.d` directory in destination vm dose not source correctly. because after the  running sccript is complete,  i run `env` but i dont see the variables that i defined in the `/etc/profile.d/hermes-env.sh`

=======================================================================================================
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INFO_PATH="$(dirname "$0")/Info"
SERVERS_CONF="$INFO_PATH/servers.conf"


option for datacenter must fetched from servers.conf. (in this case options are : 1- arvan 2- cloudzy 3- azma)
so all the needed value must read from servers.conf. and do not ask user this pre defined value either. 
the user just have to determine two thing (as input)
1- choose destionation data center(Among the options available for data centers ).
3- based on source data center that chosed in step 1 , related vm_name have to show to user and user pick one of theme.
for example if cloudzy datacenter chosed as source data center, the option in stage 2 must be : 
1. cr1cloudzy
2. cr2cloudzy
3. cr3cloudzy
4. cr4cloudzy
5. cr5cloudzy
6. cr6cloudzy


so for example use these variable name: 
DEST_USER=ubuntu
DEST_IP=cr3arvan.stellaramc.ir
DEST_PORT=22


=======================================================================================================
1- use rsync aproach instead of scp, for better speed. 


2- in Choose dest VM , there have to be multi chosing available for user. i mean :
whene 
{
Available VMs in cloudzy datacenter:
1. cr1cloudzy
2. cr2cloudzy
3. cr3cloudzy
4. cr4cloudzy
5. cr5cloudzy
6. cr6cloudzy
Choose destination VM (1-6):
}
apeare , user can in put `246` and that means  do all jobs that have to be done in script for each vm, must run suquentially (for cr2cloudzy, cr4cloudzy, cr6cloudzy).
alsow i want additionall option : `all`.(in the last option for example 7. all) that meane user chosed all vm in the list. 

=======================================================================================================
ok.

i want to change the main menue. 
title : 1- Synchronize 
description: 
Sync a folder from a Main VM to a destination VM.

action that must be done with this option: run simple_synce-main2vm.sh 
(this option should run `simple_synce-main2vm.sh ` script  that located in the  same main directory.) 

title : 2- Set environment variable & Edit EDN Based on IP 
description: 
Copies the appropriate environment file and Modifies proxy settings in configuration files

action that must be done with this option: edit_edn_base_on_ip.sh
(this option should run `edit_edn_base_on_ip.sh ` script  that located in the  same main directory.) 


title : 3- Switch 
description: 
Remotely execute sequential actions on a destination VM (deploy, start) and the source VM (stop, purge) . 

action that must be done with this option: action.sh
(this option should run `action.sh ` script  that located in the  same main directory.) 


=======================================================================================================
before i give you scripts : 
this is the structure of the folder that contains scrtipts and related file : 
(base) amin@SY73-DV:~/git_repos/Synchronize_Switch$ tree
.
├── action.sh
├── auto-git.sh
├── deployment_scripts
│   ├── deploy_all.sh
│   ├── purge_all.sh
│   ├── start_all.sh
│   └── stop_all.sh
├── edit_edn_base_on_ip.sh
├── Info
│   └── servers.conf
├── main.sh
└── simple_synce-main2vm.sh

2 directories, 10 files

ok? 
=======================================================================================================

alsow before i give you scripts : 
this is `servers.conf` file content that have predefined information that scripts needs : 

=======================================================================================================

script_1 : 
this is the `simple_synce-main2vm.sh` : 
```


```
=======================================================================================================

script_2 : 
this is the `edit_edn_base_on_ip.sh` : 
```


```
=======================================================================================================
script_3 : 
this is the `action.sh` : 
```


```
=======================================================================================================
script_4 : 
this is the `main.sh` : 
```


```
=======================================================================================================
analayze all 4 scripot togheter. give me ralation of them.
=======================================================================================================

as you know all input user of 3 scripts :  `simple_synce-main2vm.sh` , `edit_edn_base_on_ip.sh`, `action.sh` is : .
user in all these script can input : 
Select source datacenter
Select destination datacenter
Select VMs to migrate
Choose number of parallel jobs
Select which service (binance, kucoin, or gateio)


consider that i want to get the input for Select source datacenter, Select destination datacenter and Select VMs to migrate (whose variable is the same in all scripts) in main.sh parse theme automatically to other script : (`simple_synce-main2vm.sh` , `edit_edn_base_on_ip.sh`, `action.sh`).
so now i want that user just once for these input.
so you have to rewrite the main.sh .
do i have to change the `simple_synce-main2vm.sh` , `edit_edn_base_on_ip.sh`, `action.sh` scripts ? how to automaticaly pars these variable from main to these three script? ()

=======================================================================================================
no. i want these input in main must fetch and show option for :
{
Select source datacenter
Select destination datacenter
Select VMs to migrate
}
from `servers.conf` file. (learn how these three script show these options to user and get input and then implement it in main.sh )

=======================================================================================================
ok. lets change the the Other Scripts. 
i want to give me the whole script. 
dont change the logic of the code at all.
just manage the script so that can pars the input from main.sh . (dont change functionality and logic of the code)
lets begin with simple_synce-main2vm.sh.
=======================================================================================================


=======================================================================================================

i want to make some little change. 

consider that here is the updated content of `deployment_scripts` directory :

├── deploy_all_binance.sh
├── deploy_all_gateio.sh
├── deploy_all_kucoin.sh
├── purge_all_binance.sh
├── purge_all_gateio.sh
├── purge_all_kucoin.sh
├── start_all_binance.sh
├── start_all_gateio.sh
├── start_all_kucoin.sh
├── stop_all_binance.sh
├── stop_all_gateio.sh
└── stop_all_kucoin.sh

i want to get from user service name. 
after Select source datacenter and Select source VMs and Enter maximum number of parallel jobs, before the script show Configuration Summary to user :
the script must show service name among the bellow option: 
1- binance
2- kucoin
3- gateio

based on this selection, the related deployment scripts must select for copy to source vm and destionation vm . 
i mean for example if user select binance, related script is : deploy_all_binance.sh and start_all_binance.sh (for destination vm) and stop_all_binance.sh and purge_all_binance.sh (for source vm) must select. 
ok ? 
=======================================================================================================
now in `Available Services:` , i want to add additionall option : `all`.(in the last option for example 7. all) that meane user chosed all folder that start with van-buren 


=======================================================================================================



=======================================================================================================
in script_3
i want to make some change:
one:
i dont want to show to user this :
[2025-03-09 14:06:42] Pattern file created with the following patterns:
[2025-03-09 14:06:42]   + van-buren-*/
[2025-03-09 14:06:42]   + van-buren-*/**
[2025-03-09 14:06:42]   + *.sh
[2025-03-09 14:06:42]   + .secret/
[2025-03-09 14:06:42]   + .secret/**
[2025-03-09 14:06:42]   - *

two:
i want the progress of transfering file show to user (pecentage of proceed). 

=======================================================================================================

in script_3
i want to make some change:

i want the script can capable to automate the passing of the user input,(i want both interactive mode and automated mode) so i should update script so that they can accept predefined input from command-line arguments. so here is the steps that i think helpful:
Check for command-line arguments:
At the very start, check if parameters are passed (e.g., by checking if $1 is empty).
Assign them to related variables in the code.
Skip the interactive input if these values are provided.
This change makes my scripts more flexible. i can use them in both interactive mode and automated mode depending on whether the parameters are passed.

after you write the code , make example of use case how to pass input automatically. 


=======================================================================================================
consider that these are the help for how these script accept predefined input from command-line arguments.


(base) amin@SY73-DV:~/git_repos/Synchronize_Switch$ ./action.sh -h
Usage: ./action.sh [OPTIONS]
Options:
  -s SOURCE_DC     Source datacenter name
  -d DEST_DC       Destination datacenter name
  -v VM_NUMBERS    Source VM numbers (comma-separated, e.g., '1,3,5' or 'all')
  -p PARALLEL      Maximum parallel jobs (default: 2)
  -r SERVICE       Service to migrate (binance, kucoin, or gateio)
  -y               Non-interactive mode (skip confirmation prompts)
  -V               Verbose mode
  -h               Display this help message

Example: ./action.sh -s arvan -d cloudzy -v all -p 3 -r binance -y


(base) amin@SY73-DV:~/git_repos/Synchronize_Switch$ ./edit_edn_base_on_ip.sh -h
Usage: edit_edn_base_on_ip.sh [OPTIONS]

Options:
  -d, --datacenter DATACENTER  Specify the datacenter name
  -s, --servers SERVER_LIST    Specify servers to process (comma-separated numbers or "all")
  -h, --help                   Show this help message

Examples:
  edit_edn_base_on_ip.sh                          # Run in interactive mode
  edit_edn_base_on_ip.sh -d cloudzy -s all        # Process all cloudzy servers
  edit_edn_base_on_ip.sh -d arvan -s 1,3,5        # Process 1st, 3rd, and 5th arvan servers
  edit_edn_base_on_ip.sh --datacenter azma --servers 2,4    # Process 2nd and 4th azma servers

(base) amin@SY73-DV:~/git_repos/Synchronize_Switch$ ./simple_synce-main2vm.sh --help
Usage: ./simple_synce-main2vm.sh [options]
Options:
  -d, --datacenter DATACENTER   Specify destination datacenter
  -v, --vms VM_LIST             Specify VMs to sync (comma-separated numbers or 'all')
  -j, --jobs NUM                Number of parallel jobs (default: 4)
  -y, --yes                     Skip confirmation prompt
  -h, --help                    Show this help message

Example automated usage:
  ./simple_synce-main2vm.sh --datacenter arvan --vms all --jobs 8 --yes
  ./simple_synce-main2vm.sh -d cloudzy -v 1,3,5 -j 4 -y

=======================================================================================================

=======================================================================================================

ok. 
update the main.sh : 
i want to add option 4: 
title :
`run all script sequentially`
description: 
order Synchronize and env variable , edit edn , switch  .

and this option should run:

1- simple_synce-main2vm.sh
2- edit_edn_base_on_ip.sh
3- action.sh

=======================================================================================================

consider that i want to get the input for Select source datacenter, Select destination datacenter and Select VMs to migrate (whose variable is the same in all scripts) in main.sh parse theme automatically to other script : (`simple_synce-main2vm.sh` , `edit_edn_base_on_ip.sh`, `action.sh`).
so now i want that user just once for these input.
so you have to rewrite the main.sh .
do i have to change the `simple_synce-main2vm.sh` , `edit_edn_base_on_ip.sh`, `action.sh` scripts ? how to automaticaly pars these variable from main to these three script? ()


in main.sh : 
in 4: Run Full Workflow Sequentially : 

based on how each scripts accept Options from command-line arguments (i gave you help of each one in privously) : 
i want after user select this option ,  first gathers the required inputs (based on the contents of servers.conf) and then calls each of the three scripts with the appropriate command‐line arguments. (parse these input to command-line arguments for each script). 
i want after user select 4: Run Full Workflow Sequentially , all future needed input must fetch and show option from `servers.conf` file.
(learn how these three script get these options from user and get input and then implement it in main.sh )


for better overview:
For the synchronization step, it prompts for the destination datacenter, then lists the available VMs for that datacenter, asks for a VM selection (comma‐separated numbers or “all”), and a number of parallel jobs (default 4).
For the environment update step, it lets you reuse (or change) the datacenter selection, lists its VMs, and asks for a server selection.
For the service migration step, it prompts for a source datacenter and a destination datacenter (ensuring they differ), then displays the source VMs for the chosen source, asks for the VM numbers, the maximum parallel jobs (default 2), and finally lets you choose the service (binance, kucoin, or gateio).


=======================================================================================================

i think i didnt say to yo where are the files :
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INFO_PATH="$(dirname "$0")/Info"
SERVERS_CONF="$INFO_PATH/servers.conf"

and avilable service is not in servers.conf file.
list of available service : 
Available Services:
1. binance
2. kucoin
3. gateio

it have to be some thing like bellow :(for example for action.sh is : )

(base) amin@SY73-DV:~/git_repos/Synchronize_Switch$ ./action.sh 
Available Datacenters:
1. arvan
2. azma
3. cloudzy
Select source datacenter (1-3): 1
Select destination datacenter (1-3): 2
Available Source VMs:
1. cr1arvan
2. cr2arvan
3. cr3arvan
4. cr4arvan
5. cr5arvan
6. cr6arvan
7. all
Select source VMs (enter digits without spaces, e.g. 614 for VMs 6, 1, and 4, or select 'all'): all
Using maximum parallel jobs: 2

Available Services:
1. binance
2. kucoin
3. gateio
Select service (1-3): 1

Configuration Summary:
Source: arvan - Server Order: (1- cr1arvan 2- cr2arvan 3- cr3arvan 4- cr4arvan 5- cr5arvan 6- cr6arvan )
Destination: azma - Server Order: (1- cr1azma 2- cr2azma 3- cr3azma 4- cr4azma 5- cr5azma 6- cr6azma )
Maximum parallel jobs: 2
Selected service: Binance

=======================================================================================================

again it dosent show any thing . here is output :
Enter a number (0, 1, 2, 3, or 4): 4
Running Full Workflow Sequentially...
Select source datacenter (1-4): 2
Select destination datacenter (1-4): 3
Select source VMs (enter digits without spaces, e.g. 614 for VMs 6, 1, and 4, or select 'all'): all
Enter maximum parallel jobs [default: 2]: 2
Select service (1-3): 1
Proceed with these settings? (y/n): 

=======================================================================================================
you made mistake .
why the number are start with 7 (instead of 1) in bellow :
Available VMs for cloudzy:
7. cr7cloudzy (45.61.149.207)
8. cr8cloudzy (185.204.169.249)

for example this is the part of action.sh script, (snipp code) extracted, and explain the user input and servers.conf interaction parts of action.sh script. leran from it how to take input from user and how to read .conf file. 
:

for example this is the part of edit_edn_base_on_ip.sh script, (snipp code) extracted, and explain the user input and servers.conf interaction parts of edit_edn_base_on_ip.sh script. leran from it how to take input from user and how to read .conf file. 
:

=======================================================================================================
i made mistake.
let me to clearifing you.

in edit_edn_base_on_ip.sh and simple_synce-main2vm.sh we must select destination datacenter and destination vm by user. but in action.sh the user select source datacenter and source vm and destination datacenter, but the vm destination select automatically based on source datacenter and source vm and destination datacenter. so for edit_edn_base_on_ip.sh and simple_synce-main2vm.sh we should determine the destination vm. and for action.sh we should not. 

=======================================================================================================

ok. now based on action.sh snipp code. 
consider that i want to write a new function in bash script that get input from user like action.sh and store them in related variable (based on the variable name that used in action.sh). 
consider the fuction that you write must capable to run in new independent script.
so use function in a new very simple script named sc_3 that take input and print theme. 


=======================================================================================================

ok. now based on simple_synce-main2vm.sh snipp code. 
consider that i want to write a new function in bash script that get input from user like simple_synce-main2vm.sh and store them in related variable (based om the variable name that used in simple_synce-main2vm.sh). 
consider the function that you write must capable to run in new independent script.
so use function in a new very simple script named sc_2 that take input and print theme. 


=======================================================================================================
ok. consider that the 

in main.sh : 
in 4: Run Full Workflow Sequentially : 

based on how each scripts accept Options from command-line arguments (i gave you help of each one in privously) : 
i want after user select this option ,  first gathers the required inputs (based on the contents of servers.conf) and then calls each of the three scripts with the appropriate command‐line arguments. (parse these input to command-line arguments for each script). 
i want after user select 4: Run Full Workflow Sequentially , all future needed input must fetch and show option from `servers.conf` file.
(learn how these three script get these options from user and get input and then implement it in main.sh )

=======================================================================================================


=======================================================================================================
integrate all sc_1 sc_2 sc_3 , whit removing any  redundant variable. just once for mutual variable must take input. 

=======================================================================================================

ok. it worked great. i will name this code as input.sh. 
just make the menu  that show to user more beautiful and colorful , for better visualization to user . 
dont change the logic of the code and output at all. 


=======================================================================================================

in main.sh : 
in 4: Run Full Workflow Sequentially : 

in this stage first it have to run input.sh script. 
based on how each scripts accept options from command-line arguments (i gave you help of each one in privously) : 
all needed input of other script store in a file named  Collected_Input in INFO_PATH directory. that structure of this file is like bellow :

example of Collected_Input file :

```
SOURCE_DATACENTER: arvan
Selected SOURCE VMs:
  - cr3arvan
  - cr4arvan
  - cr1arvan
DEST_DATACENTER: azma
Selected DEST VMs:
  - cr1azma
  - cr2azma
  - cr3azma
  - cr4azma
  - cr5azma
  - cr6azma
MAX_PARALLEL_JOBS: 3
SELECTED_SERVICE: gateio
```

i want in this option , the script must run based on these input (parse these input from Collected_Input file to command-line arguments for each script).
i want after user select 4: Run Full Workflow Sequentially , all future needed input must fetch from `Collected_Input` file. 

for example if Collected_Input like what i gave to you previousely, the script must run wit hthis argument sequentially:

./simple_synce-main2vm.sh -d azma -v 1,2,3,4,5,6 -j 3 -y
./edit_edn_base_on_ip.sh --datacenter azma --servers 1,2,3,4,5,6
./action.sh -s arvan -d azma -v 3,4,1 -p 3 -r gateio -y
=======================================================================================================

make 3 hypocritical Collected_Input file content , and then  Based on that, the following commands will be built ? 
(to ensure your code map correctly the value of Collected_Input to command line cli argument.)

=======================================================================================================

i want make some change in logic of the mapping .
your logic is correct when number that in vm name is equal to vm number. 
for example_1 in this service.conf file :
```
arvan|cr1arvan|185.204.170.177|cr1arvan.stellaramc.ir|ubuntu|22
arvan|cr2arvan|185.204.171.190|cr2arvan.stellaramc.ir|ubuntu|22
arvan|cr3arvan|185.204.170.246|cr3arvan.stellaramc.ir|ubuntu|22
arvan|cr4arvan|185.204.168.198|cr4arvan.stellaramc.ir|ubuntu|22
arvan|cr5arvan|185.204.169.190|cr5arvan.stellaramc.ir|ubuntu|22
arvan|cr6arvan|185.204.170.134|cr6arvan.stellaramc.ir|ubuntu|22
```

there is 6 vm available in arvan datacenter and the number that exist in vm name equal to vm number in list. (vm cr2arvan is the second vm in this list)


but in example_2 in this service.conf file :
```
arvan|cr7arvan|185.204.170.86|cr7arvan.stellaramc.ir|ubuntu|22
arvan|cr12arvan|45.61.149.207|45.61.149.207|ubuntu|22

cloudzy|cr7cloudzy|45.61.149.207|cr7cloudzy.stellaramc.ir|ubuntu|22
cloudzy|cr8cloudzy|185.204.169.249|185.204.169.249|ubuntu|22
```
there is 2 vm available in arvan datacenter and the number that exist in vm name NOT equal to vm number in list. (vm cr7arvan is the first vm in this list, cr12arvan is the second vm in this list)


and the number that have to use in the command line argument is the Its position number in the list. 

(so ther have to be the second mapping proccess that map )


=======================================================================================================

i want to make somne changes. 
In the current script the user select source datacenter and source vm and destination datacenter, but the vms destination select automatically based on source datacenter and source vm and destination datacenter (by predifined logic that script used.). now i want to chose vms destination manually based on vm that available in the the destination datacenter. (like how i chose source vms)
if it is possible , beceuse of the code is too long just tell me with part of the code i have to remove and what lines i have to add and where. if it is not possible or difficult , give me the whjole code. 
=======================================================================================================
it worked well. but for destination vm i want to enter digits like source vm (something like : Select destination VMs (enter digits without spaces, e.g. 614 for VMs 6, 1, and 4, or select 'all'): 1)

and it have to map to source vm automatically.
i mean imagin this scenario : 
Source datacenter : cloudzy 
destination datacenter : arvan 

user input 345 for source VMs
user input 126 for destination VMs

so that means destination VM for cr3cloudzy is cr1arvan, destination VM for cr4cloudzy is cr2arvan, destination VM for cr5cloudzy is cr6arvan.


also it can be possible that Source datacenter and destination datacenter can be same. (but source vm and dest vm should not be same at all)

i mean imagine this scenario:
Source datacenter : cloudzy 
destination datacenter : cloudzy 

user input 21 for source VMs
user input 34 for destination VMs
so that means destination VM for cr2cloudzy is cr3cloudzy, destination VM for cr1cloudzy is cr4cloudzy.

(
and for forbidden scenario: 
imagine this scenario:
Source datacenter : cloudzy 
destination datacenter : cloudzy 

user input 2 for source VMs
user input 2 for destination VMs

so that means destination VM for cr2cloudzy is cr2cloudzy. witch not allowed and forbiodden.
)

again if it is possible , beceuse of the code is too long just tell me with part of the code i have to remove and what lines i have to add and where. if it is not possible or difficult , give me the whjole code. 

=======================================================================================================
i want to make small change: 
if it is possible dont rewrite all the code, beceuse of the code is too long, just tell me witch part of the code i have to remove or change and what lines i have to add and where. 

just in non interactive mode: (for format of how to give argument in non interactive mod)
in `-v SRC_VMS       Source VM numbers (digits without spaces, e.g., '345' or 'all')"` it have to change (comma-separated numbers or "all"). 
and 
in `-D DEST_VMS      Destination VM numbers (digits without spaces, e.g., '126')"` it have to change (comma-separated numbers or "all")

i mean instead of 345 argument it have to be `3,4,5`
./action.sh -s arvan -d cloudzy -v 3,4,5 -D 1,2,6 -p 3 -r binance -y
=======================================================================================================

i want to make small change: 
in `Select service` section:
Available Services:
1. binance
2. kucoin
3. gateio
Select service (1-3)

i want user be able to chose multipli item. i mean if user enter `12` , it means binance and kucoin are selected. or if user enter `31` , it means gateio and binance are selected. 
alsow add `all` option at the end of this list:
Available Services:
1. binance
2. kucoin
3. gateio
4. all
(i mean when user chosed `4` that means  `binance` and `kucoin` and `gateio` [all option in the list] are selected)


so based on this selection, the related deployment scripts must select for copy to source vm and destionation vm .
i mean for example if user enter `12` (selected binance and kucoin), related script is : deploy_all_binance.sh and start_all_binance.sh and deploy_all_kucoin.sh and start_all_kucoin.sh (for destination vm) and stop_all_binance.sh and purge_all_binance.sh and stop_all_kucoin.sh and purge_all_kucoin.sh (for source vm) must select.
so all related thing (including copying related deployment scripts and executing these related script in the source and dest vm and ... based on this new structure.)

dont rewrite all the code, beceuse of the code is too long, just tell me witch part of the code i have to remove or change and what lines i have to add and where.
=======================================================================================================

ok.
worked well.
i want to reorder the how script take input.

in current script the order is :
```
Select SOURCE datacenter 
Select SOURCE VM(s) (e.g., '614' for VMs 6,1,4 or 'all'): 
Select DESTINATION datacenter 
Select DESTINATION VM(s) (e.g., '246' for VMs 2,4,6 or 'all'):
Enter maximum parallel jobs [default 4]: 
Select service (1-3):
```

i want this new order :
```
Select service (1-3):
Select SOURCE datacenter 
Select DESTINATION datacenter 
Select SOURCE VM(s) (e.g., '614' for VMs 6,1,4 or 'all'): 
Select DESTINATION VM(s) (e.g., '246' for VMs 2,4,6 or 'all'):
Enter maximum parallel jobs [default 4]: 
```

=======================================================================================================
ok it worked.
but one logical bug:
imagine this scenario:
```
(base) amin@SY73-DV:~/git_repos/Synchronize_Switch$ ./input.sh 

=== Available Datacenters ===
1. arvan
2. azma
3. cloudzy
4. local
Select SOURCE datacenter (1-4): 1
Selected SOURCE Datacenter: arvan

=== Available Source VMs in arvan ===
1. cr7arvan
2. cr8arvan
3. all (select all VMs)
Select SOURCE VM(s) (e.g., '614' for VMs 6,1,4 or 'all'): 3
Select DESTINATION datacenter (1-4): 1
Selected DESTINATION Datacenter: arvan

=== Available Destination VMs in arvan ===
1. cr7arvan
2. cr8arvan
3. all (select all VMs)
Select DESTINATION VM(s) (e.g., '246' for VMs 2,4,6 or 'all'): 3
Enter maximum parallel jobs [default 4]: 3

=== Available Services ===
1. binance
2. kucoin
3. gateio
4. all (select all services)
Select service(s) (e.g., '12' for binance and kucoin, '4' for all): 4
```


so the output is : 
```
SOURCE_DATACENTER: arvan
Selected SOURCE VMs:
  - cr7arvan
  - cr8arvan
DEST_DATACENTER: arvan
Selected DEST VMs:
  - cr7arvan
  - cr8arvan
MAX_PARALLEL_JOBS: 3
SELECTED SERVICES: binance kucoin gateio
```
so when source datecenter and dest datacenter is the same, i chose `all` option in both of theme , it result that destination VM for cr7arvan is cr7arvan. witch not allowed and forbiodden.

=======================================================================================================
ok it worked.

there is one change in fild of SELECTED SERVICES: in Collected_Input file.
consider that SELECTED SERVICES can have multiple value, for wxample imagine bnellow Collected_Input file :
```
SOURCE_DATACENTER: arvan
Selected SOURCE VMs:
  - cr7arvan
  - cr8arvan
DEST_DATACENTER: arvan
Selected DEST VMs:
  - cr7arvan
  - cr8arvan
MAX_PARALLEL_JOBS: 3
SELECTED SERVICES: binance kucoin gateio
```

and so for option `-r` in action.sh ,Services can have multi value with format comma-separated, e.g., 'binance,kucoin'
so SELECTED SERVICES have to map correctly to argumen requier `-r` . 
for example : 
./action.sh -s arvan -d cloudzy -v 345 -D 126 -p 3 -r binance,kucoin -y 
=======================================================================================================

ok it worked.

there is some change in structure of Collected_Input file. (order of field is changed)
here is a new sample of Collected_Input file :
```
SELECTED SERVICES: kucoin gateio
SOURCE_DATACENTER: arvan
Selected SOURCE VMs:
  - cr7arvan
  - cr8arvan
DEST_DATACENTER: cloudzy
Selected DEST VMs:
  - cr7cloudzy
  - cr8cloudzy
MAX_PARALLEL_JOBS: 4
```

so rewrite the code based on that.
=======================================================================================================


ok. good.
i want add new feature in Option 4 branch in main.sh : 
i want when ./input.sh runs copmletly, ask user that dose he approve the final Collected Input (if enter Y Continue executing the code, and if he entered `n` (means no) ./input.sh must be run again.  )
i want the default value for the "Do you approve the final Collected Input? (Y/n): " be Y. so if user hit enter means Y. 

=======================================================================================================
this is the format of each column in log file :
| Timestamp | Action Icon | Action Name | Task Description | Server | Status | 

i want to extend predifined length of `Action Name` and `Task Description` field. Add 20 characters (or more if needed) to each of these fields.
also i want a new field named Job that define job number. 

for example the log file have to be:

| Timestamp          |Icon| Action Name                        | Task Description              | Server                  | Status            | Job
[2025-03-11 09:32:15] ✅   [Action Copying deployment_scripts] | copy deploy_all_binance.sh    | Server: cr7arvan        | STATUS: Completed | Job 2
[2025-03-11 09:32:21] ──▶  [Action 1                         ] | Deploy Binance Service        | Server: cr7cloudzy      | STATUS: Started   | Job 1

also if log file exist before i want to append the content in the end of it. 

dont rewrite all the code, beceuse of the code is too long, just tell me witch part of the code i have to remove or change and what lines i have to add and where. and alsow update the code in your memory. so that latest version with imposing vhanges must be in your memory.
=======================================================================================================

i want to add some small featuer.

in current script , in interactive mode , the script dosent get input for Maximum parallel jobs from user. i want to get Maximum parallel jobs from user.
and this must happen after Select services section. (the default value must be 1) 
(in current script in automated mode this issue its ok and the user can set Maximum parallel jobs with -p option )
=======================================================================================================
in my script (ubuntu 22.04): 
i defined :
`    SOURCE_PATH="/home/ubuntu/1111-binance-services/cr$VM_NUMBER"`

but the user is not neccecaryy ubuntu, it can be volatile, so how to change that command that define default user in /home/ubuntu ? 


=======================================================================================================
now for each script i want to write a example-name_of_script.md file.
in this file you have to make hypotetical inputs scenario from servers.conf and tell the user what happen base on this hypotetical inputs. 
make at least two different scenario. 
=======================================================================================================
ok. now i want to remove the Info_Source.txt and Info_Dest.txt. all default information must be read from servers.conf. (that locate in the same old directory INFO_PATH="$(dirname "$0")/Info")
here is the context of servers.conf:
# servers.conf - Server Configuration File
# Format: datacenter|vm_name|ip|host|username|port

arvan|cr1arvan|185.204.170.177|cr1arvan.stellaramc.ir|ubuntu|22
arvan|cr2arvan|185.204.171.190|cr2arvan.stellaramc.ir|ubuntu|22
arvan|cr3arvan|185.204.170.246|cr3arvan.stellaramc.ir|ubuntu|22
arvan|cr4arvan|185.204.168.198|cr4arvan.stellaramc.ir|ubuntu|22
arvan|cr5arvan|185.204.169.190|cr5arvan.stellaramc.ir|ubuntu|22
arvan|cr6arvan|185.204.170.134|cr6arvan.stellaramc.ir|ubuntu|22

cloudzy|cr1cloudzy|172.86.68.12|cr1cloudzy.stellaramc.ir|ubuntu|22
cloudzy|cr2cloudzy|216.126.229.35|cr2cloudzy.stellaramc.ir|ubuntu|22
cloudzy|cr3cloudzy|216.126.229.33|cr3cloudzy.stellaramc.ir|ubuntu|22
cloudzy|cr4cloudzy|216.126.229.36|cr4cloudzy.stellaramc.ir|ubuntu|22
cloudzy|cr5cloudzy|172.86.94.38|cr5cloudzy.stellaramc.ir|ubuntu|22
cloudzy|cr6cloudzy|172.86.93.39|cr6cloudzy.stellaramc.ir|ubuntu|22

azma|cr1azma|172.20.10.31|172.20.10.31|ubuntu|22
azma|cr2azma|172.20.10.32|172.20.10.32|ubuntu|22
azma|cr3azma|172.20.10.33|172.20.10.33|ubuntu|22
azma|cr4azma|172.20.10.34|172.20.10.34|ubuntu|22
azma|cr5azma|172.20.10.35|172.20.10.35|ubuntu|22
azma|cr6azma|172.20.10.36|172.20.10.36|ubuntu|22



option for datacenter must fetched from servers.conf. (in this case options are : 1- arvan 2- cloudzy 3- azma)
so all the needed value must read from servers.conf. and do not ask user this pre defined value either. 
the user just have to determine two thing (as input)

1- choose destionation data center(Among the options available for data centers ).

2- based on dest data center that chosed in step 2 , related vm_name have to show to user and user pick one of theme.
for example if azma datacenter chosed as dest data center, the option in stage 2 must be : 
1. cr1azma
2. cr2azma
3. cr3azma
4. cr4azma
5. cr5azma
6. cr6azma

now i want that in stage two (i mean user pick one of vm_name) change that to user be able to chose multipli item. i mean if user enter 6145 , it means cr6azma and cr1azma and cr4cazma and cr5cazma are selected sequentially .
so you have to set value that need in script based on information in servers.conf and these three input. so in this example it means job_1 must be do in cr6azma and job_2 in cr1azma and job_3 in cr4cazma and job_4 in cr5cazma vms. 
and also you ave to add new option named `all` at the end of the vm_name list.  for example (in this exampleit means that if user input `7` it means user select 123456): 

1. cr1azma
2. cr2azma
3. cr3azma
4. cr4azma
5. cr5azma
6. cr6azma
7. all



so now imagine this scenario that user chosed this : 
destionation data center = azma
DEST_VMS = cr5azma,cr1azma

so you have to set value that need in script based on information in servers.conf and these two input.
each line of servers.conf have Format: datacenter|vm_name|ip|host|username|port
the ssh connection must be base on ssh -p port username@host . for example : ssh -p 22 ubuntu@cr3cloudzy.stellaramc.ir

so in this sample scenario these valu must set :
for job_1: 

DEST_USER=ubuntu
DEST_IP=172.20.10.33
DEST_PORT=22
DEST_PATH=$HOME

for job_2 :

DEST_USER=ubuntu
DEST_IP=172.20.10.31
DEST_PORT=22
DEST_PATH=$HOME


the address for ssh must fetche from servers.conf based on host column. i mean for example vm_name was cr3cloudzy and related host in servers.conf was `cr3cloudzy.stellaramc.ir`


so now SOURCE_* and DEST_* is determine.

in each job the selected actions must be done. 

consider that :
Each time I connect to a remote VM from my local machine, the SSH connection is slow. To improve efficiency, I want to minimize the number of SSH connections and execute as many requests as possible within a single session. The script needs to be optimized to reduce SSH overhead and improve performance in other ways. Please rewrite it to achieve these improvements. the speed is important. so for example  you can get from user to Enter maximum parallel jobs (MAX_PARALLEL_JOBS) and do each jobs simultaneously. (still the action in each job must be done sequentially. i mean if 231 iput for action in job_1, so first action 2 must run , then action 3, and then action 1)

=======================================================================================================
bug  :
in : 
--- SELECT DESTINATION DATACENTER ---
1: 
2: arvan
3: azma
4: cloudzy
Select datacenter (1-4): 

why option 1 is empty ? its wrong. 

also make menu that show to user more beautiful and colorfully. (better visualization)

=======================================================================================================

i want to change the content of log file. 
the script use two file for save logs: service_timestamps*.log and service_actions*.log . 
the  service_timestamps*.log is not nececary . so remove it.
also if log file exist before i want to append the content in the end of it. 
but this format of loging in the ervice_actions_*.log  have to be something like this : 

# Service Migration Log - Started Wed Mar 12 01:26:32 PM +0330 2025
# Format: Timestamp | Action | Task Description | Server | Status | Job
# --------------------------------------------------------------------

# New Migration Session - Wed Mar 12 01:28:07 PM +0330 2025
# --------------------------------------------------------------------

------------------------------------------------------------
|            Service Transfer Operation - Job 1            |
------------------------------------------------------------

[2025-03-12 13:28:25] ──▶ [Action Setting up S] |                                | Server: cr7arvan             | STATUS: Started    
[2025-03-12 13:28:26] ✅  [Action Setting up S] |                                | Server: cr7arvan             | STATUS: Completed  
[2025-03-12 13:28:26] ──▶ [Action Setting up S] |                                | Server: cr7cloudzy           | STATUS: Started    
[2025-03-12 13:28:29] ✅  [Action Setting up S] |                                | Server: cr7cloudzy           | STATUS: Completed  
[2025-03-12 13:28:29] ──▶ [Action Copying depl] | Copy Scripts for binance       | Server: cr7arvan             | STATUS: Started    | Job 1
[2025-03-12 13:28:32] ✅  [Action Copying depl] | Copy Scripts for binance       | Server: cr7arvan             | STATUS: Completed  | Job 1
[2025-03-12 13:28:32] ──▶ [Action Copying depl] | Copy Scripts for binance       | Server: cr7cloudzy           | STATUS: Started    | Job 1
[2025-03-12 13:28:38] ✅  [Action Copying depl] | Copy Scripts for binance       | Server: cr7cloudzy           | STATUS: Completed  | Job 1
[2025-03-12 13:28:38] ──▶ [Action 1           ] | Deploy Binance Service         | Server: cr7cloudzy           | STATUS: Started    | Job 1
[2025-03-12 13:28:41] ✅  [Action 1           ] | Deploy Binance Service         | Server: cr7cloudzy           | STATUS: Completed  | Job 1
[2025-03-12 13:28:41] ──▶ [Action 2           ] | Start Binance Service          | Server: cr7cloudzy           | STATUS: Started    | Job 1
[2025-03-12 13:28:42] ✅  [Action 2           ] | Start Binance Service          | Server: cr7cloudzy           | STATUS: Completed  | Job 1
[2025-03-12 13:28:47] ──▶ [Action 3           ] | Stop Binance Service           | Server: cr7arvan             | STATUS: Started    | Job 1
[2025-03-12 13:28:49] ✅  [Action 3           ] | Stop Binance Service           | Server: cr7arvan             | STATUS: Completed  | Job 1
[2025-03-12 13:28:49] ──▶ [Action 4           ] | Purge Binance Service          | Server: cr7arvan             | STATUS: Started    | Job 1
[2025-03-12 13:28:50] ✅  [Action 4           ] | Purge Binance Service          | Server: cr7arvan             | STATUS: Completed  | Job 1
[2025-03-12 13:28:50] ──▶ [Action Closing SSH ] |                                | Server: cr7arvan             | STATUS: Started    
[2025-03-12 13:28:50] ✅  [Action Closing SSH ] |                                | Server: cr7arvan             | STATUS: Completed  
[2025-03-12 13:28:50] ──▶ [Action Closing SSH ] |                                | Server: cr7cloudzy           | STATUS: Started    
[2025-03-12 13:28:50] ✅  [Action Closing SSH ] |                                | Server: cr7cloudzy           | STATUS: Completed  

=======================================================================================================
i want user be able to chose multipli item. i mean if user enter `12` , it means binance and kucoin are selected. or if user enter `31` , it means gateio and binance are selected.
alsow add `all` option at the end of this list:
Available Services:
1. binance
2. kucoin
3. gateio
4. all
(i mean when user chosed `4` that means `binance` and `kucoin` and `gateio` [all option in the list] are selected)

so based on this selection, the related deployment scripts must select for copy to destionation vm .

i mean for example if user enter `12` (selected binance and kucoin), and chosed `34` for actions, related script is :  stop_all_binance.sh and purge_all_binance.sh and stop_all_kucoin.sh and purge_all_kucoin.sh (for destination vm)  must select.

so all related thing (including copying related deployment scripts and executing these related script in the dest vm and ... based on this new structure.
=======================================================================================================
ok. two thing that needs to  be change. 
1- the workflow and how the proceed of proccess must show to user in cli live. 
2- add Configures SSH options for all ssh connections. 
SSH_OPTS="-o StrictHostKeyChecking=no" → Prevents SSH from asking about new host keys (useful for automation but can be a security risk). 
3- the format of how get number for action from user must comma seperated. ( i mean for Enter sequence of actions the `1,2` and `1` and `3,1,2` and `1,2,3,4` and `2` and so on, is accepted , but `12` and `321` and `231` and `43` and so on must not accepted.) and if user input `1` that means only action 1 must be do, and if `2,3` entered , that means action 2 must be do and then action 3 must do , sequentially. ok ? 

=======================================================================================================
some changes must do in code:

1- it dosent neccecary to be live update in cli, just show what ever in log file in cli too. 
2- You have a misunderstanding of job concept. the number of job is the same as the number of vm that selected. for example : 
if Selected VMs: cr7arvan cr8arvan, so the job 1 is related to cr7arvan (i mean the job 1 is the proccess of doing related action in cr7arvan) and the job 2 is related to cr8arvan. 
3- in finall approval you have to show the summery of all user selected thing . (such as dest datacenter , vms, action , ... ) . the default value for approval is yes (Y/n). i mean if user hit enter in consider yes. also if user enter `n` (means no), the script must again take input from user, from beggining. 

=======================================================================================================
two issue must be resolve in script: 
- one : 
you made one mitake in log file. 
the log entries should be grouped under their respective job sections to maintain clarity. you have to reformat the log so that each job's log entries are contained within their own section, and events are shown in the correct order for each job.
Grouped each job's logs together under Job 1 and Job 2 sections.
Kept the chronological order inside each job.
No mixing of actions from different jobs in the same section.


i mean for example in your current script the log file is like : 

------------------------------------------------------------
|            Service Transfer Operation - Job 1            |
|                   Server: cr7arvan                      |
------------------------------------------------------------

[2025-03-12 15:31:00] ──▶ [Action Setting up S   ] | Establishing SSH connection    | Server: cr7arvan                  | STATUS: Started         | Job 1

------------------------------------------------------------
|            Service Transfer Operation - Job 2            |
|                   Server: cr8arvan                      |
------------------------------------------------------------

[2025-03-12 15:31:01] ──▶ [Action Setting up S   ] | Establishing SSH connection    | Server: cr8arvan                  | STATUS: Started         | Job 2
[2025-03-12 15:31:03] ✅  [Action Setting up S   ] | Establishing SSH connection    | Server: cr7arvan                  | STATUS: Completed       | Job 1
[2025-03-12 15:31:04] ──▶ [Action Copying depl   ] | Copy Scripts for binance       | Server: cr7arvan                  | STATUS: Started         | Job 1
[2025-03-12 15:31:05] ✅  [Action Setting up S   ] | Establishing SSH connection    | Server: cr8arvan                  | STATUS: Completed       | Job 2
[2025-03-12 15:31:09] ──▶ [Action Copying depl   ] | Copy Scripts for binance       | Server: cr8arvan                  | STATUS: Started         | Job 2


witch is not correct. 

and it have to be for example like : 
------------------------------------------------------------
|            Service Transfer Operation - Job 1            |
|                   Server: cr7arvan                      |
------------------------------------------------------------

[2025-03-12 15:31:00] ──▶ [Action Setting up S   ] | Establishing SSH connection    | Server: cr7arvan                  | STATUS: Started         | Job 1
[2025-03-12 15:31:03] ✅  [Action Setting up S   ] | Establishing SSH connection    | Server: cr7arvan                  | STATUS: Completed       | Job 1
[2025-03-12 15:31:04] ──▶ [Action Copying depl   ] | Copy Scripts for binance       | Server: cr7arvan                  | STATUS: Started         | Job 1

------------------------------------------------------------
|            Service Transfer Operation - Job 2            |
|                   Server: cr8arvan                      |
------------------------------------------------------------

[2025-03-12 15:31:01] ──▶ [Action Setting up S   ] | Establishing SSH connection    | Server: cr8arvan                  | STATUS: Started         | Job 2
[2025-03-12 15:31:05] ✅  [Action Setting up S   ] | Establishing SSH connection    | Server: cr8arvan                  | STATUS: Completed       | Job 2
[2025-03-12 15:31:09] ──▶ [Action Copying depl   ] | Copy Scripts for binance       | Server: cr8arvan                  | STATUS: Started         | Job 2


- two:
i want the script can capable to automate the passing of the user input,(i want both interactive mode and automated mode) so i should update script so that they can accept predefined input from command-line arguments. so here is the steps that i think helpful:
Check for command-line arguments:
At the very start, check if parameters are passed (e.g., by checking if $1 is empty).
Assign them to related variables in the code.
Skip the interactive input if these values are provided.
This change makes my scripts more flexible. i can use them in both interactive mode and automated mode depending on whether the parameters are passed.
after you write the code , make example of use case how to pass input automatically.
=======================================================================================================
3- the format of how get number for Select services from user must comma seperated. ( i mean for Select services  the `1,2` and `1` and `3,1,2` and `1,2,3,4` and `2` and so on, is accepted , but `12` and `321` and `231` and `43` and so on must not accepted.)


ok. now i want make some change in script. dont change the logic and functionality of the code at all. make menu that show to user more beautiful and colorfully. (better visualization) give me the whole code based on imposing latest changes.

=======================================================================================================
i want when user chosed 2. Main machine to VM transfer option , after  CONFIGURATION SUMMARY   shown and user comfirm with y (the default value for approval is yes (Y/n). i mean if user hit enter in consider yes. also if user enter `n` (means no), the script must again take input from user, from beggining. )
so after user confirm the CONFIGURATION SUMMARY, two option must show to user : 

  1. Transfer a specific file or folder from Main VM to destination VM
  2. Sync by patterns - Transfer specific files/folders from SOURCE_PATH="$HOME/1111-binance-services/cr$VM_NUMBER" based on patterns
   (van-buren-* directories, .sh files, .secret/ folder)

and if 1 chosed , continue based on previous logig, and when 2 chosed , the script must run the script simple_synce-main2vm.sh that in the same directory of current runnin script. 
=======================================================================================================

make all titles aligned in a clomun. make all description aligned in a clomun.
also the Preparing Files showing take time and not suitable. make it more faster. 

=======================================================================================================
i dont like the interface. propose alternative approach. its not beautifull. 
=======================================================================================================

its good . but unreadable character after (Saturday, March 15, 2025 12:20) :
������������������������������������
=======================================================================================================

i want when user chosed 2. Main machine to VM transfer option , after CONFIGURATION SUMMARY shown and user comfirm with y (the default value for approval is yes (Y/n). i mean if user hit enter in consider yes. also if user enter n (means no), the script must again take input from user, from beggining. )
so after user confirm the CONFIGURATION SUMMARY, two option must show to user :
 1. Transfer a specific file or folder from Main VM to destination VM
 2. Sync by patterns - Transfer specific files/folders from SOURCE_PATH="$HOME/1111-binance-services/cr$VM_NUMBER" based on patterns
 (van-buren-* directories, .sh files, .secret/ folder) 

(make this menue more concise)
and if 1 chosed , continue based on previous logig, and when 2 chosed , the script must run the script simple_synce-main2vm.sh that in the same directory of current runnin script.
=======================================================================================================


after `2. Main machine to VM transfer` selected by user, there have to be immidiaitly show `TRANSFER OPTIONS ` menu . 
dont rewrite all the code, beceuse of the code is too long, just tell me witch part of the code i have to remove or change and what lines i have to add and where. and alsow update the code in your memory. so that latest version with imposing vhanges must be in your memory.

=======================================================================================================
ok. good. 
now i want to add real date to output and .json file both. you have to take beggining date for initiall palning as input from user (the default value must be current date). and the scheduling nmust be set for 1 next month. 