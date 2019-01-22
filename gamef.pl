%%% Database
:- dynamic words/1.
:- dynamic saved/0.

%%% Main program
main :-
    assert(saved),
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
      Command == 'e' -> check_for_saved, ! ;
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
    (access_file("database.txt", read) ->
        true ;
        writeln("File not accessible."), false
    ),
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
    assert(saved),
    writeln("Success").

write_database :-
    assert(saved),
    writeln("Writing database..."),
    (access_file("database.txt", read) ->
        writeln("File will be overridden.") ;
        true
    ),
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
            assert(words(Word)), retract(saved)
        )
    ).

delete_word :-
    write("Word to delete from the database: "),
    read_string(user_input, "\n\r", " \t", _, Word),
    (words(Word) ->
        retractall(words(Word)), retract(saved) ;
        writeln("Word is not in the database")
    ).

check_for_saved :-
    (saved ->
        true ;
        repeat,
            write("Unsaved changes. Are you sure you want to exit? (y/n) "),
            get_single_char(CommandCode),
            char_code(Command, CommandCode),
            ( Command == 'y' -> write_database ;
              Command == 'n' -> true ;
              writeln("Invalid input!"), false
            )
    ).

guess_word :- convert_to_list(Words), game(Words).

convert_to_list(List) :-
    findall(W, words(W), List).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
game(Words):-
    randomWord(Words, Word),
    atom_chars(Word,CharList),
    length(CharList,WordLen),
    createGuessList(WordLen,GuessList),
    string_chars(HiddenWord,GuessList),
    write("Please guess the word: "), write(HiddenWord), nl,
    game2(CharList,GuessList,0).
    
    game2(CharList,GuessList,NumGuess):-
    member('*',GuessList),
    askForALetter(Letter),
    write(Letter),nl,
    updateGuessList(CharList,GuessList,Letter,GuessList2),
    string_chars(HiddenWord,GuessList2),
    write("Your solution: "), write(HiddenWord), nl,
    NumGuess2 is NumGuess+1,
    game2(CharList,GuessList2,NumGuess2).
    game2(_,_,NumGuess):-
    nl, write("Poor! It took you "), write(NumGuess), write(" guesses."), nl,!.
    
    randomWord(Words, Word):-
    length(Words, Len),
    Max is Len+1,
    random(1,Max,Nth),
    getWord(Words, Nth, Word).
    
    getWord([H|_],1,H):-!.
    getWord([_|T],Nth,Word):-
    Nth2 is Nth-1,
    getWord(T,Nth2,Word).
    
    askForALetter(Letter):-
    write("Please guess a letter: "),
    get_single_char(L),
    char_code(Letter,L).
    
    createGuessList(0,[]).
    createGuessList(Len,GuessList):-
    Len2 is Len-1,
    createGuessList(Len2,GuessList2),
    append(['*'],GuessList2,GuessList),!.
    
    firstHalf(_,1,[]):-!.
    firstHalf([H|T],Index,Result):-
    Index2 is Index - 1,
    firstHalf(T,Index2,Result2),
    append([H],Result2,Result),!.
    
    secondHalf([_|T],1,T):-!.
    secondHalf([_|T],Index,Result):-
    Index2 is Index - 1,
    secondHalf(T,Index2,Result),!.
    
    updateGuessList(WordList,GuessList,Letter,GuessList2):-
    nth1(Index,WordList,Letter),
    nth1(Index,GuessList,'*'),
    firstHalf(GuessList,Index,TempGuessList1),
    secondHalf(GuessList,Index,TempGuessList2),
    append(TempGuessList1,[Letter|TempGuessList2],GuessList2),!.
    updateGuessList(_,GuessList,_,GuessList).
    
