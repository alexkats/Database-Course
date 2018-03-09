drop database if exists formula1;
create database formula1;
\c formula1;

create table Persons(
    PersonId int primary key,
    Name varchar(200) not null,
    Birthday date not null,
    Phone varchar(30));

create table Positions(
    PositionId int primary key,
    PositionName varchar(50) not null);

create table TeamPositions(
    PersonId int,
    PositionId int,
    TeamId int,
    primary key (PersonId, PositionId, TeamId));

create table Teams(
    TeamId int primary key,
    TeamName varchar(200) not null,
    FoundationYear date not null);

create table Racers(
    RacerId int primary key,
    RacerName varchar(200) not null,
    CupsWon int,
    CareerStart date not null,
    TeamId int not null,
    SponsorId int not null);

create table Races(
    RaceId int primary key,
    RaceName varchar(100) not null,
    Laps int not null,
    Crashes int,
    RaceDate date not null,
    TeamId int not null,
    SponsorId int not null,
    RacerId int not null);

create table RaceParticipants(
    RaceId int,
    RacerId int,
    primary key (RaceId, RacerId));

create table TeamInRaces(
    TeamId int,
    RaceId int,
    primary key (TeamId, RaceId));

create table Championships(
    ChampionshipId int primary key,
    ChampionshipName varchar(100) not null,
    unique (ChampionshipName));

create table RaceInChampionships(
    ChampionshipId int,
    RaceId int,
    RaceNumber int,
    primary key (ChampionshipId, RaceId));

create table Sponsors(
    SponsorId int primary key,
    SponsorName varchar(200) not null);
