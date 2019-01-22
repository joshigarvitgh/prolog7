game(Words):-
Words = ["tee", "tee", "tee", "tee"],
randomWord(Words, Word),
%write_ln(Word),
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
