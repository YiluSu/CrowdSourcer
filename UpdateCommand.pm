package UpdateCommand;
use Moose;
use ErrorCommand;
extends 'Command';

sub execute {
    my ($self, $h) = @_;
    my $summary = $h->{summary} || "";
    my $id = $h->{id} || "";
    my $description = $h->{description} || "";
    my $content = {};
    eval {
        if ( $h->{content} ) {
            $content = decode_json($h->{ content} );
        }
    };
    if ($@) {
        return ErrorCommand->new()->execute({error=>"Decode Error: $@"});
    }
    if (!$id) {
        return ErrorCommand->new()->execute({error=>"Missing ID Error"});
    }
    my $task = Database::get_database()->update_task( Task->new( id => $id, summary => $summary, description => $description, content => $content ) );
    return {
            name => 'update',
            content_type => 'application/json',
            task => encode_json( $task->hashify )
           };
}

1;


1;
