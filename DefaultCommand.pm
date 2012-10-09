package DefaultCommand;
use Moose;
extends 'Command';

sub execute {
    my ($self) = @_;
    return { name => 'default' }
}

1;
