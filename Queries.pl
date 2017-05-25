find34(L3) :-
  findall(CourseName, course(CourseName, _, 3), L1),
  findall(CourseName, course(CourseName, _, 4), L2),
  append(L1, L2, L3).
