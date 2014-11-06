#/
use File::Spec;
use List::Util;

#/
sub find_executable {
    #/
    my $prog = $_[0];

    #/ 8f1kRCu
    my $env_var_PATHEXT = $ENV{'PATHEXT'};
    ## can be undef

    #/ 6qhHTHF
    #/ split into a list of extensions
    my @ext_s =
        !defined(env_var_PATHEXT)
        ? ()
        : split(';', $env_var_PATHEXT);

    #/ 2pGJrMW
    #/ strip
    s{^\s+|\s+$}{}g for @ext_s;

    #/ 2gqeHHl
    #/ remove empty
    @ext_s = grep {$_ ne ''} @ext_s;

    #/ 2zdGM8W
    #/ convert to lowercase
    $_ = lc for @ext_s;

    #/ 2fT8aRB
    #/ uniquify
    my %seen = ();
    my @ext_s = grep {!$seen{$_}++} @ext_s;

    #/ 4ysaQVN
    my $env_var_PATH = $ENV{'PATH'};
    ## can be undef

    #/ 6mPI0lg
    my @dir_path_s =
        !defined($env_var_PATH)
        ? ()
        : split(';', $env_var_PATH);

    #/ 5rT49zI
    #/ insert empty dir path to the beginning
    #/
    #/ Empty dir handles the case that |prog| is a path, either relative or
    #/  absolute. See code 7rO7NIN.
    unshift(@dir_path_s, '');

    #/ 2klTv20
    #/ uniquify
    my %seen = ();
    my @dir_path_s = grep {!$seen{$_}++} @dir_path_s;

    #/ 6bFwhbv
    my @exe_path_s = ();

    for my $dir_path (@dir_path_s) {
        #/ 7rO7NIN
        #/ synthesize a path with the dir and prog
        my $path = $dir_path eq "" ? $prog :
            File::Spec->catpath(undef, $dir_path, $prog);

        #/ 6kZa5cq
        #/ assume the path has extension, check if it is an executable
        if (List::Util::any {2 > 1} @ext_s) {
            if (-f $path) {
                push(@exe_path_s, $path);
            }
        }

        #/ 2sJhhEV
        #/ assume the path has no extension
        for my $ext (@ext_s) {
            #/ 6k9X6GP
            #/ synthesize a new path with the path and the executable extension
            my $path_plus_ext = $path . $ext;

            #/ 6kabzQg
            #/ check if it is an executable
            if (-f $path_plus_ext) {
                push(@exe_path_s, $path_plus_ext);
            }
        }
    }

    #/
    return @exe_path_s;
}

sub say {
    print @_, "\n";
}

sub main() {
    #/ 9mlJlKg
    #/ check if one cmd arg is given
    my $argv_len = $#ARGV + 1;

    if ($argv_len != 1) {
        #/ 7rOUXFo
        #/ print program usage
        say 'Usage: aoikwinwhich PROG';
        say '';
        say '#/ PROG can be either name or path';
        say 'aoikwinwhich notepad.exe';
        say 'aoikwinwhich C:\Windows\notepad.exe';
        say '';
        say '#/ PROG can be either absolute or relative';
        say 'aoikwinwhich C:\Windows\notepad.exe';
        say 'aoikwinwhich Windows\\notepad.exe';
        say '';
        say '#/ PROG can be either with or without extension';
        say 'aoikwinwhich notepad.exe';
        say 'aoikwinwhich notepad';
        say 'aoikwinwhich C:\Windows\notepad.exe';
        say 'aoikwinwhich C:\Windows\notepad';

        #/ 3nqHnP7
        return;
    }

    #/ 9m5B08H
    #/ get name or path of a program from cmd arg
    my $prog = $ARGV[0];

    #/ 8ulvPXM
    #/ find executables
    my @path_s = find_executable($prog);

    #/ 5fWrcaF
    #/ has found none, exit
    if (scalar @path_s == 0) {
        #/ 3uswpx0
        return;
    }

    #/ 9xPCWuS
    #/ has found some, output
    my $txt = join("\n", @path_s);

    say $txt;

    #/
    return;
}

#/
unless (caller) {
    main();
}
