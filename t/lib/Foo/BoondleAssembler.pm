package Foo::BoondleAssembler;

sub mvp_bundle_config {
  my ($self, $params) = @_;

  my $asm = $params->{assembler};

  my $foo_quux = $asm->sequence->section_named('Foo::Quux');

  return (
    [ 'boondle_X', 'Foo::BoondleNestedAsm', { } ],
    [ 'boondle_3', 'Foo::Boo1', [ a => $foo_quux->payload->{a} ] ],
    [ 'boondle_4', 'Foo::Boo2', [ b => $foo_quux->payload->{b} ] ],
    [ 'boondle_C', 'Foo::Bar',  [ y => 4, y => 5, y => 6 ] ],
  );
}

1;
