#!/bin/sh -xv

yum update -y
yum install java -y
yum install java-11-openjdk-devel -y
yum install git wget zip unzip nano -y
yum install docker -y
yum install maven jq ansible make -y
mkdir /var/jenkins/
chmod 777 -R /var/jenkins/

#sudo update-alternatives --config java

#gradle config
wget https://services.gradle.org/distributions/gradle-5.1.1-bin.zip -P /tmp
unzip -d /opt/gradle /tmp/gradle-5.1.1-bin.zip
#ls /opt/gradle/gradle-5.1.1
touch /etc/profile.d/gradle.sh
echo 'export GRADLE_HOME=/opt/gradle/gradle-5.1.1' >> /etc/profile.d/gradle.sh
echo 'export PATH=${GRADLE_HOME}/bin:${PATH}' >> /etc/profile.d/gradle.sh
chmod +x /etc/profile.d/gradle.sh
source /etc/profile.d/gradle.sh

#ssm agent install
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
systemctl status amazon-ssm-agent

#Terraform installation
curl -O https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_linux_amd64.zip
unzip terraform_1.1.7_linux_amd64.zip -d /usr/local/bin/

#Script to add a user to Linux system
username='ansible'
password='ansible123'
if [ $(id -u) -eq 0 ]; then
        #read -p "Enter username : " username
        #read -s -p "Enter password : " password
        egrep "^$username" /etc/passwd >/dev/null
        if [ $? -eq 0 ]; then
                echo "$username exists!"
                exit 1
        else
                pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
                useradd -m -p $pass $username
                [ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
        fi
else
        echo "Only root may add a user to the system"
        exit 2
fi

ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1

# Run me with superuser privileges
echo '$username       ALL=(ALL)       ALL' >> /etc/sudoers

sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
#echo /etc/ssh/sshd_config
#PasswordAuthentication yes
#PasswordAuthentication no
service sshd restart
exit 3