% consult('course_test.p').
% consult('Queries.pl').

% a) Find all courses with 3 or 4 credits (fc_course).
fc_course(ListOfCourses) :-
  findall(CourseName, (course(CourseName, _, Units), member(Units, [3,4])), ListOfCourses).

% b) Find all courses whose immediate pre-requisite is a course (imprereq).
imprereq(Course, List) :-
  findall(Class, (course(Class, Preq, _), member(Course, Preq)), List).

% c) Find names of all students in a course (students).
students(Course, ListOfStudents) :-
  findall(Name, (student(Name, Classes, _), member(Course, Classes)), ListOfStudents).

% d) Find the names of all students who have not met the perquisites for the courses
% they are currently taking (students_prereq). (This will involve finding not only the
% immediate prerequisites of a course, but pre-requisite courses of pre-requisites
% and so on.)
students_prereq(ListOfStudents) :-
  findall(Name, (student(Name, CurrentCourses, PrevCourses), \+ finishedPreReqs(CurrentCourses, PrevCourses)), ListOfStudents).

finishedPreReqs([], _).
finishedPreReqs([HCC|TCC], PrevCourses) :-
  course(HCC, PreReqs, _),
  finishedPreReqs(PreReqs, PrevCourses),
  isSubset(PreReqs, PrevCourses),
  finishedPreReqs(TCC, PrevCourses).

isSubset([], _).
isSubset([H|T], L) :-
  member(H, L),
  isSubset(T, L).

% e) Find all pre-requisites of a course (allprereq). (This will involve finding not only
% the immediate prerequisites of a course, but pre-requisite courses of pre-requisites
% and so on.)
allprereq(Course, Uniques) :-
  findall(Class, (course(Class, _, _), findpreq(Course, Class)), List), remove_duplicates(List, Uniques).
findpreq(Course, Class) :-
  course(Course, PList, _), deepPreq(PList, Class); course(Course, PList, _), member(Class, PList).
deepPreq(PList, Class) :-
  member(X, PList), findpreq(X, Class).
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

% f) Given a course, find all the students in that course, then find all the
% teachers for the courses that each student (in the list) is taking currently.
student_teach(Course, ListOfTeachers) :-
  findall(
    Teacher,
    (instructor(Teacher, CoursesTaught),
    students(Course, ListOfStudents),
    processStudents(ListOfStudents, CoursesTaught)),
    Temp),
  remove_duplicates(Temp, ListOfTeachers).

processStudents([H|T], CoursesTaught) :-
  student(H, CurrentCourses, _),
  inter(CurrentCourses, CoursesTaught, Matches),
  (\+ length(Matches, 0));
  processStudents(T, CoursesTaught).

% https://stackoverflow.com/questions/9615002/intersection-and-union-of-2-lists
inter([], _, []).
inter([H1|T1], L2, [H1|Res]) :-
  member(H1, L2),
  inter(T1, L2, Res).
inter([_|T1], L2, Res) :-
  inter(T1, L2, Res).
% -------------------------------------------------------------------------------
