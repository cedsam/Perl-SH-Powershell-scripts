#Description : Bibliotheque contenant des fonctions tres basique que j'ai utilise
#tout au long de mon annee d alternance

#Nom bibliotheque
package Basique;

#Controle
use strict;
use warnings;
use diagnostics;

#Vous avez des doublons dans votre variable hash/tableau?
#Cette fonction permet de les supprimer
#Appel de la fonction: Basique::suppr_doublons(@nom_variable)
#Appel de la fonction: Basique::suppr_doublons(%nom_variable)
sub suppr_doublons (@) 
{
	my %correction=();
	grep { not $correction{$_}++ } @_;
}

#PROBLEME SOUS AIX
#Lorsque vous utilisez la commande PS avec un critere de recherche a l'aide de la commande grep
#Le processus grep apparait dans la liste des processus via PS.
#------------------> ps -ef | grep critere
#Si vous souhaitez que celui-ci disparaisse, il vous suffit de mettre la premiere lettre du critere entre crochet
#------------------> ps -ef | grep [c]ritere
#Cette fonction vous permet de le faire.
sub crochet(@)
{
	my ($mot)=@_;
	my $lettre=substr $mot, 0,1;
	$mot=~s/^$lettre/\[$lettre\]/;
	return $mot;
	undef $mot, $lettre;
}

#Ceci est la valeur de retour apres l'execution de la bibliotheque.
#Permet a Perl de determiner si la bibliotheque s'est lancee correctement.
1;