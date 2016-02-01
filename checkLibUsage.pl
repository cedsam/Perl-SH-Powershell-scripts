#!/usr/bin/perl
#Certains contenus ont ete masque avant la publication sur github, permettant de respecter la confidentialite demande par l entreprise.
#Version 1
#Realise par SAMARDZIJA Cedric
#Un grand merci a Pascal D, Jordan Q, Pierre D, pour leurs aides m'ayant permis d'avancer et d'apprendre beaucoup plus rapidement

#Contenu confidentiel masque avec plusieurs *

use POSIX qw(strftime);#Ce module me permet d'utiliser le peripherique materiel ayant l'heure (timer)
use Getopt::Std;#Ce module permet d'analyser la ligne de commande qui execute le script, afin d'en determiner les parametres ainsi que leurs valeurs.

#MAIN
#START

#On declare les parametres. Les lettres accompagnes d'un ":" sont des parametres contenant une donnee (le nom d'une bibliotheque par exemple) saisie par l'utilisateur.
#Les lettres sans signe devant sont des parametres contenant uniquement des booleens (soit 0 soit 1).
#$opt_b $opt_v $opt_h $opt_m: Ces variables non declarees mais sont utilises par Getopt::Std.
getopts('m:vhb:');

#Decalaration des variables globales
my @machine_ssh=();
my $variable_masquee=();
my $os=();
my $extension_biblio=();
my @liste_machines=();
my $repertoire_bibliotheque="*****************";
my $repertoire_utilisateur="********************";
my @liste_bibliotheque=();
my $date_jour = strftime "%d%m%Y", localtime;
my $fichier_csv="carto_bibl_$date_jour.csv";

#Execution des fonctions ne necessitant pas de plusieurs machines
initialisation();
detection();
inventaire_bibliotheque();

#Execution des fonctions multi-machines
foreach my $machine (@machine_ssh)
{
	my $machine_courante=();
	my @tableau_bibliotheque=();
	my $nombre_bibtrouve=();
	my @pid=();
	my @tableau_processus=();
	my $nombre_proctrouve=();
	my @tableau_tuxedo=();
	my $nombre_tuxtrouve=();
	my $nombre_lignetableau=();
	if ($os eq 'Linux')
	{
		recup_info($machine);
		nom_bibliotheque();
		nom_processus($machine);
	}
	else
	{
		traitement_aix($machine);
	}
	nom_grptuxedo($machine);
	resultat_final($machine);
}


#on vide les variables globales
undef @machine_ssh;
undef $variable_masquee;
undef $os;
undef $extension_biblio;
undef @liste_machines;
undef $repertoire_bibliotheque;
undef $repertoire_utilisateur;
undef @liste_bibliotheque;
undef $date_jour;
undef $fichier_csv;

#MAIN
#END

#Definition des fonctions
sub suppr_doublons (@)
{
	my %vu = ();
	grep { not $vu{$_}++ } @_;
}

sub erreur
{
	print "Un probleme d'integrite de donnee a ete rencontre\nVoir page de l'outil cartoLib sur le wiki pour plus d'information (La boite a outils > Outil cartoLib)\n\nVous pouvez aussi relancer le script, l'erreur etant temporaire";
	exit();
}

sub initialisation
{
	#Indication de l'emplacement fichier csv (absence de -v)
	if ($opt_v eq '' && $opt_h eq '')
	{
		print "Le fichier portera le nom $fichier_csv\n";
		print "Le fichier sera disponible ici : $repertoire_utilisateur";
	}
	#Machine concernee par l'execution du script (-m)
	if ($opt_m eq '' && $opt_h eq '')
	{
		@machine_ssh=split / /, $ENV{VAR_MASQUEE}; #masquee pour des raisons de confidentialite
	}
	else
	{
		@machine_ssh=split /,/, $opt_m;
	}

	#Parametre -h : si celui ci est actif, on affiche l'aide (a refaire)pour l'utilisateur et le script se ferme
	if ($opt_h eq 1)
	{
		print "Par defaut, le comportement du script cartoLib va rechercher sur toutes les machines l'ensemble des processus utilisant les bibliotheques du dossier libd (present dans /**********) et le resultat est enregistre dans un fichier csv.\n\nUsage : cartoLib [-b <nom de la bibliotheque] [-v pour un affichage a l'ecran] [-m choix des machines]\n\nExemple d'utilisation :**********************************************************";
		exit();
	}
}

