
% -*- mode: prolog -*-

:- use_module(library(dcg/basics)).
:- use_module(library(clpfd)).

assignment(L-H)     --> integer(L), "-", integer(H).
apair(A, B)         --> assignment(A), ",", assignment(B).

apairs([])          --> eol.
apairs([[A, B]|Ps]) --> apair(A, B), eol, apairs(Ps).

nested(L1-H1, L2-H2) :-
    ( L1 >= L2, H1 =< H2
    ; L2 >= L1, H2 =< H1
    ), !. % cut inhibits double-counting equal ranges.

overlaps(L1-H1, L2-H2) :-
    X in L1..H1,
    Y in L2..H2,
    X #= Y.

part1(N) :-
    phrase_from_file(apairs(Ps), 'day4.input'),
    aggregate_all(count, (member([A, B], Ps), nested(A, B)), N).

part2(N) :-
    phrase_from_file(apairs(Ps), 'day4.input'),
    aggregate_all(count, (member([A, B], Ps), overlaps(A, B)), N).
