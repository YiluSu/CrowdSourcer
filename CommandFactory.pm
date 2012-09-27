package CommandFactory;
use Moose;

my %commands = (
	"" => sub { DefaultCommand->new() },
	"post"   => sub { PostCommand->new() },
	"remove" => sub { RemoveCommand->new() },
	"update" => sub { UpdateCommand->new() },
);

sub defaultCommand {
	return DefaultCommand->new();
}
sub getCommand {
	my ($command,@args) = @_;
	if (exists $commands{$command}) {
		return &{$commands{$command}}(@args);
	}
	return ErrorCommand->new();
}
1;
