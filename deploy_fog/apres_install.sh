###############################################################
#Etape n°3 : mise à jour du dhcp							  #
#Etape n°4 : mise à jour des fichiers de configuration FOG    #
#Etape n°5 : mise à jour de l'utilisateur fog 				  #
#Etape n°6 : rédémarrage des services						  #
#Etape n°7 : Installation phpmyadmin						  #
###############################################################
#Début du script
#Efface l'écran et étape n°3
clear
echo "Mise a jour du dhcp"
sleep 2
cp ./besoin/dhcpd.conf /etc/dhcp/
cp ./besoin/isc-dhcp-server /etc/default/
echo "Appuyez sur entree pour passer a l'etape suivante"
read premierarret
#Efface l'écran et étape n°4
clear
echo "Mise a jour des fichiers de configuration FOG"
sleep 2
cp ./besoin/tasks.confirm.include.php /var/www/fog/management/includes/
cp ./besoin/config.php /var/www/fog/commons/
cp ./besoin/opt/config.php /opt/fog/service/etc/
##service tftp
cp ./besoin/tftpd-hpa /etc/default/
##service mysql
cp ./besoin/my.cnf /etc/mysql/
echo "Appuyez sur entree pour passer a l'etape suivante"
read deuxiemearret
#Efface l'écran et étape n°5
clear
echo "Mise a jour du mot de passe de l'utilisateur fog"
sleep 2
passwd fog
#Efface l'écran et étape n°6
clear
echo "Redemarrage des services"
sleep 2
service tftpd-hpa restart
service isc-dhcp-server restart
service apache2 restart
#Etape n°7
apt-get install phpmyadmin
#raccourcis nécéssaire pour l'affichage du site via apache2
ln -s /usr/share/phpmyadmin /var/www/phpmyadmin
#Suppression dossier inutile
rm -r ./fog_0.32
#Effacement de l'ecran + fin
sleep 2
clear
echo "Fin. FOG est utilisable a l'adresse suivante : http://192.168.1.1/fog"
#Fin du script