#Cette fonction est chargee de nous recuperer des informations systemes ainsi que des informations propres a ***** pour le fonctionnement du script.
#1) On recupere le nom de l'OS installee sur la machine
#2) On definit l'extension de la bibliotheque (linux = .so; aix = .a)
#3) On definit la liste des machines disponibles pour l'instance *****
sub detection
{
	$variable_masquee="$ENV{VAR_MASQUEE}";#masquee pour des raisons de confidentialite
	########################################
	$os=`uname -s`;
	chomp ($os);
	if ($os eq 'Linux')
	{
		$extension_biblio=q{*.so};
	}
	else
	{
		$extension_biblio=q{*.a};
	}
	######################################
	if ($variable_masquee=~m/*************/)
	{
		$variable_masquee="*****************";
	}
	if ($variable_masquee=~m/*******************/)
	{
		$variable_masquee="*********************";
	}
	#######################################
	@liste_machines=split (" ", $ENV{*******************});
	foreach my $lignes (@liste_machines)
	{
		chomp $lignes;
	}
}

#Cette fonction permet de :
#1) Detecter l'ensemble des bibliotheque presente sur la machine
#2) Verifier l'existance de la bibliotheque demande par l'utilisateur
#3) Placer le script dans un environnement non risque
sub inventaire_bibliotheque
{
	#1)
	chdir ($repertoire_bibliotheque) or die "Le script n'a pas reussi a consulter les bibliotheques presentes sur la machine ! ($repertoire_bibliotheque inaccessible)";

	if ($opt_b eq '')
	{
		@liste_bibliotheque=glob"$extension_biblio";
	}
	else
	{
		#2)
		if (-e "$repertoire_bibliotheque/$opt_b")
		{
			@liste_bibliotheque=$opt_b;
		}
		else
		{
			die "Bibliotheque demandee non existante (nom invalide)\n";
		}
	}
	#3)
	chdir ($repertoire_utilisateur) or die "Le script s'arrete car il n'a pas reussi a se placer dans le dossier ($repertoire_utilisateur).\nCet arret est necessaire (eviter comportement type: modification de fichier...)";
}

#Cette fonction, compatible uniquement GNU\Linux, est chargee de recuperer les informations necessaires a la realisation du resultat final
#Pour chaque bibliotheque, on recupere les processus utilisateurs de ces bibliotheques
sub recup_info
{
	#information ssh
	my $ssh_id=$_[0]; #nom de la machine: exemple ************
	$machine_courante="$ssh_id";
	chomp $machine_courante;
	$machine_courante=uc($machine_courante);

	my $contenu_tab_bib=();
	my $contenu_tab_pid=();
	foreach my $ligne (@liste_bibliotheque)
	{
		my $sed_condition = q{s/ \+/ /g};
		#Premiere commande permettant de detecter les bibliotheques utilisees
		my $cmd_pid=`ssh -q $ssh_id "/usr/sbin/lsof +c15 | grep $repertoire_bibliotheque/$ligne | sed '$sed_condition'| cut -d ' ' -f '2'"`;
		if ($cmd_pid ne '')
		{
			$contenu_tab_pid="$contenu_tab_pid $cmd_pid";
		}

		#Deuxieme commande permettant d'enrichir les informations des processus utilisateurs de ces bibliotheques
		my $cmd_bib=`ssh -q $ssh_id "/usr/sbin/lsof -Fn |  grep $repertoire_bibliotheque/$ligne | cut -d ' ' -f '1'"`;
		if ($cmd_bib ne '')
		{
			$contenu_tab_bib="$contenu_tab_bib $cmd_bib";
		}
	}
	@tableau_bibliotheque=split "\n", $contenu_tab_bib;
	@pid=split "\n", $contenu_tab_pid;

	#Test d'integrite
	my $nombre_tabbib=@tableau_bibliotheque;
	my $nombre_pid=@pid;
	if ($nombre_tabbib ne $nombre_pid)
	{
		erreur();
	}
}

#Cette fonction a pour objectif de rendre le resultat plus clair (concerne les bibliotheques utilisees).
sub nom_bibliotheque
{
	foreach my $ligne (@tableau_bibliotheque)
	{
		 #on supprime une information inutile (le repertoire ou est situe la biblio) dans nos resultats
		my $filtre="n/**********/libd/";
		$ligne=~s/$filtre//g;
		$ligne=~s/^ //g;
		chomp $ligne;
	}
}

