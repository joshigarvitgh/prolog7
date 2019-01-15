test():- writeln("G u e s s  a  W o r d"),
    writeln("---------------------"),
    writeln("  r - read database file"),
    writeln("  l - list knowledge base"),
    writeln("  a - add a new word"),
    writeln("  d - delete a word"),
    writeln("  w - write database file"),
    writeln("  g - guess a word"),
    writeln("  e - end the game"),
    repeat,
    write("Command: "),
    get_single_char(CommandCode),
    char_code(Command, CommandCode),
    switch(Command, [
        'r' : writeln("Reading"),
        'l' : writeln("Listing"),
        'a' : writeln("Adding"),
        'd' : writeln("Deleting"),
        'w' : writeln("Writing"),
        'g' : writeln("Guessing"),
        'e' : writeln("Ending")
    ]).

switch(X, [Val:Goal|Cases]) :-
    ( X=Val ->
        call(Goal)
    ;
        switch(X, Cases)
    ).
 