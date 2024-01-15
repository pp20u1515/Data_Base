drop database rk2

create table animal(
	animalID int primary key,
	animal_type varchar(100),
	animal_family varchar(100),
	nickname varchar(100)
);

create table sickness(
	sicknessID int primary key,
	sickness_name varchar(100),
	sympthoms varchar(100),
	sickness_analyze varchar(100)
);

create table owners(
	fioID int primary key,
	fio varchar(100),
	adress varchar(100),
	phone varchar(100)
);

create table animal_owner(
	ownerID int,
	animal_ID int,
	foreign key(ownerID) references owners(fioID) on delete cascade,
	foreign key(animal_ID) references animal(animalID) on delete cascade
);

create table animal_sickness(
	animal_ID int,
	sickness_ID int,
	foreign key(animal_ID) references animal(animalID) on delete cascade,
	foreign key(sickness_ID) references sickness(sicknessID)
);

copy animal from 'C:\msys64\home\pante\pp20u1515\Data_Base\rk1\animal.csv' delimiter ';' csv header;
copy sickness from 'C:\msys64\home\pante\pp20u1515\Data_Base\rk1\sickness.csv' delimiter ';' csv header;

select animalID, case
					when animal_type = 'dog' then true
					else false
					end as animal_type
from animal;	

select a.animalID, a.nickname, a.animal_type, s.sickness_name, 
row_number() over (partition by a.animalID order by s.sicknessID) as sickness_order
from animal a
join animal_sickness sa on a.animalID = sa.animal_ID
JOIN sickness s ON sa.sickness_ID = s.sicknessID
JOIN animal_owner oa ON a.animalID = oa.animal_ID
order by a.animalID, sickness_order;

select animal_type, count(*) as count
from animal
group by animal_type
having animal_type like '%e%';


						