#Cette fonction a pour objectif de recuperer le nom des processus complet via leur "PID".
sub nom_processus
{

	#Information SSH
	my $ssh_id=$_[0];
	my $resultat=();
	my $nombre_nomprocess=();
	my $nombre_pid=@pid;
	foreach my $ligne (@pid)
	{
		my $sed_condition = q{s/ \+/ /g};
		#Commande shell permettant de trouver le nom complet processus
		my $shell = `ssh -q $ssh_id "ps -Fp $ligne --no-heading| sed '$sed_condition' | cut -d ' ' -f '11'"`;
		my $filtre="/traces/cache/bin/";
		$shell=~s/$filtre//g;
		#Enregistrement du shell dans une variable
		if ($shell ne '')
		{
			$resultat="$resultat $shell";
		}
	}
	#Integration du resultat dans un tableau
	@tableau_processus=split "\n", $resultat;
	foreach my $ligne (@tableau_processus)
	{
		#Certains des resultats contiennent des retours a la ligne et des espaces en debut de ligne, ce qui peut etre nefaste lors de l'utilisation
		chomp $ligne;
		$ligne=~s/^ //g;
	}

	#Test d'integrite
	$nombre_proctrouve=@tableau_processus;
	if ($nombre_proctrouve ne $nombre_pid)
	{
		erreur();
	}
}

