insert into Persons (PersonId, Name, Birthday) values
   (1, 'Toto Wolff', '12/Jan/1972'),
   (2, 'Lewis Hamilton', '7/Jan/1985'),
   (3, 'Christian Horner', '16/Nov/1973'),
   (4, 'Daniel Ricciardo', '1/Jul/1989'),
   (5, 'Max Verstappen', '30/Sep/1997'),
   (6, 'Maurizio Arrivabene', '7/Mar/1957'),
   (7, 'Sebastian Vettel', '3/Jul/1987'),
   (8, 'Kimi Räikkönen', '17/Oct/1979');

insert into Positions (PositionId, PositionName) values
   (1, 'Team Chief'),
   (2, 'First pilot'),
   (3, 'Second pilot');

insert into Teams (TeamId, TeamName, FoundationYear) values
   (1, 'Mercedes AMG Petronas Motorsport', '1/Jan/1970'),
   (2, 'Red Bull Racing', '1/Jan/1997'),
   (3, 'Scuderia Ferrari', '1/Jan/1950');

insert into TeamPositions (PersonId, PositionId, TeamId) values
   (1, 1, 1),
   (2, 2, 1),
   (3, 1, 2),
   (4, 2, 2),
   (5, 3, 2),
   (6, 1, 3),
   (7, 2, 3),
   (8, 3, 3);

insert into Sponsors (SponsorId, SponsorName) values
   (1, 'Shell'),
   (2, 'UPS'),
   (3, 'Red Bull'),
   (4, 'Petronas'),
   (5, 'Hugo Boss'),
   (6, 'Alfa Romeo'),
   (7, 'BMW'),
   (8, 'Mercedes');

insert into Racers (RacerId, RacerName, CupsWon, CareerStart, TeamId, SponsorId) values
   (1, 'Lewis Hamilton', 3, '18/Mar/2007', 1, 4),
   (2, 'Daniel Ricciardo', 0, '1/Dec/2009', 2, 3),
   (3, 'Max Verstappen', 0, '1/Aug/2014', 2, 3),
   (4, 'Sebastian Vettel', 4, '22/Oct/2006', 3, 1),
   (5, 'Kimi Räikkönen', 1, '1/Sep/2000', 3, 2);

insert into Races (RaceId, RaceName, Laps, RaceDate, TeamId, SponsorId, RacerId) values
   (1, 'Australian Grand Prix', 57, '20/Mar/2016', 1, 2, 1),
   (2, 'Bahrain Grand Prix', 57, '3/Apr/2016', 1, 7, 1),
   (3, 'Chinese Grand Prix', 56, '17/Apr/2016', 1, 5, 1),
   (4, 'Russian Grand Prix', 53, '11/Oct/2015', 1, 6, 1),
   (5, 'Spanish Grand Prix', 66, '10/May/2016', 1, 8, 1);

insert into TeamInRaces (TeamId, RaceId) values
   (1, 1),
   (2, 1),
   (3, 1),
   (1, 2),
   (2, 2),
   (3, 2),
   (1, 3),
   (2, 3),
   (3, 3),
   (1, 4),
   (2, 4),
   (3, 4),
   (1, 5),
   (2, 5),
   (3, 5);

insert into RaceParticipants (RaceId, RacerId) values
   (1, 1),
   (1, 2),
   (1, 3),
   (1, 4),
   (1, 5),
   (2, 1),
   (2, 2),
   (2, 3),
   (2, 4),
   (2, 5),
   (3, 1),
   (3, 2),
   (3, 3),
   (3, 4),
   (3, 5),
   (4, 1),
   (4, 2),
   (4, 3),
   (4, 4),
   (4, 5),
   (5, 1),
   (5, 2),
   (5, 3),
   (5, 4),
   (5, 5);

insert into Championships (ChampionshipId, ChampionshipName) values
   (1, 'Season 2016'),
   (2, 'Season 2015');

insert into RaceInChampionships (ChampionshipId, RaceId, RaceNumber) values
   (1, 1, 1),
   (1, 2, 2),
   (1, 3, 3),
   (2, 4, 15),
   (2, 5, 5);
