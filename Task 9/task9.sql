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

create table Tickets(
    FlightId int,
    PlaneId int not null,
    SeatNo int,
    BookingTime timestamp default current_timestamp on update current_timestamp,
    State enum ('Sold', 'Booked', 'Available'),
    primary key (FlightId, SeatNo));

alter table Flights add foreign key (PlaneId) references Planes (PlaneId) on delete cascade;
alter table Seats add foreign key (PlaneId) references Planes (PlaneId) on delete cascade;
alter table Tickets add foreign key (FlightId) references Flights (FlightId) on delete cascade;
alter table Tickets add foreign key (PlaneId, SeatNo) references Seats (PlaneId, SeatNo) on delete cascade;

delimiter //

-- (1) список мест, доступных для продажи и бронирования.
create procedure FreeSeats(flight_id int)
begin
    select SeatNo from (select * from (Flights natural join Seats natural join Tickets) where
            ((State = 'Available' and (FlightTime - current_timestamp >= interval '2 hours')) or
            (State = 'Booked' and ((FlightTime - current_timestamp < interval '1 day') or
            ((FlightTime - current_timestamp >= interval '1 day') and
            (current_timestamp - BookingTime < interval '1 day')))))) where
        FlightId = flight_id;
end//

-- (2) бронирование места. True - если удалось.
create function Reserve(flight_id int, seat_no int) returns boolean
begin
    if ((select count(*) from (select * from (Flights natural join Seats natural join Tickets) where
            ((State = 'Available' and (FlightTime - current_timestamp >= interval '1 day')) or
            (State = 'Booked' and (FlightTime - current_timestamp >= interval '1 day') and
            (current_timestamp - BookingTime >= interval '1 day')))) where
        FlightId = flight_id and SeatNo = seat_no) <> 0) then
        update Tickets set State = 'Booked' where
            FlightId = flight_id and SeatNo = seat_no;
        return true;
    else
        return false;
    end if;
end//

-- (3) продление брони места. True - если удалось.
create function ExtendReservation(flight_id int, seat_no int) returns boolean
begin
    if ((select count(*) from (select * from (Flights natural join Seats natural join Tickets) where
            (State = 'Booked' and (FlightTime - current_timestamp >= interval '1 day') and
            (current_timestamp - BookingTime < interval '1 day'))) where
        FlightId = flight_id and SeatNo = seat_no) <> 0) then
        update Tickets set BookingTime = current_timestamp where
            FlightId = flight_id and SeatNo = seat_no;
        return true;
    else
        return false;
    end if;
end//

-- (4) покупка свободного места. True - если удалось.
create function BuyFree(flight_id int, seat_no int) returns boolean
begin
    if ((select count(*) from (select * from (Flights natural join Seats natural join Tickets) where
            ((State = 'Available' and (FlightTime - current_timestamp >= interval '2 hours')) or
            (State = 'Booked' and (current_timestamp - BookingTime >= interval '1 day') and
            (FlightTime - current_timestamp >= interval '2 hours')))) where
        FlightId = flight_id and SeatNo = seat_no) <> 0) then
        update Tickets set State = 'Sold' where
            FlightId = flight_id and SeatNo = seat_no;
        return true;
    else
        return false;
    end if;
end//

-- (5) выкуп забронированного места. True - если удалось.
create function BuyReserved(flight_id int, seat_no int) returns boolean
begin
    if ((select count(*) from (select * from (Flights natural join Seats natural join Tickets) where
            (State = 'Booked' and (current_timestamp - BookingTime < interval '1 day') and
            (FlightTime - current_timestamp >= interval '1 day'))) where
        FlightId = flight_id and SeatNo = seat_no) <> 0) then
        update Tickets set State = 'Sold' where
            FlightId = flight_id and SeatNo = seat_no;
        return true;
    else
        return false;
    end if;
end//

