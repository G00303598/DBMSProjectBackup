Drop database if exists Mulcahy_Dental;
create database Mulcahy_Dental default CHARACTER SET = utf8 default COLLATE = utf8_general_ci;
use Mulcahy_Dental;

create table Patient
(
	ppsn varchar(8),
	
	first_name varchar(18) not null,
	last_name varchar(20) not null,
	phone_number integer(20) not null,
	dob date not null,
	addr_line1 varchar(50) not null,
	addr_line2 varchar(50),
	county varchar(10) not null,
	
	primary key (ppsn)
) Engine = INNODB;

create table Appointment
(
	ppsn varchar(8) not null,
	aptmnt_date_time DATETIME not null,
	last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	primary key (aptmnt_date_time),
	foreign key (ppsn) references Patient(ppsn)
) Engine = INNODB;

create table treatment
(
	trtmnt_id INTEGER(4) unsigned zerofill not null auto_increment,
	ppsn varchar(8) not null,
	aptmnt_date_time DATETIME not null,
	treatment_type SET ('Bonding', 'Braces', 'Bridge Work', 'Implant', 'Crown', 'Cap', 'Dentures', 'Extractions', 'Filling', 'Repair', 'Gum Sugery', 'Oral Cancer Examination', 'Root Canal', 'Sealant', 'Teeth Whitening', 'Veneer') not null,
	treatment_cost decimal(6,2) not null,
	
	primary key (trtmnt_id),
	foreign key (aptmnt_date_time) references Appointment(aptmnt_date_time),
	foreign key (ppsn) references Patient(ppsn)	
)Engine = INNODB;

create table specialist
(
	specialist_id INTEGER(3) zerofill not null auto_increment,
	trtmnt_id INTEGER(3) zerofill not null,
	foreign key (ppsn) references Patient(ppsn),
	ppsn varchar(8) not null,
	
	primary key (specialist_id),
	foreign key (trtmnt_id) references treatment(trtmnt_id),
	foreign key (ppsn) references Patient(ppsn)	
)Engine = INNODB;

create table bill
(
	bill_id integer(3) auto_increment,
	ppsn varchar(8) not null,
	cancellation_fee decimal(4,2),
	treatment_fee decimal(10,2),
	
	primary key (bill_id),
	foreign key (ppsn) references Patient(ppsn)
)Engine = INNODB;

create table payment
(
	payment_id INTEGER(3) zerofill not null auto_increment,
	ppsn varchar(8) not null,
	paid_by ENUM ('CASH', 'CREDIT CARD', 'DEBIT CARD', 'CHEQUE'),
	
	primary key (payment_id),
	foreign key (ppsn) references Patient(ppsn)
)Engine = INNODB;


# case 1.0: Robert - New patient - no special treatment
select * from patient where ppsn = '9934478A';
insert into patient(ppsn, first_name, last_name, phone_number, dob, addr_line1, addr_line2, county) values ('9934478A', 'Robert', 'Robson', 0861119072, '1976-03-20', '12 Gael Carrig', 'Newcastle', 'Galway');
select * from patient where ppsn = '9934478A';
select ptnt.ppsn, ptnt.last_name, ptnt.first_name, apt.aptmnt_date_time, apt.last_update from patient ptnt inner join appointment apt on ptnt.ppsn = apt.ppsn;
insert into appointment(ppsn, aptmnt_date_time) values ('9934478A', '2019-03-20 12:00:00');
select ptnt.ppsn, ptnt.last_name, ptnt.first_name, apt.aptmnt_date_time, apt.last_update from patient ptnt inner join appointment apt on ptnt.ppsn = apt.ppsn where ptnt.ppsn = '9934478A';

# case 1.1: Robert would like to rearrange time to two hours later
select ptnt.ppsn, ptnt.last_name, ptnt.first_name, apt.aptmnt_date_time, apt.last_update from patient ptnt inner join appointment apt on ptnt.ppsn = apt.ppsn;
update appointment set aptmnt_date_time = '2019-03-01 14:00:00' where ppsn = '9934478A';


