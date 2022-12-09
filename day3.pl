
% -*- mode: prolog -*-

:- use_module(library(dcg/basics)).

sack([])      --> eol.
sack([I|Is])  --> [C], { code_type(C, alpha), atom_chars(I, [C]) }, sack(Is).

sacks([])     --> eol, !.
sacks([S|Ss]) --> sack(S), sacks(Ss).

compartments(S, L, R) :-
    append(L, R, S),
    same_length(L, R).

overlap(L, R, I) :-
    list_to_set(L, LS),
    list_to_set(R, RS),
    intersection(LS, RS, [I]).

overlap(S, I) :-
    compartments(S, L, R),
    overlap(L, R, I).

priority(C, P) :-
    atom_chars(abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ, Cs),
    nth1(P, Cs, C),
    !.

part1(N) :-
    phrase_from_file(sacks(S), 'day3.input'),
    maplist(overlap, S, Is),
    maplist(priority, Is, Ps),
    sum_list(Ps, N).

badge(X, Y, Z, B) :-
    maplist(list_to_ord_set, [X, Y, Z], OSs),
    ord_intersection(OSs, [B]).

badges([], []).
badges([X, Y, Z|Ss], [B|Bs]) :-
    badge(X, Y, Z, B),
    badges(Ss, Bs).

part2(N) :-
    phrase_from_file(sacks(S), 'day3.input'),
    badges(S, B),
    maplist(priority, B, Ps),
    sum_list(Ps, N).
