package YAML::Diff::Command;
use Mo;

has args => ();

use File::Temp;
use YAML::XS;

sub run {
    my ($self) = @_;

    my $args = $self->args;
    @$args == 2 or die 'Command requires 2 YAML file paths';

    my ($file1, $file2) = @$args;

    my $yaml1 = YAML::XS::Dump(YAML::XS::LoadFile($file1));
    my $yaml2 = YAML::XS::Dump(YAML::XS::LoadFile($file2));

    if ($yaml1 eq $yaml2) {
        print "Matched\n";
    }
    else {
        (my $tmp1 = $file1) =~ s!.*/!!;
        (my $tmp2 = $file2) =~ s!.*/!!;
        $tmp1 = File::Temp->new( TEMPLATE => "${tmp1}_XXXXX" );
        $tmp2 = File::Temp->new( TEMPLATE => "${tmp2}_XXXXX" );
        $tmp1->print( $yaml1 );
        $tmp2->print( $yaml2 );
        system "diff -u $tmp1 $tmp2";
    }
}

1;
