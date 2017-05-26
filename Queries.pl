% consult('course_test.p').
% consult('Queries.pl').

% a) Find all courses with 3 or 4 credits (fc_course).
fc_course(Courses) :-
  findall(CourseName, (course(CourseName, _, Units), member(Units, [3,4])), Courses).

% fc_course(L) :-
%   findall(Name, (course(Name, _, Units), (Units = 3; Units = 4)), L).
%
% find34(L3) :-
%   findall(CourseName, course(CourseName, _, 3), L1),
%   findall(CourseName, course(CourseName, _, 4), L2),
%   append(L1, L2, L3).

% b) Find all courses whose immediate pre-requisite is a course (imprereq).

% c) Find names of all students in a course (students).
students(NamesOfStudents, Course) :-
  findall(Name, (student(Name, Classes, _), member(Course, Classes)), NamesOfStudents).
