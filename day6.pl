
% -*- mode: prolog -*-

:- use_module(library(readutil)).

window(P, L, N) :-
    append(P, _, L),
    length(P, N).

window(P, [_|L], N) :-
    window(P, L, N).

% way too slow
find_start(L, N, WS) :-
    findall(P, window(P, L, WS), Ps),
    once((nth0(M, Ps, P), is_set(P))),
    N is M + WS.

part1(N) :-
    read_file_to_codes('day6.input', L, []),
    find_start(L, N, 4).

part2(N) :-
    read_file_to_codes('day6.input', L, []),
    find_start(L, N, 14).
