package Foo::BoondleNestedAsm;

sub mvp_bundle_config {
  my ($self, $params) = @_;

  my $asm = $params->{assembler};

  my $foo_bar = $asm->sequence->section_named('Foo::Bar');

  return (
    [ 'boondle_1', 'Foo::Boo1', [ x => $foo_bar->payload->{x} ] ],
    [ 'boondle_2', 'Foo::Boo2', [ a => 0 ] ],
    [ 'boondle_B', 'Foo::Bar',  [ z => $foo_bar->payload->{z} ] ],
  );
}

1;
