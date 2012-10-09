package PostCommand;
use Moose;
extends 'Command';
use JSON;

sub execute {
    my ($self, $h) = @_;
    my $summary = $h->{summary} || "";
    my $description = $h->{description} || "";
    my $content = {};
    eval {
        if ( $h->{content} ) {
            $content = decode_json($h->{ content} );
        }
    };
    if ($@) {
        warn $@;
    }
    my $task = Database::get_database()->insert_task( Task->new( summary => $summary, description => $description, content => $content ) );
    return {
            name => 'post',
            content_type => 'application/json',
            task => encode_json( $task->hashify )
           };
}

1;
