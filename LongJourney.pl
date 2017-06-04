% consult('LongJourney.pl'), max_distance(55000,MaxDistance).

max_distance(Food, FinalMaxDistance) :-
  Positions = [0, Food, 0], % [Next, Current, Prev]
  travel(Food, 0, Positions, 0, MaxDistance),  % main recursion
  FinalMaxDistance is MaxDistance * 10, !.

travel(_, _, [_, 0, _], PrevMaxDistance, PrevMaxDistance).
travel(Food,DaysTravelled ,[Next, Current, Prev], CurrentDistance, MaxDistance) :-
  Current > 0,
  DaysTravelled < Food, % continue when days travelled < food
  move([Next, Current, Prev],CurrentDistance,NewPositions,NewCurrentDistance),
  NewDaysTravelled is DaysTravelled + 1,
  travel(Food,NewDaysTravelled ,NewPositions, NewCurrentDistance, MaxDistance).

  %move([Next, Current, Prev],CurrentDistance, [0,_,_],CurrentDistance,CurrentDistance).
move([Next, Current, Prev], CurrentDistance ,NewPositions, NewCurrentDistance) :-
  Prev < 3,Current < 6,  % if prev food units is less than 3, move forward
  Holding is Current - 1,
  NewCurrent is Next + Holding,
  NewPositions = [0, NewCurrent, 0],
  NewCurrentDistance is CurrentDistance + 1.

move([Next, Current, Prev],CurrentDistance ,NewPositions,NewCurrentDistance) :-
  Prev < 3,Current > 5, % if prev food units is less than 3, move forward
  Holding is 5,
  NewPrev is Current - 6,
  NewCurrent is Next + Holding,
  NewPositions = [0,NewCurrent,NewPrev],
  NewCurrentDistance is CurrentDistance + 1.

move([_, Current, Prev],CurrentDistance ,NewPositions,NewCurrentDistance) :-
  Prev > 2 ,NewCurrent is Current - 1, % if prev food units is greater than 2, move back
  NewPositions = [NewCurrent, Prev, 0],
  NewCurrentDistance is CurrentDistance - 1.
