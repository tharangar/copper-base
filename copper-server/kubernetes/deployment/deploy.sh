#!/bin/bash


set -e

ECHO=`which echo`
KUBECTL=`which kubectl`

# methods

# color refference
#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37

# Creating The Banner
#Colours
red="\033[00;31m"
RED="\033[01;31m"

green="\033[00;32m"
GREEN="\033[01;32m"

brown="\033[00;33m"
YELLOW="\033[01;33m"

blue="\033[00;34m"
BLUE="\033[01;34m"

purple="\033[00;35m"
PURPLE="\033[01;35m"

cyan="\033[00;36m"
CYAN="\033[01;36m"

white="\033[00;37m"
WHITE="\033[01;37m"

WHITECHAR="\033[01;39m"

NC="\033[00m"
BOLD="\e[1m"
NRM="\e[0m"

echo "${RED}******************************************************************************"
echo "${WHITE}**                                                                          **"
echo "${WHITECHAR}**          POWERED BY LANKA SOFTWARE FOUNDATION  (LSF)                     **"
echo "${WHITE}**                                                                          **"
echo "${RED}******************************************************************************"

#   Add follwing tag after command for ignoring stdout, errors etc
#   > /dev/null throw away stdout
#   1> /dev/null throw away stdout
#   2> /dev/null throw away stderr
#   &> /dev/null throw away both stdout and stderr


# method to print bold
function echoBold () {
    ${ECHO} $'\e[1m'"${1}"$'\e[0m'
}

# method to print red bold fonts 
function echoRedBold () {
    #    .---------- constant part!
    #    vvvv vvvv-- the code from above
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    BD='\e[1m' # bold
    NM='\e[0m' # normal size
    RDBD='\033[0;31m\e[1m' # red and bold
    RDNM='\e[0m\033[0m' # normal color and normal size
    #printf "* ${BD}${RED}-${1} ${NC}${NM}\n"
    #${ECHO} ${RED}${1}
    printf "* ${RDBD}-${1} ${RDNM}\n"
    
}

# method to print red bold fonts 
function echoGreenBold () {
    #    .---------- constant part!
    #    vvvv vvvv-- the code from above
    RED='\033[0;32m' # green
    NC='\033[0m' # No Color
    BD='\e[1m' # bold
    NM='\e[0m' # normal size
    RDBD='\033[0;32m\e[1m' # green and bold
    RDNM='\e[0m\033[0m' # normal color and normal size
    #printf "* ${BD}${RED}-${1} ${NC}${NM}\n"
    #${ECHO} ${RED}${1}
    printf "* ${RDBD}-${1} ${RDNM}\n"
    
}

echoGreenBold 'Deploying Copper Email Server...'


############## START OF CONFIGURATION #############################

echoGreenBold 'Please Submit your Input data carefully...'

# Ask the user for their name
# echo Hello, who am I talking to?
# read varname
# echo "It's nice to meet you $varname" >> anu.txt
# echo What is your age?
# read age
# echo "Your age: $age" >> anu.txt

echo "apiVersion: v1" >> secret.yaml
echo "kind: Secret" >> secret.yaml
echo "metadata:" >> secret.yaml
echo "    name: email-secret" >> secret.yaml
echo "    namespace: monitoring" >> secret.yaml
echo "type: Opaque" >> secret.yaml
echo "stringData:" >> secret.yaml
echo "    TELEGRAF_VERSION: 1.8.1-1" >> secret.yaml

echo Enter mysql database name: 
read mysql_db
echo "    MYSQL_DATABASE: $mysql_db" >> secret.yaml

echo Enter mysql database password: 
read mysql_db_pwd
echo "    MYSQL_DATABASE: $mysql_db_pwd" >> secret.yaml

echo Enter admin username \(without domain\):
read CN
echo "    CN : $CN" >> secret.yaml

echo Your domain must contain 3 parts. \(Eg: part1.part2.part3\)
echo Enter the first part of domain:
read DC1
echo "    DC1 : $DC1" >> secret.yaml
echo Enter the second part of domain:
read DC2
echo "    DC2 : $DC2" >> secret.yaml
echo Enter the third part of domain:
read DC3
echo "    DC3 : $DC3" >> secret.yaml
echo Enter admin password:
read DNPASS
echo "    DNPASS : $DNPASS" >> secret.yaml


echo "    OU : Users" >> secret.yaml
echo "    LDAP_HOST_IP : ldap-service" >> secret.yaml
echo "    KEY_PATH : KEYPATH" >> secret.yaml

echo "    EMAIL : $CN@$DC1.$DC2.$DC3" >> secret.yaml
echo "    HOSTNAME : mail.$DC1.$DC2.$DC3" >> secret.yaml
echo "    FQDN : mail.$DC1.$DC2.$DC3" >> secret.yaml
echo "    DOMAIN : $DC1.$DC2.$DC3" >> secret.yaml

echo "    REDIS_HOST : REDIS_HOST" >> secret.yaml
echo "    REDIS_PORT : REDIS_PORT" >> secret.yaml
echo "    DEBUG : \"true\"" >> secret.yaml

echo Enter password for spam filter \(RspamD\)
read rspamd_pwd
echo "    RSPAMD_PASSWORD : $rspamd_pwd" >> secret.yaml


