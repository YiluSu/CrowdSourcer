package HTMLPresenter;
use Moose;
use HTML::Template;

has 'result' => (is => 'rw');
has 'params' => (is => 'rw');

sub present {
    my ($self) = @_;
    my $result = $self->result;
    my $templatename = $result->{name};
    my $templatefile = "html/${templatename}.html";
    my $template = HTML::Template->new( filename => $templatefile, die_on_bad_params => 0 );
    $template->param( %$result );
    my $content_type = $result->{content_type} || "text/html" ;
    my $output = $template->output( );
    return ( $content_type, $output );
}


1;