#Cette fonction recupere la liste complete des bibliotheques utilise et leur processus rattache et fonctionne que pour AIX
sub traitement_aix
{
	my $ssh_id=$_[0];
	foreach my $ligne (@liste_bibliotheque)
	{
		my @nom_proclib_tmp=`ssh -q $ssh_id "genld -l|egrep 'Proc_name|$repertoire_bibliotheque/$ligne'"`;
			#################################################################################
		#On trie l'information delivree par genld
		my @nom_proclib=();
		#Dans cette premiere boucle on defini les fins de lignes avec un ;, afin de recuperer le processus et la bibliotheque utilise
		#Cela sera utile pour enlever le superflu
		for ( my $i="0"; $i<@nom_proclib_tmp; $i++)
		{
			if ($nom_proclib_tmp[$i]=~m/$ligne/)
			{
				my $ligne_processus=$i - 1;
				chomp ($nom_proclib_tmp[$i]);
				chomp ($nom_proclib_tmp[$ligne_processus]);
				$nom_proclib_tmp[$i]=~s/\t//g;
				$nom_proclib_tmp[$i]=~s/ +/;/g;
				$nom_proclib_tmp[$i]=~s/^;//g;
				$nom_proclib_tmp[$ligne_processus]=~s/ +/;/g;
				$nom_proclib[$i]="$nom_proclib_tmp[$ligne_processus];$nom_proclib_tmp[$i]";
			}
		}
				#Ici, on met dans un tableau l'ensemble de nos valeurs
		for ( my $i="0"; $i<@nom_proclib; $i++)
		{
			my @champ = split /;/, $nom_proclib[$i];
			$tableau_processus[$i]="$champ[3]";
			$tableau_bibliotheque[$i]="$champ[6]";
			my $perl_condition="*******************************************";
			$tableau_bibliotheque[$i]=~s/$perl_condition//g;
			$tableau_bibliotheque[$i]=~s/\[.+//g;
		}
	}
		#Suppression des doublons avec grep
		@tableau_processus = grep { $_ ne '' } @tableau_processus;
		@tableau_bibliotheque = grep { $_ ne '' } @tableau_bibliotheque;

		#Test d'integrite
		$nombre_bibtrouve=@tableau_bibliotheque;
		$nombre_proctrouve=@tableau_processus;
		if ($nombre_bibtrouve ne $nombre_proctrouve)
		{
			erreur();
		}
}

 #Cette fonction a pour objectif de recuperer le nom des groupes tuxedos rattaches au processus concerne par ce script.
	#1) On ouvre le bon fichier ubbconfig
	#2) On fait nos recherches directement dans ce fichier
	#3) On inscrit les valeurs trouvees dans un tableau
	#4) On s assure que la recherche porte sur les bonnes machines (par exemple si nous somme sur ***************, il s agira du groupe tuxedo associe a ***************************.)
sub nom_grptuxedo
{
	undef @tableau_tuxedo;
	#Ouverture du fichier ubbconfig et enregistrement dans une variable tableau
	my $repetoire_ubbtuxedo="/**************************/tuxedo/ubbconfig.$variable_masquee";
	open FILE, "$repetoire_ubbtuxedo" or die "Impossible d'ouvrir le fichier ubbconfig.$variable_masquee";
	my @fichier_tuxedo_ubbconfig=<FILE>;
	close FILE;
	for ( my $i2="0"; $i2<@tableau_processus; $i2++)
	{
	$tableau_tuxedo[$i2]="Aucun groupe tuxedo";
		for ( my $i="0"; $i<@fichier_tuxedo_ubbconfig; $i++)
		{
			if ($fichier_tuxedo_ubbconfig[$i]=~m/^$tableau_processus[$i2]\t/ && $fichier_tuxedo_ubbconfig[$i]=~ m/***********************/) #Dans le fichier tuxedo ubbconfig, ****************************************************.
			{
				$tableau_tuxedo[$i2]="$fichier_tuxedo_ubbconfig[$i]";
				$tableau_tuxedo[$i2]=~s/\n//g;
				$tableau_tuxedo[$i2]=~s/\t//g;
				$tableau_tuxedo[$i2]=~s/ +/ /g;
				$tableau_tuxedo[$i2]=~s/^$tableau_processus[$i2]//g;
				$tableau_tuxedo[$i2]=~s/*****=//g;
			}
			else
			{
				if ($fichier_tuxedo_ubbconfig[$i]=~m/^$tableau_processus[$i2] / && $fichier_tuxedo_ubbconfig[$i]=~ m/*****************************/ ) #Dans le fichier tuxedo ubbconfig, ****************************************************.
				{
					$tableau_tuxedo[$i2]="$fichier_tuxedo_ubbconfig[$i]";
					$tableau_tuxedo[$i2]=~s/\n//g;
					$tableau_tuxedo[$i2]=~s/\t//g;
					$tableau_tuxedo[$i2]=~s/ +/ /g;
					$tableau_tuxedo[$i2]=~s/^$tableau_processus[$i2]//g;
					$tableau_tuxedo[$i2]=~s/*****=//g;
					$tableau_tuxedo[$i2]=~s/^ //g;
				}
			}

		}
	}
##################################################################################
	foreach my $ligne (@tableau_tuxedo)
	{
	my $ssh_id=$_[0];
	$machine_courante="$ssh_id";
	chomp $machine_courante;
	$machine_courante=uc($machine_courante);
		for ( my $i="0"; $i<@liste_machines; $i++)
		{
			if ($ligne=~m/$liste_machines[$i]/)
			{
				$ligne=~s/$liste_machines[$i]/$machine_courante/g;
			}
		}
	}
	$nombre_tuxtrouve=@tableau_tuxedo;
	if ($nombre_proctrouve ne $nombre_tuxtrouve)
	{
		erreur();
	}
	else
	{
		$nombre_lignetableau=$nombre_tuxtrouve;
	}
}

#Cette fonction a pour but de regrouper l'ensemble des informations recoltees et traitees dans un tableau.
sub resultat_final
	{
	#on supprime le fichier precedent
	unlink $fichier_csv;
	#Information SSH
	my $ssh_id=$_[0];
	my $nom_machine="$ssh_id";
	chomp $nom_machine;
	$nom_machine=uc($nom_machine);

	my @resultats=();
	for ( my $i="0"; $i<$nombre_lignetableau; $i++)
	{
		$resultats[$i]="$tableau_processus[$i];$tableau_tuxedo[$i];$tableau_bibliotheque[$i]\n"; #ces informations sont inscrites dans le tableau final nomme resultat.
	}

	@resultats= suppr_doublons @resultats;

	if ($opt_v eq '')
	{
		#creation fichier csv
		chdir ($repertoire_utilisateur);
		open (my $creation_csv, ">>", "$fichier_csv");
		print $creation_csv("$ENV{**************************}_$nom_machine");
		print $creation_csv("\n\n");
		print $creation_csv("Processus;Groupe Tuxedo;Bibliotheque\n");
		print $creation_csv(@resultats);
		print $creation_csv("\n\n\n");
		close $creation_csv;
	}
	else
	{
		#affichage ecran
		print "$ENV{******************}_$nom_machine";
		print ("\n\n");
		print ("Processus;Groupe Tuxedo;Bibliotheque\n");
		print @resultats;
		print ("\n\n\n");
	}
	undef @tableau_bibliotheque;
	undef @pid;
	undef @tableau_processus;
}
