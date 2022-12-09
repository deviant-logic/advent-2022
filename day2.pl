
% -*- mode: prolog -*-

:- use_module(library(dcg/basics)).

shape(rock)             --> "A"; "X".
shape(paper)            --> "B"; "Y".
shape(scissors)         --> "C"; "Z".

round(Them, Me)         --> shape(Them), " ", shape(Me).

rounds([])              --> eol.
rounds([[Them, Me]|Rs]) --> round(Them, Me), eol, rounds(Rs).

parse(Rs) :-
    phrase_from_file(rounds(Rs), 'day2.input').

result(lose)            --> "X".
result(draw)            --> "Y".
result(win)             --> "Z".

round2(Them, Me)        --> shape(Them), " ", result(Me).
round2s([])             --> eol.
round2s([[Them, Me]|R]) --> round2(Them, Me), eol, round2s(R).

parse2(Rs) :- phrase_from_file(round2s(Rs), 'day2.input').

shape_score(rock, 1).
shape_score(paper, 2).
shape_score(scissors, 3).

win(rock, paper).
win(paper, scissors).
win(scissors, rock).

lose(X, Y) :- win(Y, X).

draw(X, X).

outcome_score(X, Y, 0) :- lose(X, Y).
outcome_score(X, Y, 3) :- draw(X, Y).
outcome_score(X, Y, 6) :- win(X, Y).

round_score(X, Y, R) :-
    outcome_score(X, Y, O),
    shape_score(Y, S),
    !,
    R is O + S.
round_score([X, Y], S) :- round_score(X, Y, S).

total_score(Rs, S) :-
    maplist(round_score, Rs, Ss),
    sum_list(Ss, S).

part1(S) :-
    parse(Rs),
    total_score(Rs, S).

from_result([X, lose], [X, Y]) :- lose(X, Y).
from_result([X, draw], [X, Y]) :- draw(X, Y).
from_result([X, win],  [X, Y]) :- win(X, Y).

part2(S) :-
    parse2(Rs),
    maplist(from_result, Rs, FRs),
    total_score(FRs, S).
