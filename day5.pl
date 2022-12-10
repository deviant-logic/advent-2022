
% -*- mode: prolog -*-

:- use_module(library(dcg/basics)).
:- use_module(library(clpfd)). % evidently transpose lives here

cell('_')          --> "   ".
cell(C)            --> "[", [N], "]", { atom_codes(C, [N]) }.

row([C])           --> cell(C), eol.
row([C|Cs])        --> cell(C), " ", row(Cs).

% this got janky; not sure what's up with it.
col_num            --> " "; number(_).
col_nums           --> eol; col_num, col_nums.

rows([])           --> col_nums.
rows([R|Rs])       --> row(R), rows(Rs).

cmd(move(N, F, T)) --> "move ", number(N), " from ", number(F), " to ", number(T).
cmds([])           --> eol.
cmds([C|Cs])       --> cmd(C), eol, cmds(Cs).

crates(R, C) --> rows(R), eol, cmds(C).

strip(X, L, D) :- delete(L, X, D).

stacks(R, S) :-
    transpose(R, T),
    maplist(strip('_'), T, S).

tops([], '').
tops([[]|Ss], A) :- tops(Ss, A).
tops([[T|_]|Ss], A)  :- tops(Ss, A0), atom_concat(T, A0, A).

% I'm pretty sure this is utterly ridiculous
eval(move(0, _, _), S, S).
eval(move(N, From, To), S, NS) :-
    nth1(From, S, [C|SF], S0),
    nth1(From, S1, SF, S0),
    nth1(To,   S1, ST, S2),
    nth1(To,   S3, [C|ST], S2),
    Next is N - 1,
    eval(move(Next, From, To), S3, NS).

eval(move2(N, From, To), S, NS) :-
    nth1(From, S,  SF, S0),
    append(SFP, SFR, SF),
    length(SFP, N),
    nth1(From, S1, SFR, S0),
    nth1(To,   S1, STR, S2),
    append(SFP, STR, ST),
    nth1(To,   NS, ST, S2).


eval([], S, S).
eval([C|Cs], S, NS) :-
    eval(C, S, S0),
    eval(Cs, S0, NS).

part1(A) :-
    phrase_from_file(crates(R, C), 'day5.input'),
    stacks(R, S),
    eval(C, S, NS),
    tops(NS, A).

tweak(move(N, F, T), move2(N, F, T)).

part2(A) :-
    phrase_from_file(crates(R, C), 'day5.input'),
    stacks(R, S),
    maplist(tweak, C, C2),
    eval(C2, S, NS),
    tops(NS, A).
