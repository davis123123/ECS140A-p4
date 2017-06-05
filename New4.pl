
max_distance(Food, FinalMaxDistance) :-
     Distance is 0, %[Food,Remaining,Distance]
     travel([Food,Distance],X),
     FinalMaxDistance is X * 10, !.

travel([0,Distance],X):- X is Distance.  %Base Case with remaining 0
travel([1,Distance],X):- X is Distance + 1. %Base Case with remaining 1
travel([2,Distance],X):- X is Distance + 2. %Base Case with remaining 2
travel([3,Distance],X):- X is Distance + 3. %Base Case with remaining 3
travel([4,Distance],X):- X is Distance + 4. %Base Case with remaining 4
travel([5,Distance],X):- X is Distance + 5. %Base Case with remaining 5
travel([6,Distance],X):- X is Distance + 6. %Base Case with remaining 6
travel([7,Distance],X):- X is Distance + 6. %Base Case with remaining 7

travel(State,X):-
	move(State,NewState),
	travel(NewState,X). %main recursion

move([Food,Distance],[New_Food,New_Distance]):-
	remainder_check(Food,Z),
	Remainder is Z,
	X is ((div(Food,6)*4) + (Remainder-1)),
	food_check(Food,X,Y),
	New_Food is Y,
	New_Distance is Distance + 1.

remainder_check(Food,Remainder):-
	0 < (mod(Food,6)),
	Remainder is mod(Food,6).

remainder_check(Food,Remainder):-
	0 >= (mod(Food,6)),
	Remainder is 2.

food_check(Food,X,New_Food):-
	Food is 13,
	New_Food is X + 1.
food_check(Food,X,New_Food):-
	Food \= 13,
	New_Food is X.
