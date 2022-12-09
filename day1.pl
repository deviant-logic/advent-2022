
% -*- mode: prolog -*-

:- use_module(library(dcg/basics)).

cal([])        --> eol.
cal([C|Cs])    --> integer(C), eol, cal(Cs).

cals([])       --> eol.
cals([Cs|Css]) --> cal(Cs), cals(Css).

parse(Css) :-
    phrase_from_file(cals(Css), 'day1.input').

part1(Css, S) :-
    aggregate_all(max(SCs), (member(Cs, Css), sum_list(Cs, SCs)), S).

part2(Css, S) :-
    maplist(sum_list, Css, Sss),
    sort(0, @>, Sss, [X, Y, Z|_]),
    S is X + Y + Z.
