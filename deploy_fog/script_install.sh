##################################
#Etape n°1 : config~ des dépots  #
#Etape n°2 : installation de FOG #
##################################
#Début du script
#Efface l'écran et étape n°1
clear
echo "Mise a jour des depots"
sleep 2
cp besoin/sources.list /etc/apt/
echo "Appuyez sur entrée pour passer à l'etape suivante"
read deuxiemearret
#Nettoyage de l'écran et étape n°2
clear
echo "Extraction des fichiers d'installation FOG..."
sleep 2
cp besoin/fog_0.32.tar.gz .
tar -xvf fog_0.32.tar.gz 
sleep 2
#Efface l'écran, indication du status de l'extraction
clear
echo "Extraction des fichiers d'installation FOG: OK"
sleep 2
#Efface l'écran et j'informe l'utilisateur des etapes suivantes
clear
echo "lancer les commandes suivantes s.v.p :\ncd ./fog_0.32/bin\nsh installfog.sh"
sleep 2
#Fin du script