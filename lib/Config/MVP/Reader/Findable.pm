package Config::MVP::Reader::Findable;
use Moose::Role;
# ABSTRACT: a config class that Config::MVP::Reader::Finder can find

use File::Spec;

requires 'default_extension';

sub can_be_found {
  my ($self, $arg) = @_;

  my $config_file = $self->filename_from_args($arg);
  return -r "$config_file" and -f _;
}

sub filename_from_args {
  my ($self, $arg) = @_;

  # XXX: maybe we should detect conflicting cases -- rjbs, 2009-08-18
  my $filename;
  if ($arg->{filename}) {
    $filename = $arg->{filename}
  } else {
    my $basename = $arg->{basename};
    confess "no filename or basename supplied"
      unless defined $arg->{basename} and length $arg->{basename};

    my $extension = $self->default_extension;
    $filename = $basename;
    $filename .= ".$extension" if defined $extension;
  }

  return File::Spec->catfile("$arg->{root}", $filename);
}

no Moose::Role;
1;

