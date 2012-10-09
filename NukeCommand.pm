package NukeCommand;
use Moose;
use JSON;
extends 'Command';

my $nukeKey = "judgedredd";

sub execute {
    my ($self, $h) = @_;
    my $key = $h->{key} || "";
    if (!$key) {
        return ErrorCommand->new()->execute({error=>"No Key Provided"});
    }
    if ($key eq $nukeKey) {
        Database::nuke();
        return { name => "nuke" };
    }
    return ErrorCommand->new()->execute({error=>"Wrong Nuke Key Provided"});
}
1;
