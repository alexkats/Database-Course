drop database if exists University;
create database University;
use University;

create table Students(
    s_id int primary key,
    s_name varchar(200));

create table Groups(
    g_id int primary key,
    g_name varchar(5));

create table Lecturers(
    l_id int primary key,
    l_name varchar(200));

create table Courses(
    c_id int primary key,
    c_name varchar(100));

create table StudentGroups(
    s_id int primary key,
    g_id int);

create table Marks(
    s_id int,
    c_id int,
    mark int,
    primary key (s_id, c_id));

create table Plans(
    g_id int,
    c_id int,
    primary key (g_id, c_id));


