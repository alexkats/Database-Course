create function check_racer_career_start() returns trigger as $$
declare
    team Teams%ROWTYPE;
begin
    select * into team from Teams where Teams.TeamId = NEW.TeamId;

    if (team.FoundationYear > NEW.CareerStart) then
        raise exception 'Racer career start at <<%>> can not be after team foundation at <<%>>', NEW.CareerStart, team.FoundationYear;
    end if;
    
    return NEW;
end;
$$ language plpgsql;

create trigger RacerCareerStartTrigger after insert or update on Racers
    for each row execute procedure check_racer_career_start();

create function check_race_participant() returns trigger as $$
declare
    racer Racers%ROWTYPE;
    race Races%ROWTYPE;
begin
    select * into racer from Racers where Racers.RacerId = NEW.RacerId;
    select * into race from Races where Races.RaceId = NEW.RaceId;

    if (racer.CareerStart > race.RaceDate) then
        raise exception 'Racer career start at <<%>> can not be after race date at <<%>>', racer.CareerStart, race.RaceDate;
    end if;

    return NEW;
end;
$$ language plpgsql;

create trigger RaceParticipantTrigger after insert or update on RaceParticipants
    for each row execute procedure check_race_participant();

create function check_team_in_race() returns trigger as $$
declare
    team Teams%ROWTYPE;
    race Races%ROWTYPE;
begin
    select * into team from Teams where Teams.TeamId = NEW.TeamId;
    select * into race from Races where Races.RaceId = NEW.RaceId;

    if (team.FoundationYear > race.RaceDate) then
        raise exception 'Team foundation at <<%>> can not be after race date at <<%>>', team.FoundationYear, race.RaceDate;
    end if;

    return NEW;
end;
$$ language plpgsql;

create trigger TeamInRaceTrigger after insert or update on TeamInRaces
    for each row execute procedure check_team_in_race();

create function check_cups_won() returns trigger as $$
begin
    if ((select count(*) from RaceParticipants where RaceParticipants.RacerId = NEW.RacerId) < NEW.CupsWon) then
        raise exception 'Number of cups won (<<%>>) can not be more than races count', NEW.CupsWon;
    end if;

    return NEW;
end;
$$ language plpgsql;

create trigger CupsWonTrigger after insert or update on Racers
    for each row execute procedure check_cups_won();

create function check_person_birthday() returns trigger as $$
begin
    if (NEW.birthday > current_date) then
        raise exception 'Person birthday can not be after today';
    end if;

    return NEW;
end;
$$ language plpgsql;

create trigger PersonBirthdayTrigger after insert or update on Persons
    for each row execute procedure check_person_birthday();
