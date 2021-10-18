#!/bin/bash
#Environments Variables
path="/opt"
nexus_name="nexus3"
SSH_Username="nexus"
SSH_Password="nexus@123"
host="0.0.0.0"
port="8081"
#####################################################
#Downloading the nexus setup and doing configurations
#Dependency needs to be installed with Java8 before executing the script 
sudo echo "step1"
sudo apt-get install wget -y
sudo yum install wget -y
#sudo apt-get install openjdk-8-jdk openjdk-8-jre
sudo pushd $path
sudo wget -O nexus3.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz
sudo tar -xzf nexus3.tar.gz
sudo mv nexus-3* $nexus_name
sudo useradd $SSH_Username
sudo echo "$SSH_Username:$SSH_Password" | sudo chpasswd
sudo chown -R $SSH_Username:$SSH_Username $path/nexus*
sudo chown -R $SSH_Username:$SSH_Username $path/sonatype*
sed -i 's/#run_as_user=""/run_as_user="$SSH_Username"/g' $path/$nexus_name/bin/nexus.rc
sed -i 's/2703/512/g' $path/$nexus_name/bin/nexus.vmoptions
########################################################
sudo echo "step2"
sudo touch /etc/systemd/system/nexus.service
sudo echo "[Unit]" >> /etc/systemd/system/nexus.service
sudo echo "Description=nexus service" >> /etc/systemd/system/nexus.service
sudo echo "After=network.target" >> /etc/systemd/system/nexus.service
sudo echo "[Service]" >> /etc/systemd/system/nexus.service
sudo echo "Type=forking" >> /etc/systemd/system/nexus.service
sudo echo "LimitNOFILE=65536" >> /etc/systemd/system/nexus.service
sudo echo "User=nexus" >> /etc/systemd/system/nexus.service
sudo echo "Group=nexus" >> /etc/systemd/system/nexus.service
sudo echo "ExecStart=$path/$nexus_name/bin/nexus start" >> /etc/systemd/system/nexus.service
sudo echo "ExecStop=$path/$nexus_name/bin/nexus stop" >> /etc/systemd/system/nexus.service
sudo echo "User=nexus" >> /etc/systemd/system/nexus.service
sudo echo "Restart=on-abort" >> /etc/systemd/system/nexus.service
sudo echo "[Install]" >> /etc/systemd/system/nexus.service
sudo echo "WantedBy=multi-user.target" >> /etc/systemd/system/nexus.service
#####################################################################
sudo echo "step3"
sudo ln -s $path/$nexus_name/bin/nexus /etc/init.d/nexus
sudo systemctl enable nexus
sudo service nexus start
####################################################################
sudo echo "step4"
sudo sed -i "s/0.0.0.0/$host/g" $path/$nexus_name/etc/nexus-default.properties
sudo sed -i "s/8081/$port/g" $path/$nexus_name/etc/nexus-default.properties
sudo service nexus restart
################################################################################################################
sudo echo "nexus server installation and configuration got completed & will be available on http://$host:$port"
######################################################################################################
