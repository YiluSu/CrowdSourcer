package CommandFactory;
use Moose;
use DefaultCommand;
use PostCommand;
use RemoveCommand;
use UpdateCommand;
use ErrorCommand;
use GetCommand;
use ListCommand;

my %commands = (
                "" => sub { DefaultCommand->new() },
                "default" => sub { DefaultCommand->new() },
                "post"   => sub { PostCommand->new() },
                "remove" => sub { RemoveCommand->new() },
                "update" => sub { UpdateCommand->new() },
                "list" => sub { ListCommand->new() },
                "get" => sub { GetCommand->new() },
 
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
