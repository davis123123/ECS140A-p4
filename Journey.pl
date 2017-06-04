% consult('Journey.pl').

max_distance(Food, MaxDistance) :-
  Positions = [0, Food, 0], % [Next, Current, Prev]
  PrevMaxDistance = 0,
  travel(Food, 0, Positions, 0, PrevMaxDistance, MaxDistance). % main recursion

travel(Food, DaysTravelled, _, _, PrevMaxDistance, MaxDistance) :-
  DaysTravelled is Food,
  MaxDistance is PrevMaxDistance.
travel(Food, DaysTravelled, Positions, CurrentDistance, PrevMaxDistance, MaxDistance) :-
  DaysTravelled < Food, % continue when days travelled < food
  updatePositions(Positions, CurrentDistance, NewPositions, NewCurrentDistance),

  NewDaysTravelled is DaysTravelled + 1,
  updateMaxDistance(CurrentDistance, NewCurrentDistance, PrevMaxDistance, TempMaxDistance),
  travel(Food, NewDaysTravelled, NewPositions, NewCurrentDistance, TempMaxDistance, MaxDistance).

updatePositions(Positions, CurrentDistance, NewPositions, NewCurrentDistance) :-
  % if prev food units is less than 3, move forward
  getElement(Positions, 2, Prev),
  Prev < 3,
  getElement(Positions, 0, Next),
  getElement(Positions, 1, Current),
  forward(Next, Current, NewCurrent, NewPrev),
  NewPositions = [0, NewCurrent, NewPrev],
  NewCurrentDistance is CurrentDistance + 1.
updatePositions(Positions, CurrentDistance, NewPositions, NewCurrentDistance) :-
  % if prev food units is greater than 2, move back
  getElement(Positions, 2, Prev),
  Prev > 2,
  getElement(Positions, 1, Current),
  back(Current, Prev, NewNext, NewCurrent),
  NewPositions = [NewNext, NewCurrent, 0],
  NewCurrentDistance = CurrentDistance - 1.

updateMaxDistance(CurrentDistance, NewCurrentDistance, PrevMaxDistance, NextMaxDistance) :-
  NewCurrentDistance =< PrevMaxDistance,
  NextMaxDistance is CurrentDistance.
updateMaxDistance(_, NewCurrentDistance, PrevMaxDistance, NextMaxDistance) :-
  NewCurrentDistance > PrevMaxDistance,
  NextMaxDistance is NewCurrentDistance.

getElement([H|_], 0, Element) :-
  Element = H, !.
getElement([_|T], N, Element) :-
  N > 0,
  NewN is N - 1,
  getElement(T, NewN, Element).

forward(Next, Current, NewCurrent, NewPrev) :-
  Current < 6,
  Holding is Current - 1,
  NewPrev is 0,
  NewCurrent is Next + Holding, !.
forward(Next, Current, NewCurrent, NewPrev) :-
  Current > 5,
  Holding is 5,
  NewPrev is Current - 6,
  NewCurrent is Next + Holding, !.

back(Current, Prev, NewNext, NewCurrent) :-
  NewCurrent is Prev,
  NewNext is Current - 1.
