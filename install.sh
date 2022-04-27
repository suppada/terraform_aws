#!/bin/sh -xv

yum update -y
#yum install java -y
yum install java-11-openjdk -y
yum install git wget zip unzip nano -y
yum install -y bzip2
#yum install docker -y
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

#Docker install
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y https://download.docker.com/linux/centos/8/x86_64/stable/Packages/containerd.io-1.5.10-3.1.el8.x86_64.rpm
yum install -y docker-ce docker-ce-cli containerd.io --nobest
systemctl start docker
systemctl enable docker

#cfn-guard installation
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/aws-cloudformation/cloudformation-guard/main/install-guard.sh | sh
cp ~/.guard/bin/cfn-guard /usr/bin/

#Terraform installation
curl -O https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_linux_amd64.zip
unzip terraform_1.1.7_linux_amd64.zip -d /usr/local/bin/

#google chrome installation
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
yum install -y ./google-chrome-stable_current_*.rpm
#google-chrome --version

#chrome driver installation
wget https://chromedriver.storage.googleapis.com/101.0.4951.15/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
mv chromedriver /usr/bin
#chromedriver -version

#firefox install 47.0 version
wget https://ftp.mozilla.org/pub/firefox/releases/47.0.1/linux-x86_64/en-US/firefox-47.0.1.tar.bz2
tar xvf firefox
ln -s /opt/firefox/firefox /usr/bin/firefox

#geckodriver install
wget https://github.com/mozilla/geckodriver/releases/download/v0.31.0/geckodriver-v0.31.0-linux64.tar.gz
tar -xvf geckodriver-v0.31.0-linux64.tar.gz
mv geckodriver /usr/bin
#geckodriver --version

#Jenkins installation
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum upgrade -y
# Add required dependencies for the jenkins package
yum install jenkins -y
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

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
                ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1
                # Run me with superuser privileges
                echo '$username       ALL=(ALL)       ALL' >> /etc/sudoers
                sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
                service sshd restart
        fi
else
        echo "Only root may add a user to the system"
        exit 2
fi