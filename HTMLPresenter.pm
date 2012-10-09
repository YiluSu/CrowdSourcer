package HTMLPresenter;
use Moose;
use HTML::Template;

has 'result' => ( is => 'r' );
has 'params' => ( is => 'r' );

sub present {
    my ($self) = @_;
    my $result = $self->result;
    my $templatename = $result->{name};
    my $templatefile = "html/${templatename}.html";
    my $template = HTML::Template->new( filename => $templatefile );
    $template->param( %$result );
    my $content_type = "text/html" || $result->{content_type};
    my $output = $template->output( );
    return ( $content_type, $output );
}


1;
