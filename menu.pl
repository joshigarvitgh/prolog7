% Autor: Tom René Hennig
% Datum: 15.01.2019

%%% Database
:- dynamic words/1.

%%% Main program
main :-
    repeat,
    print_menu,
    write("Command: "),
    get_single_char(CommandCode),
    char_code(Command, CommandCode),
    writeln(""), writeln(""),
    ( Command == 'r' -> read_database ;
      Command == 'l' -> print_database ;
      Command == 'a' -> add_word ;
      Command == 'd' -> delete_word ;
      Command == 'w' -> write_database ;
      Command == 'g' -> guess_word ;
      Command == 'e' -> ! ;
      writeln("Please choose one of the options.")
    ),
    fail.

print_menu :-
    writeln(""),
    writeln("G u e s s  a  W o r d"),
    writeln("---------------------"),
    writeln("  r - read database file"),
    writeln("  l - list knowledge base"),
    writeln("  a - add a new word"),
    writeln("  d - delete a word"),
    writeln("  w - write database file"),
    writeln("  g - guess a word"),
    writeln("  e - end the game").

read_database :-
    writeln("Reading database... "),
    open("database.txt", read, DatabaseFD),
    repeat,
    read_string(DatabaseFD, "\n\r", " \t", End, Word),
    (words(Word) ->
        true ;
        (string_length(Word, 0) ->
            writeln("Trying to add empty string to the database...") ;
            assert(words(Word))         % add only new word to list
        )
    ),
    (End == -1 -> ! ; fail),            % repeat until EOF
    close(DatabaseFD),
    writeln("Success").

write_database :-
    writeln("Writing database..."),
    open("database.txt", write, DatabaseFD), !,
    words(Word),
    writeln(DatabaseFD, Word),
    flush_output(DatabaseFD).

print_database :-
    writeln("Current content of the database:"),
    words(Word),
    writeln(Word).

add_word :-
    write("Word to add to the database: "),
    read_string(user_input, "\n\r", " \t", _, Word),
    (words(Word) ->
        writeln("Word is already in the database"), true ;
        (string_length(Word, 0) ->
            writeln("Trying to add empty string to the database...") ;
            assert(words(Word))
        )
    ).

delete_word :-
    write("Word to delete from the database: "),
    read_string(user_input, "\n\r", " \t", _, Word),
    (words(Word) ->
        retractall(words(Word)) ;
        writeln("Word is not in the database")
    ).

guess_word.