# Now Create the configuration secrets

echoGreenBold 'Configuration goint to be created...'
kubectl create -f deployment/secret.yaml 2> /dev/null || true
echoGreenBold 'Secret configuration files Created...'


######### END OF CONFIGURATION #############################################

# checking cert file list
# - cert.pem
# - fullchain.pem
# - privkey.key
# - dhparam.pem

# checking the cert.pem files exists
file="../tls/cert.pem"
if [ ! -f "$file" ]
then
    echoRedBold "$0: cert.pem file '${file}' not found in tls directory. !"
    exit 3 
fi

# checking the privkey.key files exists
file="../tls/privkey.pem"
if [ ! -f "$file" ]
then
    echoRedBold "$0: privkey.pem file '${file}' not found in tls directory. !"
    exit 3 
fi

# checking the dhparam.pem files exists
file="../tls/dhparam.pem"
if [ ! -f "$file" ]
then
    echoRedBold "$0: dhparam.pem file '${file}' not found in tls directory. !"
    exit 3 
fi

# checking the fullchain.pem files exists
#file="../tls/fullchain.pem"
#if [ ! -f "$file" ]
#then
#    echoRedBold "$0: fullchain.pem file '${file}' not found in tls directory. !"
#    exit 3 
#fi

echoGreenBold 'Certificate files are avaialbe in the tls folder'


# -------------------------------------


read -r -p "You are going to install copper Email. You should have coppied your certificate and key files to tls folder. Are you ready? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])


# starting kubernetes deployment

# changing to parent directory
cd ..

# Creating the k8s namespace
kubectl create namespace monitoring 2> /dev/null || true
echoGreenBold 'Monitoring namespace created...'
# Creating ldap server
kubectl create -f openldap/openldap.yaml 2> /dev/null || true
echoGreenBold 'openldap service created...'
# Create the phpldapadmin service  
kubectl create -f phpldapadmin/phpldapadmin.yaml 2> /dev/null || true
echoGreenBold 'phpldapadmin service Created...'
# creating emailserver docker image
#cd emailserver
#docker build -t emailserver . 2> /dev/null || true
#echoGreenBold 'Docker Email image Service Created...'
# wait 1 seconds 
#sleep 3s
#cd ..

# Create the emailserver service from kubernetes using docker image we have created now.
kubectl create -f emailserver/email.yaml 2> /dev/null || true
echoGreenBold 'email service created...'
#Building docker image

# Create the persistent volume and persistent volume claim for database
kubectl create -f persistent/mysql-pv.yaml  2> /dev/null || true
echoGreenBold 'Persistent Volume created...'
# Create mysql deployment
kubectl create -f persistent/mysql-deployment.yaml  2> /dev/null || true
echoGreenBold 'mysql deployment completed...'



#Build the docker image
#cd copperclient
#docker build -t webmail . 2> /dev/null || true
#echoGreenBold 'Docker webmail image created...'
# wait 1 seconds 
#sleep 1s
#cd ..

#Buld the kubernetes pod
#Kubectl create -f copperclient/webmail.yaml 2> /dev/null || true
#echoGreenBold 'Docker webclient service created...'

#Prometheus implementation
# Creating a roll has the access for clusters and bind the cluster roll.
kubectl create -f prometheus-alert/clusterRole.yaml 2> /dev/null || true
echoGreenBold 'Role creation and Role binding...'

# Create the config map to keep configuration data of prometheus
kubectl create -f prometheus-alert/config-map.yaml -n monitoring 2> /dev/null || true
echoGreenBold 'Prometheus configuration created...'

# Deploy prometheus pods 
kubectl create  -f prometheus-alert/prometheus-deployment.yaml --namespace=monitoring 2> /dev/null || true

# Create the service to access prometheus 
kubectl create -f prometheus-alert/prometheus-service.yaml --namespace=monitoring 2> /dev/null || true
echoGreenBold 'Prometheus service created...'
# Alert manager implementation
# Creating the configuration 
kubectl create -f prometheus-alert/AlertManagerConfigmap.yaml 2> /dev/null || true
#
kubectl create -f prometheus-alert/AlertTemplateConfigMap.yaml 2> /dev/null || true
echoGreenBold 'Alert Manager congiguration created..'
#
kubectl create -f prometheus-alert/Deployment.yaml 2> /dev/null || true
#
kubectl create -f prometheus-alert/Service.yaml 2> /dev/null || true
echoGreenBold 'Alert Manager created...'

# horde deployment
# cd ./groupware/horde
# docker build -t horde . 2> /dev/null || true
# cd ..
# cd ..
# kubectl create -f groupware/horde/horde.yaml 2> /dev/null || true

#
kubectl create -f groupware/groupoffice/groupoffice.yaml 2> /dev/null || true
echoGreenBold 'Groupoffice created...'

# wait 1 seconds 
sleep 1s

#use for service starting in all email pods
# https://stackoverflow.com/questions/51026174/running-a-command-on-all-kubernetes-pods-of-a-service

echoGreenBold 'Finished'

#sleep 5s

#kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -n monitoring -- mysql -h mysql -pc0pperDB


     ;;
    *)
        echoRedBold "Deployment cancelled"
        ;;
esac

