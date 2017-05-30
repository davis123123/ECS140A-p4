% consult('europe.p').
% consult('MapColoring.pl').

color(red).
color(white).
color(blue).
color(gold).

% https://stackoverflow.com/questions/9615002/intersection-and-union-of-2-lists
inter([], _, []).
inter([H1|T1], L2, [H1|Res]) :-
  member(H1, L2),
  inter(T1, L2, Res).
inter([_|T1], L2, Res) :-
  inter(T1, L2, Res).
% -------------------------------------------------------------------------------

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

colorizeMap([], UnsortedMap, SortedMap) :-
  sort(UnsortedMap, SortedMap).
colorizeMap([NextCountry|T], UnsortedMap, SortedMap) :-
  colorizeCountry(NextCountry, UnsortedMap, Element),
  colorizeMap(T, [Element|UnsortedMap], SortedMap).

colorizeCountry(NextCountry, UnsortedMap, Element) :-
  findall(AdjCountry, (is_adjacent(NextCountry, AdjCountry), member([AdjCountry, _], UnsortedMap)), AdjCountries),
  findAdjColors(AdjCountries, UnsortedMap, AdjColors),
  findall(Color, (color(Color), \+ member(Color, AdjColors)), ValidColors),
  setColor(ValidColors, NextCountry, Element).

findAdjColors([], _, []).
findAdjColors([AdjCountry|OtherAdjCountries], UnsortedMap, [AdjColor|AdjColors]) :-
  findall(Color, (color(Color), member([AdjCountry, Color], UnsortedMap)), [AdjColor|_]),
  findAdjColors(OtherAdjCountries, UnsortedMap, AdjColors).

setColor([NextColor|_], NextCountry, Element) :-
  Element = [NextCountry, NextColor].

mapColoring(SortedMap) :-
  listCountries(List),
  sort(List, AllCountries),
  delete(AllCountries, hungary, Countries),
  UnsortedMap = [[hungary,red]],
  colorizeMap(Countries, UnsortedMap, SortedMap).

% app([],L) :-
%   print(L).
% app([H|T], L) :-
%   app(T, [H|L]).
