package RemoveCommand;
use Moose;
use JSON;
extends 'Command';

sub execute {
    my ($self, $h) = @_;
    my $id = $h->{id} || "";
    if (!$id) {
        return ErrorCommand->new()->execute({error=>"No ID Provided"});
    }
    Database::get_database->remove_task( TaskLite->new( id=>$id) );
    return {
            name => "remove",
            content_type => "application/json",
            id => $id,
            task => encode_json( { message=>"removed", id=>$id } )
           };
}
1;
