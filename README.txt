Calvin Hu  999776788
Yunwon Tae 912222675

------Project 4------

------Queries.pl------
  We provided sources to predicates "remove_duplicates" and "inter" in this file.
  There is a included course_test.p available to use.
  We used member,predicate recursion, and findall to do most of the queries.

------MissionaryCannibal.pl------
  Run:
    consult('MissionaryCannibal.pl').
    mc_solve(X).
  Notes:
    To solve this puzzle, we have to make predicates that specify all possible
    moves for canibals and missionaries.
    Also, we need safe check, whether the moves are valid or not. This way the
    program will try every moves and find correct set of moves to reach [0,0,0,3,w] from [0,0,0,3,e].
    This list represents [Missionary on East, Canibal on East, Missionary on West, Canibal on West, Direction].
    In main recursion, we made visited predicate to prevent the infinite loop.
    http://artificialintelligence-notes.blogspot.com/2011/04/missionaries-and-cannibals-problem.html
    http://iamnifras.blogspot.com/2014/07/missionaries-canibal-problem-in-ai.html

------MapColoring.pl------
  Run:
    consult('europe.p').
    consult('MapColoring.pl').
    mapColoring(SortedMap).
  Notes:
    We provided another map, "states.pl", the 48 adjacent states.
    We provided sources to "remove_duplicates" in this file.
    First we start with an empty map, select a country from the database, and
    assign it the first available color.
    If there are no available colors, backtrack to the last country and assign
    it a different color while setting its current color to invalid.

------LongJourney.pl------
  Run:
    consult('LongJourney.pl').
    max_distance(113,MaxDistance).
  Notes:
    The pattern with long journey is that if there is 3 or more food units in
    the previous position, we can afford to go back 10 miles and retrieve more
    food. If there are less than 3 food units in the previous position we do not
    move back, but move forward instead and carry the maximum amount of food to
    the next position.
