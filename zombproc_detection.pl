#!/usr/bin/perl
#Contenu confidentiel masque avec plusieurs *

use Diagnostic;
init_diagnostic();
trame_ihmv6();

sub init_diagnostic
{
	Diagnostic::init("Processus zombie", "0.1"); #Version 0.1
	Diagnostic::addDetail(Diagnostic::getTest());
	return 0;
}

sub suppr_doublons (@)
{
	my %vu = ();
	grep { not $vu{$_}++ } @_;
}

sub surveillance_proczomb
{
	#liste des machines (variable environnement)
	my $nb_proc_zombie=0;
	my @liste_proc_zombie=();

	my $liste_machine="$ENV{***************************}";
	chomp $liste_machine;
	$liste_machine=lc $liste_machine;
	my @machine_ssh=split / /, $liste_machine;


	foreach my $machine (@machine_ssh)
	{
		#requete ssh (p. zombie)
		my $condition_sed=q{s/ \+/ /g};
		my @resultat_ssh=`ssh -q $machine "ps -ef | grep [d]efunct | sed '$condition_sed' | cut -d ' ' -f '3'"`;
		#calcul nombre de process zombie
		if (@resultat_ssh != 0)
		{
			my @ppid_zombie=@resultat_ssh;
			@ppid_zombie=suppr_doublons (@ppid_zombie);
			foreach my $ligne (@ppid_zombie)
			{
				foreach my $processus (@resultat_ssh)
				{
					chop $processus;
					my $nombre_occurence=0;
					my $nom_ppid=`ssh -q $machine "ps -p $processus | grep $processus | sed '$condition_sed' | cut -d ' ' -f '4'"`;
					chop $nom_ppid;
					$nb_proc_zombie++;
					$nombre_occurence++;
					push @liste_proc_zombie, "Le processus $nom_ppid genere $nombre_occurence processus zombie.";
				}
			}
		}
	}
	return $nb_proc_zombie, @liste_proc_zombie;
	undef $nb_proc_zombie, @machine_ssh, $liste_machine, @liste_proc_zombie;
}

sub trame_ihmv6
{
	my ($nb_proc_zombie, @zombie)=surveillance_proczomb();
	if ($nb_proc_zombie != 0)
	{
		Diagnostic::setHeader("Informations");
		Diagnostic::addDetail("Nombre processus zombies : $nb_proc_zombie\n");
		foreach my $ligne (@zombie)
		{
			Diagnostic::addBody("$ligne");
			Diagnostic::setCodeRetour("KO");
			Diagnostic::setFormatCSV();
			Diagnostic::terminate();
		}
	}
	else
	{
		Diagnostic::setCodeRetour("OK");
		Diagnostic::terminate();
	}
	undef $nb_proc_zombie, @zombie;
	return 0;
}
