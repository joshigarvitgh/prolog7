% Autor: %AUTHOR%
% Datum: %DATE%

:- dynamic words/1.

read_database :-
    open("database.txt", read, InputFD),  repeat,
    read_string(InputFD, "\n", " \r",_, Term),
    write(Term).
    
%write_database :-
%    .

print_database :-
    listing(words).

add_word(Word) :-
    assert(words(Word)).

delete_word(Word) :-
  retractall(words(Word)).