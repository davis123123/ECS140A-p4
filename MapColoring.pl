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
% ------------------------------------------------

listCountries(L) :-
  findall(Country, is_adjacent(Country, _), Temp),
  remove_duplicates(Temp, L).

colorizeMap([], InitialMap, SortedMap) :-
  SortedMap = InitialMap.
  % sort(InitialMap, SortedMap).
colorizeMap([NextCountry|Remaining], InitialMap, SortedMap) :-
  findValidColors(NextCountry, InitialMap, ValidColors),
  setColor(ValidColors, NextCountry, Remaining, NewRemaining, InitialMap, NewMap, Element),
  colorizeMap(NewRemaining, [Element|NewMap], SortedMap).

findValidColors(NextCountry, InitialMap, ValidColors) :-
  findall(AdjCountry, (is_adjacent(NextCountry, AdjCountry), member([AdjCountry, _], InitialMap)), AdjCountries),
  findAdjColors(AdjCountries, InitialMap, AdjColors),
  findall(Color, (color(Color), \+ member(Color, AdjColors)), ValidColors).

findAdjColors([], _, []).
findAdjColors([AdjCountry|OtherAdjCountries], InitialMap, [AdjColor|AdjColors]) :-
  findall(Color, (color(Color), member([AdjCountry, Color], InitialMap)), [AdjColor|_]),
  findAdjColors(OtherAdjCountries, InitialMap, AdjColors).

setColor([NextColor|_], NextCountry, Remaining, NewRemaining, InitialMap, NewMap, Element) :-
  Element = [NextCountry, NextColor],
  NewRemaining = Remaining,
  NewMap = InitialMap.
setColor([], NextCountry, Remaining, NewRemaining, [[PrevCountry|[PrevColor|_]]|History], NewMap, Element, ColorHistory) :-
  findValidColors(PrevCountry, History, SomeColors),
  findPickedColors(PrevCountry, ColorHistory, PrevColors),
  % at this point the color of the prev country will not allow the next country to have a color
  % therefore the color of the prev country needs to be in the list of invalid colors
  delete(SomeColors, PrevColors, ValidColors),
  setColor(ValidColors, PrevCountry, Remaining, NewRemaining, History, NewMap, Element).

findPickedColors(Country, [], PrevColors) :-
  PrevColors = [], !.
findPickedColors(Country, [[Name|[Colors]]|T], PrevColors) :-
  Country == Name,
  PrevColors = Colors, !.
findPickedColors(Country, [[Name|[Colors]]|T], PrevColors) :-
  findPickedColors(Country, T, PrevColors).

deleteColors(_, [], _).
deleteColors(SomeColors, [H|T], ValidColors) :-
  deleteColors(SomeColors, T, ValidColors).
deleteColors(SomeColors, [H|T], ValidColors) :-
  member(H, SomeColors),
  delete(SomeColors, H, Temp),
  deleteColors(Temp, T, ValidColors).

mapColoring(SortedMap) :-
  listCountries(AllCountries),
  delete(AllCountries, portugal, Countries),
  InitialMap = [[portugal,red]],
  colorizeMap(Countries, InitialMap, SortedMap).
