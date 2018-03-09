drop database if exists Airline;
create database Airline;
use Airline;

create table Flights(
    FlightId int primary key,
    FlightTime timestamp default current_timestamp,
    PlaneId int not null);

create table Seats(
    PlaneId int,
    SeatNo int,
    primary key (PlaneId, SeatNo));

create table Planes(
    PlaneId int primary key);

create table Passengers(
    PassengerId int primary key);

create table Tickets(
    FlightId int,
    PassengerId int not null,
    PlaneId int not null,
    SeatNo int,
    BookingTime timestamp default current_timestamp on update current_timestamp,
    State enum ('Sold', 'Booked', 'Available'),
    primary key (FlightId, SeatNo));

alter table Flights add foreign key (PlaneId) references Planes (PlaneId) on delete cascade;
alter table Seats add foreign key (PlaneId) references Planes (PlaneId) on delete cascade;
alter table Tickets add foreign key (FlightId) references Flights (FlightId) on delete cascade;
alter table Tickets add foreign key (PassengerId) references Passengers (PassengerId) on delete cascade;
alter table Tickets add foreign key (PlaneId, SeatNo) references Seats (PlaneId, SeatNo) on delete cascade;

delimiter //

create procedure updateBookings()
begin
    update Tickets, Flights set Tickets.State = 'Available' where
        (((current_timestamp - Tickets.BookingTime >= interval '1 day') or
        (Flights.FlightTime - current_timestamp < interval '1 day')) and
        (Tickets.State = 'Booked'));
end//

delimiter ;

create trigger BookingTrigger before insert or update or delete on Tickets
    for each row call updateBookings();

delimiter ;

create index FlightIdsByFlightTime on Flights(FlightTime);
create index PlaneIdsByFlightTime on Flights(PlaneId);
create index StateByFlightIds on Tickets(FlightId);
create index SeatNosByFlightId on Tickets(FlightId);
create index SeatNosByFlightIdAndState on Tickets(FlightId, State);