# case 2.0: Claire - New patient - no special treatment - cancels
select * from patient where ppsn = '3726645C';
insert into patient(ppsn, first_name, last_name, phone_number, dob, addr_line1, addr_line2, county) values ('3726645C', 'Claire', 'MacManus', 0871199083, '1993-09-11', '12 Woodlawn Park', 'Salthill Estate', 'Galway');
select * from patient where ppsn = '3726645C';
select ptnt.ppsn, ptnt.last_name, ptnt.first_name, apt.aptmnt_date_time, apt.last_update from patient ptnt inner join appointment apt on ptnt.ppsn = apt.ppsn;
insert into appointment(ppsn, aptmnt_date_time) values ('3726645C', '2019-03-20 12:00:00');
select ptnt.ppsn, ptnt.last_name, ptnt.first_name, apt.aptmnt_date_time, apt.last_update from patient ptnt inner join appointment apt on ptnt.ppsn = apt.ppsn where apt.ppsn = '3726645C';
# delete and verfy, then bill account
select ptnt.ppsn, ptnt.last_name, ptnt.first_name, apt.aptmnt_date_time, apt.last_update from patient ptnt inner join appointment apt on ptnt.ppsn = apt.ppsn;
delete from appointment where aptmnt_date_time = '2019-03-20 12:00:00';
select ptnt.ppsn, ptnt.last_name, ptnt.first_name, apt.aptmnt_date_time, apt.last_update from patient ptnt inner join appointment apt on ptnt.ppsn = apt.ppsn;

select * from bill;
insert into bill (ppsn, cancellation_fee) values ('3726645C', 10.0);
select ptnt.ppsn, ptnt.last_name, ptnt.first_name, b.cancellation_fee, b.treatment_fee from patient ptnt inner join bill b on ptnt.ppsn = b.ppsn;


# case 3.0: Mike - Old Patient, owes E1800 
insert into patient(ppsn, first_name, last_name, phone_number, dob, addr_line1, addr_line2, county) values ('7746623A', 'Mike', 'ODOnnel', 0877776575, '1956-05-04', 'Cill Creag House', 'OutofTown Lane', 'Cork');

insert into appointment(ppsn, aptmnt_date_time) values ('7746623A', '2018-01-20 12:00:00');
insert into appointment(ppsn, aptmnt_date_time) values ('7746623A', '2018-03-20 12:00:00');
insert into appointment(ppsn, aptmnt_date_time) values ('7746623A', '2018-05-20 12:00:00');
insert into appointment(ppsn, aptmnt_date_time) values ('7746623A', '2018-07-20 12:00:00');
insert into appointment(ppsn, aptmnt_date_time) values ('7746623A', '2018-09-20 12:00:00');
insert into appointment(ppsn, aptmnt_date_time) values ('7746623A', '2018-11-20 12:00:00');

insert into treatment(ppsn, aptmnt_date_time , treatment_type, treatment_cost) values ('7746623A','2018-01-20 12:00:00', 'Filling', 100.00);
insert into treatment(ppsn, aptmnt_date_time , treatment_type, treatment_cost) values ('7746623A','2018-03-20 12:00:00', 'Repair', 200.00);
insert into treatment(ppsn, aptmnt_date_time , treatment_type, treatment_cost) values ('7746623A','2018-05-20 12:00:00', 'Filling', 100.00);
insert into treatment(ppsn, aptmnt_date_time , treatment_type, treatment_cost) values ('7746623A','2018-07-20 12:00:00', 'Oral Cancer Examination', 200.00);
insert into treatment(ppsn, aptmnt_date_time , treatment_type, treatment_cost) values ('7746623A','2018-09-20 12:00:00', 'Repair', 200.00);
insert into treatment(ppsn, aptmnt_date_time , treatment_type, treatment_cost) values ('7746623A','2018-11-20 12:00:00', 'Root Canal', 1000.00);
select ppsn, sum(treatment_cost) from treatment where ppsn = '7746623A';
insert into bill (ppsn, treatment_fee) values ('7746623A', 1800.00);
select p.ppsn, p.last_name, p.first_name, b.cancellation_fee, b.treatment_fee from patient p inner join bill b on p.ppsn = b.ppsn where p.ppsn = '7746623A';


# case 4.0: Tuesday Morning check
# 2 appointment inserts 2 verify working check
insert into appointment(ppsn, aptmnt_date_time) values ('3726645C', '2019-03-08');
insert into appointment(ppsn, aptmnt_date_time) values ('9934478A', '2019-03-09');

# weekly check -- assume start date of check is 2019-03-03
select p.ppsn, p.last_name, p.first_name, a.aptmnt_date_time from appointment a inner join patient p on p.ppsn = a.ppsn where a.aptmnt_date_time between '2019-03-03 00:00:00' and '2019-03-10 00:00:00';

# bill check
select p.ppsn, p.last_name, p.first_name,p.addr_line1,p.addr_line2, p.county, b.cancellation_fee, b.treatment_fee from patient p inner join bill b on p.ppsn = b.ppsn;

# treatment check

