% consult('europe.p').
% consult('MapColoring.pl').

color(red).
color(white).
color(blue).
color(gold).

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

colorizeMap([], InitialMap, SortedMap, _) :-
  SortedMap = InitialMap.
  % sort(InitialMap, SortedMap).
colorizeMap([NextCountry|Remaining], InitialMap, SortedMap, PrevColors) :-
  colorizeCountry(NextCountry, Remaining, NewRemaining, InitialMap, NewMap, Element, PrevColors, NewPrevColors),
  colorizeMap(NewRemaining, [Element|NewMap], SortedMap, NewPrevColors).

colorizeCountry(NextCountry, Remaining, NewRemaining, InitialMap, NewMap, Element, PrevColors, NewPrevColors) :-
  findall(AdjCountry, (is_adjacent(NextCountry, AdjCountry), member([AdjCountry, _], InitialMap)), AdjCountries),
  findAdjColors(AdjCountries, InitialMap, AdjColors),
  findall(Color, (color(Color), \+ member(Color, AdjColors)), ValidColors),
  setColor(ValidColors, NextCountry, Remaining, NewRemaining, InitialMap, NewMap, Element, PrevColors, NewPrevColors).

findAdjColors([], _, []).
findAdjColors([AdjCountry|OtherAdjCountries], InitialMap, [AdjColor|AdjColors]) :-
  findall(Color, (color(Color), member([AdjCountry, Color], InitialMap)), [AdjColor|_]),
  findAdjColors(OtherAdjCountries, InitialMap, AdjColors).

setColor([NextColor|_], NextCountry, Remaining, NewRemaining, InitialMap, NewMap, Element, PrevColors, NewPrevColors) :-
  Element = [NextCountry, NextColor],
  NewRemaining = Remaining,
  NewMap = InitialMap,
  NewPrevColors = [[NextColor]|PrevColors].
setColor([], NextCountry, Remaining, NewRemaining, [[PrevCountry|[PrevColor|_]]|History], NewMap, Element, [PrevColorList|ColorHistory], NewPrevColors) :-
  findall(AdjCountry, (is_adjacent(PrevCountry, AdjCountry), member([AdjCountry, _], History)), AdjCountries),
  findAdjColors(AdjCountries, History, AdjColors),
  NewAdjColors = [PrevColor|AdjColors],
  findall(Color, (color(Color), \+ member(Color, NewAdjColors)), ValidColors),
  setColor(ValidColors, PrevCountry, [NextCountry|Remaining], NewRemaining, History, NewMap, Element, [NewAdjColors|ColorHistory], NewPrevColors).

mapColoring(SortedMap) :-
  listCountries(AllCountries),
  delete(AllCountries, portugal, Countries),
  InitialMap = [[portugal,red]],
  PrevColors = [[red]],
  colorizeMap(Countries, InitialMap, SortedMap, PrevColors).
