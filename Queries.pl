% consult('course_test.p').
% consult('Queries.pl').

% a) Find all courses with 3 or 4 credits (fc_course).
fc_course(ListOfCourses) :-
  findall(CourseName, (course(CourseName, _, Units), member(Units, [3,4])), ListOfCourses).

% b) Find all courses whose immediate pre-requisite is a course (imprereq).

% c) Find names of all students in a course (students).
students(ListOfStudents, Course) :-
  findall(Name, (student(Name, Classes, _), member(Course, Classes)), ListOfStudents).

% d) Find the names of all students who have not met the perquisites for the courses
% they are currently taking (students_prereq). (This will involve finding not only the
% immediate prerequisites of a course, but pre-requisite courses of pre-requisites
% and so on.)
students_prereq() :-
