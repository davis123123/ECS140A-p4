% consult('course_test.p').
% consult('Queries.pl').

% a) Find all courses with 3 or 4 credits (fc_course).
fc_course(ListOfCourses) :-
  findall(CourseName, (course(CourseName, _, Units), member(Units, [3,4])), ListOfCourses).

% b) Find all courses whose immediate pre-requisite is a course (imprereq).
imprereq(Course, List) :-
  findall(Class, (course(Class, Preq, _), member(Course, Preq)), List).

% c) Find names of all students in a course (students).
students(ListOfStudents, Course) :-
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
  intersect(PreReqs, PrevCourses),
  finishedPreReqs(TCC, PrevCourses).

intersect([], _).
intersect([H|T], L) :-
  member(H, L),
  intersect(T, L).

% e) Find all pre-requisites of a course (allprereq). (This will involve finding not only
% the immediate prerequisites of a course, but pre-requisite courses of pre-requisites
% and so on.)

% f) Find all teachers the students of a course are currently taking (student_teach).
student_teach(Course, ListOfTeachers) :-
  findall(Name, (student(Name, CurrentCourses, PrevCourses), \+ finishedPreReqs(CurrentCourses, PrevCourses)), ListOfTeachers).
