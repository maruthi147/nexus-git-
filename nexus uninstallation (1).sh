#!/bin/bash
#Environments Variables
path="/opt"
nexus_name="nexus3"
SSH_Username="nexus"
#####################################################
sudo service nexus stop
sudo service nexus disable
sudo rm -rf /etc/systemd/system/nexus.service
sudo rm -rf /etc/init.d/nexus
sudo rm -rf $path/$nexus_name/bin/nexus
sudo rm -rf $path/$nexus_name
sudo rm -rf $path/sonatype*
sudo rm -rf $path/nexus3.tar.gz
sudo userdel -r $SSH_Username
