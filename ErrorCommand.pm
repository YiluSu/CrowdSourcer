package ErrorCommand;
use Moose;
extends 'Command';

sub execute {
    my ($self, $h) = @_;
    my $out = { name => 'error' };
    if ($h && $h->{error}) {
        $out->{error} = $h->{error};
    }
    return $out;
}

1;
