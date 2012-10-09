package ListCommand;
use Moose;
use Database;
extends 'Command';
use JSON;


sub execute {
    my ($self, $h) = @_;
    $h = $h || {};
    my $n = $h->{n} || undef;
    my $db = Database::get_database();
    my @entries = $db->get_task_summaries( $n );
    my @summaries = map { $_->hashify } @entries;
    return {
            name => 'list',
            content_type => 'application/json',
            tasks => encode_json( \@summaries )
    };
}

1;
