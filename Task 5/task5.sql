drop database if exists deanery_5;
create database deanery_5;
use deanery_5;

create table Students(
    s_id int primary key,
    s_name varchar(200)) default charset='utf8';

create table Groups(
    g_id int primary key,
    g_name varchar(5)) default charset='utf8';

create table Courses(
    c_id int primary key,
    c_name varchar(50)) default charset='utf8';

create table Lecturers(
    l_id int primary key,
    l_name varchar(200)) default charset='utf8';

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

create table StudentGroups(
    s_id int primary key,
    g_id int) default charset='utf8';

insert into Students (s_id, s_name) values
    (1, "Иванов Иван"),
    (2, "Петров Петр"),
    (3, "Сидоров Сидор"),
    (4, "Романов Александр"),
    (5, "Федоров Федор");

insert into Groups (g_id, g_name) values
    (1, "M3437"),
    (2, "M3438"),
    (3, "M3439");

insert into Courses (c_id, c_name) values
    (1, "Технологии программирования"),
    (2, "Базы данных"),
    (3, "Параллельное программирование");

insert into Lecturers (l_id, l_name) values
    (1, "Корнеев Георгий Александрович"),
    (2, "Елизаров Роман Анатольевич");

insert into StudentGroups (s_id, g_id) values
    (1, 1),
    (2, 2),
    (3, 2),
    (4, 3),
    (5, 3);

insert into Plans (g_id, c_id, l_id) values
    (1, 1, 1),
    (1, 2, 1),
    (2, 1, 1),
    (2, 2, 1),
    (3, 1, 1),
    (3, 3, 2);

insert into Marks (s_id, c_id, mark) values
    (1, 1, 'C'),
    (1, 2, 'A'),
    (2, 2, 'B'),
    (4, 3, 'A'),
    (5, 3, 'C');

-- (1) студенты с заданной оценкой по базам данных
select s_name from Students
    natural join Courses
    natural join Marks
    where
        c_name = "Базы данных" and
        mark = 'B';

-- (2a) студенты, не имеющие оценки по базам данных, среди всех студентов
select Students.s_name from Students
    left join
        (select s_id, s_name from Students
            natural join Courses
            natural join Marks
            where
                c_name = "Базы данных") as Tmp
        on Students.s_id = Tmp.s_id
    where Tmp.s_id is null;

-- (2b) студенты, не имеющие оценки по базам данных, среди тех, у которых есть данный предмет
select Tmp.s_name from
    (select s_id, s_name from Students
        natural join Courses
        natural join Plans
        natural join StudentGroups
        where
            c_name = "Базы данных") as Tmp
    left join
        (select s_id, s_name from Students
            natural join Courses
            natural join Marks
            where
                c_name = "Базы данных") as Tmp2
        on Tmp.s_id = Tmp2.s_id
    where Tmp2.s_id is null;

-- (3) студенты, имеющие хотя бы одну оценку у заданного лектора
select distinct s_name from Students
    natural join Lecturers
    natural join Plans
    natural join Marks
    natural join StudentGroups
    where
        l_name = "Корнеев Георгий Александрович";

-- (4) идентификаторы студентов, не имеющий ни одной оценки у заданного лектора
select Students.s_id from Students
    left join
        (select s_id, s_name from Students
            natural join Lecturers
            natural join Plans
            natural join Marks
            natural join StudentGroups
            where
                l_name = "Корнеев Георгий Александрович") as Tmp
        on Students.s_id = Tmp.s_id
    where Tmp.s_id is null;

-- (5) студенты, имеющие оценки по всем предметам заданного лектора
select distinct Tmp.s_id from
    (select distinct s_id from Lecturers
        natural join Marks
        natural join Plans
        where
            l_name = "Корнеев Георгий Александрович") as Tmp
    left join
        (select distinct InnerTmp.s_id from
            (select distinct s_id from Lecturers
                natural join Marks
                natural join Plans
                where
                    l_name = "Корнеев Георгий Александрович") as InnerTmp
            cross join
                (select distinct c_id from Lecturers
                    natural join Plans
                    where
                        l_name = "Корнеев Георгий Александрович") as InnerTmp2
                left join
                    (select distinct s_id, c_id from Lecturers
                        natural join Marks
                        natural join Plans
                        where
                            l_name = "Корнеев Георгий Александрович") as InnerTmp3
                on InnerTmp.s_id = InnerTmp3.s_id and InnerTmp2.c_id = InnerTmp3.c_id
            where InnerTmp3.s_id is null) as Tmp2
        on Tmp.s_id = Tmp2.s_id
    where Tmp2.s_id is null;

-- (6) для каждого студента имя и предметы, которые он должен посещать
select s_name, c_name from Students
    natural join Courses
    natural join Plans
    natural join StudentGroups;

-- (7) по лектору всех студентов, у которых он хоть что-нибудь преподавал
select distinct l_name, s_name from Lecturers
    natural join Students
    natural join Plans
    natural join StudentGroups;