-- (6) статистика по рейсам: возможность бронирования и покупки, число свободных, забронированных и
--     проданных мест.
create procedure FlightStatistics()
begin
    select FlightId as flight_id,
        ((select count(*) from (select * from (Flights natural join Seats natural join Tickets) where
                    ((State = 'Available' and (FlightTime - current_timestamp >= interval '1 day')) or
                    (State = 'Booked' and (current_timestamp - BookingTime >= interval '1 day') and
                    (FlightTime - current_timestamp >= interval '1 day')))) as Tmp where
                Tmp.FlightId = flight_id) <> 0),
        ((select count(*) from (select * from (Flights natural join Seats natural join Tickets) where
                    ((State = 'Available' and (FlightTime - current_timestamp >= interval '2 hours')) or
                    (State = 'Booked' and (current_timestamp - BookingTime < interval '1 day') and
                    (FlightTime - current_timestamp < interval '1 day')))) as Tmp where
                Tmp.FlightId = flight_id) <> 0),
        (select count(*) from (select * from (Flights natural join Seats natural join Tickets) where
                    ((State = 'Available') or (State = 'Booked' and
                    ((FlightTime - current_timestamp < interval '1 day') or
                    (current_timestamp - BookingTime >= interval '1 day'))))) as Tmp where
                Tmp.FlightId = flight_id),
        (select count(*) from (select * from (Flights natural join Seats natural join Tickets) where
                    (State = 'Booked' and (FlightTime - current_timestamp >= interval '1 day') and
                    (current_timestamp - BookingTime < interval '1 day'))) as Tmp where
                Tmp.FlightId = flight_id),
        (select count(*) from Tickets as Tmp where Tmp.FlightId = flight_id and Tmp.State = 'Sold')
    from Flights;
end//

-- (7) оптимизация занятости мест в самолете. В начале самолета - выкупленные места, затем - забронированные,
--     а в конце - свободные.
create procedure CompressSeats(flight_id int)
begin
    declare n int default 0;
    declare currentSeatNo int default 0;
    declare i int default 0;
    select count(*) from Tickets into n;
    create table TmpTickets(
        FlightId int,
        PlaneId int not null,
        SeatNo int,
        BookingTime timestamp default current_timestamp on update current_timestamp,
        State enum ('Sold', 'Booked', 'Available'),
        primary key (FlightId, SeatNo));

    while (i < n) do
        if ((select count(*) from Tickets where FlightId = flight_id and State = 'Sold' limit i, 1) <> 0) then
            set currentSeatNo = currentSeatNo + 1;
        end if;

        insert into TmpTickets (FlightId, PlaneId, SeatNo, BookingTime, State)
            values (FlightId, PlaneId, currentSeatNo, BookingTime, State) from Tickets where
            FlightId = flight_id and State = 'Sold' limit i, 1;
        set i = i + 1;
    end while;

    set i = 0;

    while (i < n) do
        if ((select count(*) from Tickets where FlightId = flight_id and State = 'Booked' limit i, 1) <> 0) then
            set currentSeatNo = currentSeatNo + 1;
        end if;

        insert into TmpTickets (FlightId, PlaneId, SeatNo, BookingTime, State)
            values (FlightId, PlaneId, currentSeatNo, BookingTime, State) from Tickets where
            FlightId = flight_id and State = 'Booked' limit i, 1;
        set i = i + 1;
    end while;

    set i = 0;

    while (i < n) do
        if ((select count(*) from Tickets where FlightId = flight_id and State = 'Available' limit i, 1) <> 0) then
            set currentSeatNo = currentSeatNo + 1;
        end if;

        insert into TmpTickets (FlightId, PlaneId, SeatNo, BookingTime, State)
            values (FlightId, PlaneId, currentSeatNo, BookingTime, State) from Tickets where
            FlightId = flight_id and State = 'Available' limit i, 1;
        set i = i + 1;
    end while;

    delete from Tickets where FlightId = flight_id;

    set i = 0;
    select count(*) from TmpTickets into n;

    while (i < n) do
        insert into Tickets (FlightId, PlaneId, SeatNo, BookingTime, State)
            values (FlightId, PlaneId, currentSeatNo, BookingTime, State) from TmpTickets limit i, 1;
        set i = i + 1;
    end while;

    drop table TmpTickets;
end//

delimiter ;
