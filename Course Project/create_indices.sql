create index RacesByDate on Races(RaceDate);
create index TeamsByFoundationYear on Teams(FoundationYear);
create index PersonsByBirthday on Persons(Birthday);
create index RacersByCareerStart on Racers(CareerStart);

-- К этим индексам добавляются индексы по primary key, по умолчанию в postgresql
