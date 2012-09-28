package ListCommand;
use Moose;
extends 'Command';

sub execute {
	my ($self) = @_;
	return { name => 'list' };
}

1;
