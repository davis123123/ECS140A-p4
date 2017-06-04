%http://artificialintelligence-notes.blogspot.com/2011/04/missionaries-and-cannibals-problem.html
safe(_, 0).
safe(_, 3).
safe(X, X).

%http://iamnifras.blogspot.com/2014/07/missionaries-canibal-problem-in-ai.html


%All Possible Moves!!
%Two missionaries moves east to west
move(X,X,[mm,right]).
move([Me, Ce, Mw, Cw, e],X,[mm,right]):-
        Me > 1, Me2 is Me - 2, Mw < 2, Mw2 is Mw + 2, safe(Me2,Cw), move([Me2,Ce,Mw2,Cw,w],X,[mm,right]).
%Two missionaries moves west to east
move(X,X,[mm,left]).
move([Me, Ce, Mw, Cw, w], X,[mm,left]):-
        Me < 2, Me2 is Me + 2, Mw > 1 ,Mw2 is Mw - 2, safe(Mw2,Cw),move([Me2,Ce,Mw2,Cw,e],X,[mm,left]).

%Two canibals moves east to west
move(X,X,[cc,right]).
move([Me, Ce, Mw, Cw, e],X,[cc,right]):-
        Ce2 is Ce - 2, Cw2 is Cw + 2, safe(Me,Ce2),move([Me,Ce2,Mw,Cw2,w],X,[cc,right]).

%Two canibals moves west to east
move(X,X,[cc,left]).
move([Me, Ce, Mw, Cw, w],X,[cc,left]):-
        Ce2 is Ce + 2, Cw2 is Cw - 2, safe(Me,Cw2),move([Me,Ce2,Mw,Cw2,e],X,[cc,left]).

%One missionary moves east to west
move(X,X,[m,right]).
move([Me, Ce, Mw, Cw, e],X,[m,right]):-
        Me2 is Me - 1, Mw2 is Mw + 1, safe(Me2,Cw),move([Me2,Ce,Mw2,Cw,w],X,[m,right]).

%One missionary moves west to east
move(X,X,[m,left]).
move([Me, Ce, Mw, Cw, w],X, [m,left]):-
        Me2 is Me + 1, Mw2 is Mw - 1, safe(Mw2,Cw),move([Me2,Ce,Mw2,Cw,e],X,[m,left]).

%One canibal moves east to west
move(X,X,[c,right]).
move([Me, Ce, Mw, Cw, e],X,[c,right]):-
        Ce2 is Ce - 1, Cw2 is Cw + 1, safe(Me,Ce2),move([Me,Ce2,Mw,Cw2,w],X,[c,right]).

%One canibal moves west to east
move(X,X,[c,left]).
move([Me, Ce, Mw, Cw, w],X, [c,left]):-
        Ce2 is Ce + 1, Cw2 is Cw - 1, safe(Me,Ce2),move([Me,Ce2,Mw,Cw2,e],X,[c,left]).

%One canibal and missionary move to east to west
move(X,X,[mc,right]).
move([Me, Ce, Mw, Cw, e],X, [mc,right]):-
        Ce2 is Ce - 1, Cw2 is Cw + 1,
        Me2 is Me - 1, Mw2 is Mw + 1, safe(Me2,Ce2),move([Me2,Ce2,Mw2,Cw2,w],X,[mc,right]).
%One canibal and missionary move to west to east
move(X,X,[mc,left]).
move([Me, Ce, Mw, Cw, w],X, [mc,left]):-
        Ce2 is Ce + 1, Cw2 is Cw - 1,
        Me2 is Me + 1, Mw2 is Mw - 1, safe(Mw2,Cw2),move([Me2,Ce2,Mw2,Cw2,e],X,[mc,left]).

visited(List1,List2):- \+(member(List1,List2)).

revw([ ],Z,Z).
revw([H|T],Z,AC):-revw(T,Z,[H|AC]).
reverse_(X,R):-revw(X,R,[]).


mc_worker([0,0,3,3,w],Already_Visited,X,X):- reverse_(Already_Visited,R),write('Position:'),write(R).
mc_worker(Pos,Already_Visited,Moves,X):-
        move(Pos,Next_Pos,[Move,Direction]),
        visited(Next_Pos,Already_Visited),
        mc_worker(Next_Pos,[Next_Pos|Already_Visited],[[Move,Direction]|Moves],X).

mc_solve(X) :- mc_worker([3, 3, 0, 0, e],[[3,3,0,0,e]],[],X),!.
