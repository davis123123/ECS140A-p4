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

initialize([H|T], Countries, InitialMap) :-
  sort(T, Countries),
  color(Color),
  InitialMap = [[H,Color]].

colorizeMap([], InitialMap, SortedMap, _) :-
  sort(InitialMap, SortedMap).
colorizeMap([NextCountry|Remaining], InitialMap, SortedMap, ColorHistory) :-
  findValidColors(NextCountry, InitialMap, ValidColors),
  setColor(ValidColors, NextCountry, Remaining, NewRemaining, InitialMap, NewMap, Element, ColorHistory, NewColorHistory),
  colorizeMap(NewRemaining, [Element|NewMap], SortedMap, NewColorHistory).

findValidColors(NextCountry, InitialMap, ValidColors) :-
  findall(AdjCountry, (is_adjacent(NextCountry, AdjCountry), member([AdjCountry, _], InitialMap)), AdjCountries),
  findAdjColors(AdjCountries, InitialMap, AdjColors),
  findall(Color, (color(Color), \+ member(Color, AdjColors)), ValidColors).

findAdjColors([], _, []).
findAdjColors([AdjCountry|OtherAdjCountries], InitialMap, [AdjColor|AdjColors]) :-
  findall(Color, (color(Color), member([AdjCountry, Color], InitialMap)), [AdjColor|_]),
  findAdjColors(OtherAdjCountries, InitialMap, AdjColors).

setColor([NextColor|_], NextCountry, Remaining, NewRemaining, InitialMap, NewMap, Element, ColorHistory, NewColorHistory) :-
  Element = [NextCountry, NextColor],
  NewRemaining = Remaining,
  NewMap = InitialMap,
  NewColorHistory = ColorHistory.
setColor([], NextCountry, Remaining, NewRemaining, [[PrevCountry|[PrevColor|_]]|History], NewMap, Element, ColorHistory, NewColorHistory) :-
  findPickedColors(NextCountry, ColorHistory, NextCountryPrevColors),
  deleteColorHistory(NextCountry, NextCountryPrevColors, ColorHistory, OldColorHistory),
  findPickedColors(PrevCountry, OldColorHistory, PrevColors),
  deleteColorHistory(PrevCountry, PrevColors, OldColorHistory, OldColorHistory2),
  setNewPrevColors(PrevCountry, PrevColor, PrevColors, NewPrevColors),
  findValidColors(PrevCountry, History, SomeColors),
  append(PrevColors, [PrevColor], Combined),
  deleteColors(SomeColors, Combined, ValidColors),
  setColor(ValidColors, PrevCountry, [NextCountry|Remaining], NewRemaining, History, NewMap, Element, [NewPrevColors|OldColorHistory2], NewColorHistory).

findPickedColors(_, [], PrevColors) :-
  PrevColors = [none], !.
findPickedColors(Country, [[Name|[Colors]]|_], PrevColors) :-
  Country == Name,
  PrevColors = Colors, !.
findPickedColors(Country, [[_|[_]]|T], PrevColors) :-
  findPickedColors(Country, T, PrevColors).

deleteColors(SomeColors, [], ValidColors) :-
  ValidColors = SomeColors, !.
deleteColors(SomeColors, [H|T], ValidColors) :-
  delete(SomeColors, H, Temp),
  deleteColors(Temp, T, ValidColors).

deleteColorHistory(Country, Colors, ColorHistory, NewColorHistory) :-
  PrevColors = [Country, [Colors]],
  delete(ColorHistory, PrevColors, NewColorHistory).

setNewPrevColors(PrevCountry, PrevColor, [none], NewPrevColors) :-
  NewPrevColors = [PrevCountry, [PrevColor]], !.
setNewPrevColors(PrevCountry, PrevColor, PrevColors, NewPrevColors) :-
  NewPrevColors = [PrevCountry, [PrevColor|PrevColors]], !.

mapColoring(SortedMap) :-
  listCountries(AllCountries),
  initialize(AllCountries, Countries, InitialMap),
  colorizeMap(Countries, InitialMap, SortedMap, []), !.
