#!/usr/bin/perl -w

use strict;
use warnings;

use vars qw/ %opt /;
use Getopt::Std;
use File::Basename;

exit(&main);

sub main {
    my $opts = 'hiorsd:f:p:';
    my @msg;
    my $match = '(^|CSeq:\s?\d+\s+)';
    my $iface = "any";
    my $ip = "";
    my $filter = "udp and port 5060";
    my $ngrep_args = "-iqt -W byline";

    getopts("$opts", \%opt) or &usage();
    &usage() if ($opt{h} or !keys(%opt));
    push(@msg, "REGISTER") if $opt{r};
    push(@msg, "SUBSCRIBE", "PUBLISH", "NOTIFY") if $opt{s};
    push(@msg, "INVITE", "ACK", "CANCEL", "BYE", "MESSAGE", "REFER", "PRACK", "INFO", "UPDATE") if $opt{i};
    push (@msg, "OPTIONS", "PING") if $opt{o};
    $iface = $opt{d} if $opt{d};
    $ip = "and host " .$opt{p} if $opt{p};
    $filter = $opt{f} if $opt{f};

    $filter = "$filter $ip";
    $match .= "(" .join("|", @msg). ")";
    $ngrep_args .= " -d $iface '$match' $filter";
    exec "stdbuf -oL ngrep $ngrep_args";
}

sub usage {
    my $prog = basename($0);

    print STDERR << "EOF";

USAGE

$prog [ -hiosr ] [ -d interface ] [ -f filter] [ -p ip_address ]

    -h  : this (help) text
    -r  : show REGISTER messages
    -s  : show presence related messages (PUBLISH, SUBSCRIBE, NOTIFY)
    -i  : show sip call related messages (INVITE, ACK, CANCEL, BYE, REFER, INFO...)
    -o  : show keep-alive messages (OPTIONS, PING)
    -d  : network interface for ngrep (default: any)
    -f  : ngrep filter expression (default: udp and port 5060)
    -p  : ip address to filter (added to -f arg)

NOTES

It is possible to combine multiple matches.

EOF
    exit(-1);
}

