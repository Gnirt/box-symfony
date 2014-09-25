
Remove NFS in that case in VagrantFile
After that create "nouveau lecteur réseau" by clicking right on Computer. Add \\192.168.100.10\shared as the server log/password are vagrant/vagrant

# Installing Samba
SAMBA_USER="vagrant"
SAMBA_PASSWORD="vagrant"
apt-get install -y samba
service smbd stop
# Configure Samba
rm -rf /etc/samba/smb.conf
cp /vagrant/.configs/samba/smb.conf.dist /etc/samba/smb.conf
service smbd start
# Configure user
echo -ne "$SAMBA_PASSWORD\n$SAMBA_PASSWORD\n" | smbpasswd -L -a $SAMBA_USER
smbpasswd -L -e $SAMBA_USER

# Finally, give all rights
chmod 777 -R /var/www
chown -R $SAMBA_USER:$SAMBA_USER
# Setting apache2 user and group to samba user
sed "s#export APACHE_RUN_USER=.*#export APACHE_RUN_USER=$SAMBA_USER#g" /etc/apache2/envvars > /etc/apache2/envvars.tmp
mv /etc/apache2/envvars.tmp /etc/apache2/envvars
sed "s#export APACHE_RUN_GROUP=.*#export APACHE_RUN_GROUP=$SAMBA_USER#g" /etc/apache2/envvars > /etc/apache2/envvars.tmp
mv /etc/apache2/envvars.tmp /etc/apache2/envvars