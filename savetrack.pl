#!/usr/bin/perl -w

use HVKAPI;
	use Data::Dumper;
	use utf8;
	use open qw/:std :utf8/;


	my $vk = new HVKAPI(\&captchaCallback);


	
	$login = 'login@example.com'; # vk login email or phone
	$password = 'password'; # vk password
	$number = '1488'; #last 4 digits of mobile number



	my %res = $vk->login($login, $password, $number);
	die("Error #$res{errcode}: $res{errdesc}") if ($res{errcode});
	print "Login successful!\n";
	
	my $vars =  $vk->getSessionVars();
	$id = $vars->{'mid'};
	my $resp = $vk->request('status.get', {'uids'=>$id });

	print Dumper($resp);	

        if (exists $resp->{response}->{audio} && $resp->{response}->{audio}->{owner_id} != $id) {
	$resp = $vk->request('audio.add', {'aid'=>$resp->{response}->{audio}->{aid}, 'oid'=>$resp->{response}->{audio}->{owner_id} });
	print Dumper($resp);	
	print "\nCurrent track added to audio list\n";
	} 
       


sub captchaCallback
{
	my $cvars = shift;
	my $url = $cvars->{captcha_url};
	my $answer;

	print "\nHouston, we have a captcha!\n$url\nAnswer: \n";
	$answer = <>;
	chomp $answer;

	return $answer;
}

