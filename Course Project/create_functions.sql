create function GetRacersInRace(race_id int) returns table(racer_id int) as $$
begin
    return query (select Racers.RacerId as racer_id from Racers where
        exists (select * from RaceParticipants where RaceParticipants.RacerId = Racers.RacerId and RaceParticipants.RaceId = race_id));
end;
$$ language plpgsql;

create function GetRacerNamesInRace(race_id int) returns table(racer_name varchar) as $$
begin
    return query (select Racers.RacerName as racer_name from Racers where
        exists (select * from RaceParticipants where RaceParticipants.RacerId = Racers.RacerId and RaceParticipants.RaceId = race_id));
end;
$$ language plpgsql;

create function GetRacerNamesInTeam(team_id int) returns table(racer_name varchar) as $$
begin
    return query (select Racers.RacerName as racer_name from Racers where
        exists (select * from Teams where Teams.TeamId = Racers.TeamId and Teams.TeamId = team_id));
end;
$$ language plpgsql;

create materialized view OccupiedPositionsInTeams as
    select Persons.Name, Positions.PositionName, Teams.TeamName from
        (Persons natural join Positions natural join Teams natural join TeamPositions);

create function update_occupied_positions_in_teams() returns trigger as $$
begin
    refresh materialized view OccupiedPositionsInTeams;
    return NEW;
end;
$$ language plpgsql;

create trigger OccupiedPositionsInTeamsUpdater after insert or update or delete on TeamPositions
    for each statement execute procedure update_occupied_positions_in_teams();
