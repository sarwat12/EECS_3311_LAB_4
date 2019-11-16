SET search_path TO A2;
-- Add below your SQL statements. 
-- For each of the queries below, your final statement should populate the respective answer table (queryX) with the correct tuples. It should look something like:
-- INSERT INTO queryX (SELECT … <complete your SQL query here> …)
-- where X is the correct index [1, …,10].
-- You can create intermediate views (as needed). Remember to drop these views after you have populated the result tables query1, query2, ...
-- You can use the "\i a2.sql" command in psql to execute the SQL commands in this file.
-- Good Luck!

--Query 1 statements
INSERT INTO query1(select pname, cname, tname
from country co, player p, tournament t, champion c
where p.cid = t.cid and c.tid = t.tid and  c.pid = p.pid and p.cid = co.cid order by pname asc

);

--Query 2 statements
INSERT INTO query2(select tname, capacity as totalCapacity
from court c, tournament t
where c.tid=t.tid and c.capacity >= all(select capacity from court c) order by tname asc
);

--Query 3 statements
--INSERT INTO query3

--Query 4 statements
INSERT INTO query4( select distinct(p.pid), pname from player p, champion c
where p.pid = (select distinct x.pid
from champion as x
where not exists(
select y.tid
from tournament as y
where not exists (
select z.pid
from champion as z
where (z.pid = x.pid)
and (z.tid = y.tid)))
) order by pname asc
);
table query4;

--Query 5 statements
INSERT INTO query5(select p.pid, pname, sum(wins)/count(year) as avgwins
from record r, player p
where year<=2014 and year > 2010 and r.pid = p.pid
group by p.pid
order by avgwins desc
limit 10
);

--Query 6 statements

create view wins as
select r1.pid, r1.year, r1.wins
from record r1, record r2
where r1.pid = r2.pid and r1.year > 2010 and r1.year <=2014 and r1.year = r2.year + 1 
and r1.wins > r2.wins;

create view a2 as 
select r1.pid, count(r1.year)
from record r1                                                                                              
group by r1.pid                                                                                             
having count(r1.year) = 3;

create view four as 
select r.pid, p.pname
from a2 , record r, player p
where a2.pid = r.pid and r.pid = p.pid;

INSERT INTO query6(
select distinct(pid), pname from four order by pname asc
);

drop view four;
drop view a2;
drop view wins;

--Query 7 statements
--INSERT INTO query7

--Query 8 statements
--INSERT INTO query8

--Query 9 statements 
create view highest_records as
select pid, count(tid) as champions
from champion
group by pid
order by count(tid) desc
limit 1;

create view origin as
select c.cname, h.champions
from player p, country c, highest_records h
where h.pid = p.pid and p.cid = c.cid;

INSERT INTO query9(select * from origin order by cname desc
);

drop view origin;
drop view highest_records;


--Query 10 statements
create view rec2014 as 
select* from record where year = 2014 and wins > losses;

create view played as
select r.pid, avg(e.duration)
from rec2014 r, event e
where r.pid = winid or r.pid =lossid 
group by r.pid, e.duration 
having avg(e.duration) >200;


INSERT INTO query10(select p.pname 
from player p, played pl
where pl.pid = p.pid
order by pname desc);

drop view played;
drop view rec2014;


