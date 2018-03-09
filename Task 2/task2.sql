drop database if exists deanery;
create database deanery;
use deanery;

create table Students(
    id int not null primary key,
    full_name varchar(200) not null,
    document varchar(50) not null,
    birthday date not null,
    phone varchar(30),
    group_id int not null) default charset='utf8';

create table Lecturers(
    id int not null primary key,
    full_name varchar(200) not null,
    document varchar(50) not null,
    birthday date not null,
    phone varchar(30)) default charset='utf8';

create table Groups(
    id int not null,
    name varchar(20) not null,
    course_id int not null,
    primary key (id, course_id)) default charset='utf8';

create table Courses(
    id int not null primary key,
    name varchar(200) not null,
    lecturer_id int not null) default charset='utf8';

create table Marks(
    mark char not null,
    course_id int not null,
    student_id int not null,
    primary key (course_id, student_id)) default charset='utf8';

create table Study_Plans(
    course_id int not null,
    group_id int not null,
    primary key (course_id, group_id)) default charset='utf8';

alter table Students add foreign key (group_id) references Groups (id);
alter table Marks add foreign key (course_id) references Courses (id);
alter table Marks add foreign key (student_id) references Students (id);
alter table Study_Plans add foreign key (group_id) references Groups (id);
alter table Study_Plans add foreign key (course_id) references Courses (id);
alter table Groups add foreign key (id, course_id) references Study_Plans (group_id, course_id);
alter table Courses add foreign key (lecturer_id) references Lecturers (id);

insert into Lecturers (id, full_name, document, birthday, phone) values
    (1, "Корнеев Георгий Александрович", "4023 320521", "1980-01-01", "+71230001234"),
    (2, "Станкевич Андрей Сергеевич", "4012 243193", "1978-03-12", "+934013434"),
    (3, "Елизаров Роман Анатольевич", "4009 434013", "1976-09-21", "+0843913734");

insert into Courses (id, name, lecturer_id) values
    (1, "Технологии Программирования", 1),
    (2, "Базы Данных", 1),
    (3, "Дискретная Математика", 2),
    (4, "Алгоритмы и Структуры Данных", 2),
    (5, "Теория Формальных Языков", 2),
    (6, "Параллельное Программирование", 3),
    (7, "Распределенные Системы", 3);

alter table Groups drop foreign key groups_ibfk_1;

insert into Groups (id, name, course_id) values
    (1, "M3436", 1),
    (1, "M3436", 2),
    (1, "M3436", 3),
    (1, "M3436", 4),
    (1, "M3436", 6),
    (2, "M3437", 1),
    (2, "M3437", 2),
    (2, "M3437", 3),
    (2, "M3437", 4),
    (2, "M3437", 6),
    (3, "M3438", 1),
    (3, "M3438", 2),
    (3, "M3438", 3),
    (3, "M3438", 4),
    (3, "M3438", 5),
    (3, "M3438", 6),
    (3, "M3438", 7),
    (4, "M3439", 1),
    (4, "M3439", 2),
    (4, "M3439", 3),
    (4, "M3439", 4),
    (4, "M3439", 5),
    (4, "M3439", 6),
    (4, "M3439", 7);

insert into Study_Plans (course_id, group_id) values
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (2, 1),
    (2, 2),
    (2, 3),
    (2, 4),
    (3, 1),
    (3, 2),
    (3, 3),
    (3, 4),
    (4, 1),
    (4, 2),
    (4, 3),
    (4, 4),
    (5, 3),
    (5, 4),
    (6, 1),
    (6, 2),
    (6, 3),
    (6, 4),
    (7, 3),
    (7, 4);

alter table Groups add foreign key (id, course_id) references Study_Plans (group_id, course_id);

insert into Students (id, full_name, document, birthday, phone, group_id) values
    (1, "Иванов Иван", "4034 240137", "1996-01-01", "+79231035840", 1),
    (2, "Иванов Петр", "4023 210458", "1995-04-12", "+83435497594", 1),
    (3, "Петров Иван", "2302 383052", "1994-12-12", "+02483401424", 2),
    (4, "Федоров Петр", "231 340394", "1995-04-29", "+38944578454", 3),
    (5, "Федоров Сидор", "235 45401", "1997-01-23", "+09457783454", 3),
    (6, "Сидоров Федов", "23 237532", "1993-07-29", "+89347845401", 3),
    (7, "Петров Сидор", "2383 38943", "1998-02-27", "+89376946594", 4);

insert into Marks (mark, course_id, student_id) values
    ("A", 1, 1),
    ("A", 2, 1),
    ("C", 3, 1),
    ("C", 4, 1),
    ("C", 6, 1),
    ("C", 1, 2),
    ("E", 2, 2),
    ("E", 3, 2),
    ("E", 4, 2),
    ("D", 6, 2),
    ("A", 1, 3),
    ("A", 2, 3),
    ("A", 3, 3),
    ("A", 4, 3),
    ("A", 6, 3),
    ("A", 1, 4),
    ("A", 2, 4),
    ("A", 3, 4),
    ("A", 4, 4),
    ("A", 5, 4),
    ("A", 6, 4),
    ("B", 7, 4),
    ("C", 1, 5),
    ("C", 2, 5),
    ("D", 3, 5),
    ("D", 4, 5),
    ("D", 5, 5),
    ("D", 6, 5),
    ("B", 7, 5),
    ("D", 1, 6),
    ("D", 2, 6),
    ("D", 3, 6),
    ("D", 4, 6),
    ("D", 5, 6),
    ("D", 6, 6),
    ("A", 7, 6),
    ("A", 1, 7),
    ("A", 2, 7),
    ("A", 3, 7),
    ("A", 4, 7),
    ("A", 5, 7),
    ("A", 6, 7),
    ("A", 7, 7);
