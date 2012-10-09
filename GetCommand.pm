package GetCommand;
use Moose;
use Database;
use ErrorCommand;
extends 'Command';
use JSON;

sub execute {
    my ($self, $h) = @_;
    $h = $h || {};
    my $id = $h->{id} || undef;
    if (!$id) {
        return ErrorCommand->new()->execute( error => "No ID!");
    }
    my $db = Database::get_database();

    my $task = $db->get_single_task( $id );
    return {
            name => 'get',
            content_type => 'application/json',
            task => encode_json( $task->hashify )
    };
}

1;
