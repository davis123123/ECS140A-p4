% consult('europe.p').
% consult('MapColoring.pl').

% http://www.tek-tips.com/viewthread.cfm?qid=1602371
remove_duplicates(List, Result):-
    remove_duplicates(List, [], Result).
remove_duplicates([], Result, Result).
remove_duplicates([Item | Rest], Current, NewRest) :-
    member(Item, Current),!,
    remove_duplicates(Rest, Current, NewRest).
remove_duplicates([Item | Rest], Current, NewRest) :-
    append(Current, [Item], NewCurrent),
    remove_duplicates(Rest, NewCurrent, NewRest).
% -------------------------------------------------

listCountries(L) :-
  findall(Country, is_adjacent(Country, _), Temp),
  remove_duplicates(Temp, L).

colorizeCountries([], []).
colorizeCountries([NextCountry|T], [[NextCountry, red]|UnsortedMap]) :-
  colorizeCountries(T, UnsortedMap).

mapColoring(Map) :-
  listCountries(Countries),
  colorizeCountries(Countries, UnsortedMap),
  sort(UnsortedMap, Map).
