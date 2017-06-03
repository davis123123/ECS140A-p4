max_distance(Food, MaxDistance) :-
  Positions = [0, Food, 0], % [Next, Current, Prev]
  travel(Food, 0, Positions, 0, MaxDistance). % main recursion

travel(Food, DaysTravelled, Positions, CurrentDistance, MaxDistance) :-
  DaysTravelled == Food. % stop when days travelled == food.
travel(Food, DaysTravelled, Positions, CurrentDistance, MaxDistance) :-
  DaysTravelled < Food, % continue when days travelled < food
  updatePositions(DaysTravelled, Positions, NewPositions, NewCurrentDistance, NewMaxDistance, NewDaysTravelled),
  travel(Food, NewDaysTravelled, NewPositions, NewCurrentDistance, NewMaxDistance).


updatePositions(DaysTravelled, Positions, NewPositions, NewCurrentDistance, NewMaxDistance, NewDaysTravelled) :-
  % if prev food units is greater than 2, move back
  getElement(Positions, 2, Prev),
  Prev > 2,
  getElement(Positions, 0, Next),
  getElement(Positions, 1, Current),
  % back(),
  % NewPositions = [],
  NewCurrentDistance = CurrentDistance - 1,
updatePositions(DaysTravelled, Positions, NewPositions, NewCurrentDistance, NewMaxDistance, NewDaysTravelled) :-
  % if prev food units is less than 3, move forward
  getElement(Positions, 2, Prev),
  Prev < 3,
  getElement(Positions, 0, Next),
  getElement(Positions, 1, Current),
  forward(Next, Current, Holding, NewCurrent, NewPrev),
  NewPositions = [0, NewCurrent, NewPrev],
  NewCurrentDistance is CurrentDistance + 1,
  % updateMaxDistance(),
  NewDaysTravelled is DaysTravelled + 1.

getElement([H|T], 0, Element) :-
  Element = H, !.
getElement([_|T], N, Element) :-
  N > 0,
  NewN is N - 1,
  getElement(T, NewN, Element).

forward(Next, Current, Holding, NewCurrent, NewPrev) :-
  Current < 5,
  Holding = Current - 1,
  NewPrev = Current - (Holding + 1),
  NewCurrent = Next + Holding.
forward(Next, Current, Holding, NewCurrent, NewPrev) :-
  Current > 5,
  Holding = 5,
  NewPrev = Current - 6,
  NewCurrent = Next + Holding.
