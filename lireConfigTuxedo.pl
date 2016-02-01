#!/usr/bin/perl
#Contenu confidentiel masque avec plusieurs *

#MAIN
use Getopt::Std;
getopts('hp:g:n:');

#variable globale
my $grptux=();
my @nom_grptux=();
my $nom_processus=();
my $plateforme=();

detection(); #fonction

#Affichage de l'aide lors de l'option -h
if ($opt_h eq 1)
{
print "
Ce script permet de decouvrir le ou les groupes tuxedos pour un processus, via son parametre attribue (-p ou -n)
Ou alors, il peut aussi permettre un ensemble de processus pour un groupe tuxedo.

Exemple d'utilisation
lireconfigtux.pl -p <pid d'un processus>
lireconfigtux.pl -n <nom d'un processus>
lireconfigtux.pl -g <nom d'un groupe tuxedo>
";
exit ();
}


#Cette boucle verifie que l'utilisateur a bien precise un parametre
if ($opt_p eq '' && $opt_n eq '' && $opt_g eq '')
{
print "Veuillez utiliser un parametre (lireConfigTuxedo -h pour plus d'aide)"
}
else
{
	#Pour l'option -p, on s'assure que l'utilisateur a bien rentrÃ©e un PID
	if ($opt_p=~m/[a-z]/i)
	{
	print "Valeur non correcte pour l'option -p";
	exit ();
	}

		if ($opt_p ne '')
		{
		my $sed_condition = q{s/ \+/ /g};
		my $regex=q{/traces/cache/bin/};
		$nom_processus= `ps -Fp $opt_p --no-heading| sed '$sed_condition' | cut -d ' ' -f '11'`;
		$nom_processus=~s/$regex//g;
		chomp $nom_processus;
		nom_grptuxedo();
		}

			if ($opt_n ne '')
			{
			$nom_processus=$opt_n;
			chomp $nom_processus;
			nom_grptuxedo();
			}

				if ($opt_g ne '')
				{
				$grptux=$opt_g;
				chomp $grptux;
				liste_process_grptuxedo();
				}
}

#Fonctions
	#La fonction "detection" vÃ©rifie via une variable d'environnement sur quel plateforme nous sommes.
	#Cette fonction servira pour detecter et utiliser le bon fichier ubbconfig de Tuxedo
	sub detection
	{
$plateforme="$ENV{FONCTION}";
		if ($plateforme=~m/****/)
			{
			$plateforme="************";
			}
		if ($plateforme=~m/******/)
			{
			$plateforme="**********************";
			}
	}

		sub suppr_doublons (@) {
my %vu = ();
grep { not $vu{$_}++ } @_;
	}
	#Cette fonction rÃ©cupere les groupes tuxedos concernÃ©es par les processus demandÃ©s en paramÃ¨tres. (-p ou -n)
	sub nom_grptuxedo
	{
#Ouverture du fichier ubbconfig de tuxedo
my $repetoire_ubbtuxedo="/*******/tuxedo/ubbconfig.$plateforme";
open FILE, "$repetoire_ubbtuxedo";
my @fichier_tuxedo_ubbconfig=<FILE>;
close FILE;
		#Recherche des processus concernÃ©s dans ce fichier
		for ( my $i="0"; $i<@fichier_tuxedo_ubbconfig; $i++)
		{
			if ($fichier_tuxedo_ubbconfig[$i]=~m/^$nom_processus\t/ && $fichier_tuxedo_ubbconfig[$i]=~ m/***/ )
			{
			$nom_grptux[$i]="$fichier_tuxedo_ubbconfig[$i]";
			$nom_grptux[$i]=~s/\n//g;
			$nom_grptux[$i]=~s/\t//g;
			$nom_grptux[$i]=~s/ +/ /g;
			$nom_grptux[$i]=~s/^$nom_processus//g;
			$nom_grptux[$i]=~s/***=//g;
			}
			if ($fichier_tuxedo_ubbconfig[$i]=~m/^$nom_processus / && $fichier_tuxedo_ubbconfig[$i]=~ m/***/ )
			{
			$nom_grptux[$i]="$fichier_tuxedo_ubbconfig[$i]";
			$nom_grptux[$i]=~s/\n//g;
			$nom_grptux[$i]=~s/\t//g;
			$nom_grptux[$i]=~s/ +/ /g;
			$nom_grptux[$i]=~s/^$nom_processus//g;
			$nom_grptux[$i]=~s/***=//g;
			$nom_grptux[$i]=~s/^ //g;
			}
		}
		#Le resultat des recherches sera fourni sans doublons et afficher Ã  l'Ã©cran
@nom_grptux= suppr_doublons @nom_grptux;
			if (@nom_grptux ne 0)
			{
				foreach my $ligne (@nom_grptux)
				{
					if ($ligne ne '')
					{
					print "$ligne\n";
					}
				}
			}
			else
			{
			print "Pas de groupe tuxedo concernee par cette demande";
			exit ();
			}
	}

		sub liste_process_grptuxedo #Cette fonction a pour objectif de recuperer la liste des processus pour chaque groupe tuxedo
	{
my $repetoire_ubbtuxedo="/*******/tuxedo/ubbconfig.$plateforme";
open FILE, "$repetoire_ubbtuxedo";
my @fichier_tuxedo_ubbconfig=<FILE>;
close FILE;
		for ( my $i="0"; $i<@fichier_tuxedo_ubbconfig; $i++)
		{
			if ($fichier_tuxedo_ubbconfig[$i]=~ m/***=$grptux\n/ )
			{
			$liste[$i]=$fichier_tuxedo_ubbconfig[$i];
			}
		}
		print @liste;
		if (@liste eq 0)
		{
		print "Ce groupe tuxedo n'existe pas";
		}
	}
