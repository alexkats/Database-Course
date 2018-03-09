drop database if exists deanery_6;
create database deanery_6;
use deanery_6;

create table Students(
    s_id int primary key,
    s_name varchar(50)) default charset='utf8';

create table Groups(
    g_id int primary key,
    g_name varchar(5)) default charset='utf8';

create table Lecturers(
    l_id int primary key,
    l_name varchar(50)) default charset='utf8';

create table Courses(
    c_id int primary key,
    c_name varchar(50)) default charset='utf8';

create table StudentGroups(
    s_id int primary key,
    g_id int) default charset='utf8';

create table Marks(
    s_id int,
    c_id int,
    mark char,
    primary key (s_id, c_id)) default charset='utf8';

create table Plans(
    g_id int,
    c_id int,
    l_id int,
    primary key (g_id, c_id)) default charset='utf8';

insert into Students (s_id, s_name) values
    (1, "Ivanov"),
    (2, "Petrov"),
    (3, "Sidorov"),
    (4, "Fedorov"),
    (5, "Timofeev");

insert into Groups (g_id, g_name) values
    (1, "M3437"),
    (2, "M3438"),
    (3, "M3439");

insert into Courses (c_id, c_name) values
    (1, "Databases"),
    (2, "Java"),
    (3, "Algorithms");

insert into Lecturers (l_id, l_name) values
    (1, "Korneev"),
    (2, "Stankevich");

insert into StudentGroups (s_id, g_id) values
    (1, 1),
    (2, 2),
    (3, 2),
    (4, 3),
    (5, 3);

insert into Plans (g_id, c_id, l_id) values
    (1, 1, 1),
    (1, 2, 1),
    (1, 3, 2),
    (2, 1, 1),
    (2, 2, 1),
    (2, 3, 2),
    (3, 2, 1);

insert into Marks (s_id, c_id, mark) values
    (1, 1, 'B'),
    (1, 2, 'A'),
    (1, 3, 'C'),
    (2, 1, 'B'),
    (3, 1, 'D');

-- 1
select s_id from Students, Courses where
    Courses.c_name = "Databases" and
    (exists (select * from Marks where
            Students.s_id = Marks.s_id and
            Marks.mark = 'B' and
            Courses.c_id = Marks.c_id));

-- 2(a)
select s_id from Students where
    not exists (select * from Courses where
        Courses.c_name = "Databases" and
        (exists (select * from Marks where
                Students.s_id = Marks.s_id and
                Courses.c_id = Marks.c_id)));

-- 2(b)
select s_id from Students where
    not exists (select * from Courses where
        Courses.c_name = "Databases" and
        (exists (select * from Marks where
                Students.s_id = Marks.s_id and
                Courses.c_id = Marks.c_id)) and
        (exists (select * from StudentGroups where
                exists (select * from Plans where
                    StudentGroups.s_id = Students.s_id and
                    StudentGroups.g_id = Plans.g_id and
                    Plans.c_id = Courses.c_id))));

-- 3
select distinct Students.s_id from Students, Lecturers, Marks, StudentGroups, Plans where
    Marks.s_id = Students.s_id and
    Marks.c_id = Plans.c_id and
    StudentGroups.s_id = Students.s_id and
    StudentGroups.g_id = Plans.g_id and
    Lecturers.l_id = Plans.l_id and
    Lecturers.l_name = "Korneev";

-- 4
select Students.s_id from Students where
    not exists (select * from Lecturers, Marks, StudentGroups, Plans where
        Marks.s_id = Students.s_id and
        Marks.c_id = Plans.c_id and
        StudentGroups.s_id = Students.s_id and
        StudentGroups.g_id = Plans.g_id and
        Lecturers.l_id = Plans.l_id and
        Lecturers.l_name = "Korneev");

-- 5
select Students.s_id from Students, Lecturers where
    Lecturers.l_name = "Stankevich" and
    not exists (select * from Marks, StudentGroups, Plans where
        not (not (StudentGroups.s_id = Students.s_id and
                StudentGroups.g_id = Plans.g_id and
                Lecturers.l_id = Plans.l_id) or
            (Marks.c_id = Plans.c_id and
                Marks.s_id = Students.s_id)));

-- 6
select Students.s_name, Courses.c_name from Students, Courses, StudentGroups, Plans where
    Students.s_id = StudentGroups.s_id and
    StudentGroups.g_id = Plans.g_id and
    Plans.c_id = Courses.c_id;

-- 7
select distinct Lecturers.l_name, Students.s_name from Students, Lecturers, StudentGroups, Plans where
    Students.s_id = StudentGroups.s_id and
    StudentGroups.g_id = Plans.g_id and
    Plans.l_id = Lecturers.l_id;

-- 8
select S1.s_id, S2.s_id
    from Students as S1, Students as S2 where
        not exists (select * from Marks as M1 where
            not (not S1.s_id = M1.s_id or
                (exists (select * from Marks as M2 where
                        S2.s_id = M2.s_id and M1.c_id = M2.c_id))));
