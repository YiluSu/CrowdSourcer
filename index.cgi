#!/usr/bin/perl
use CGI;
use CommandFactory;
use HTMLPresenter;
use strict;
my $cgi = CGI->new();

sub get_action {
    return $cgi->param("action") || $cgi->url_param("action");
}

eval {

    my $command = get_action();

    my $commandObj = ($command) ? CommandFactory::getCommand( $command )
                            : CommandFactory::defaultCommand() ;

    my $params = $cgi->Vars;

    my $result = $commandObj->execute($params);

    my ($content_type, $content) = 
    HTMLPresenter->new( result => $result, 
                        parameters => $params )->present;
    
    print $cgi->header( -type => $content_type );
    
    print $content;
};
if ($@) {
    print $cgi->header( -type => "text/plain" );
    print $@;
}
