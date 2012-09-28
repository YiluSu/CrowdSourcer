package ErrorCommand;
use Moose;
extends 'Command';

sub execute {
	my ($self) = @_;
	return { name => 'error' };
}

1;
