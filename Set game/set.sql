-- https://habr.com/ru/post/455634/

-- drop table test_set;

create table test_set (
  id number,
  t1 number,
  t2 number,
  t3 number,
  t4 number
);
/*
t1 фигура ::= эллипс | ромб | «сопля»
t2 цвет ::= красный | зелёный | фиолетовый
t3 заливка ::= белая | полосатая | сплошная
t4 количество ::= 1 | 2 | 3
*/
insert into test_set (t1, t2, t3, t4) values (1, 2, 3, 1);
insert into test_set (t1, t2, t3, t4) values (1, 2, 3, 2);
insert into test_set (t1, t2, t3, t4) values (2, 2, 3, 3);
insert into test_set (t1, t2, t3, t4) values (3, 2, 3, 3);

insert into test_set (t1, t2, t3, t4) values (2, 2, 2, 1);
insert into test_set (t1, t2, t3, t4) values (1, 2, 2, 1);
insert into test_set (t1, t2, t3, t4) values (2, 2, 2, 2);
insert into test_set (t1, t2, t3, t4) values (1, 2, 2, 2);

insert into test_set (t1, t2, t3, t4) values (2, 2, 1, 3);
insert into test_set (t1, t2, t3, t4) values (1, 3, 3, 1);
insert into test_set (t1, t2, t3, t4) values (3, 3, 3, 2);
insert into test_set (t1, t2, t3, t4) values (1, 3, 3, 2);

insert into test_set (t1, t2, t3, t4) values (3, 1, 3, 3);
insert into test_set (t1, t2, t3, t4) values (1, 3, 2, 2);
insert into test_set (t1, t2, t3, t4) values (3, 3, 2, 3);
insert into test_set (t1, t2, t3, t4) values (2, 3, 2, 3);

insert into test_set (t1, t2, t3, t4) values (1, 3, 2, 1);
insert into test_set (t1, t2, t3, t4) values (3, 3, 3, 1);
insert into test_set (t1, t2, t3, t4) values (3, 3, 1, 3);
insert into test_set (t1, t2, t3, t4) values (2, 1, 2, 3);

update test_set set id = (((t1 - 1) * 3 + t2 - 1) * 3 + t3 - 1) * 3 + t4 - 1;

select * from test_set;

select *
from test_set a, test_set b, test_set c
where ((a.t1 = b.t1 and a.t1 = c.t1) or (a.t1 != b.t1 and a.t1 != c.t1 and b.t1 != c.t1))
  and ((a.t2 = b.t2 and a.t2 = c.t2) or (a.t2 != b.t2 and a.t2 != c.t2 and b.t2 != c.t2))
  and ((a.t3 = b.t3 and a.t3 = c.t3) or (a.t3 != b.t3 and a.t3 != c.t3 and b.t3 != c.t3))
  and ((a.t4 = b.t4 and a.t4 = c.t4) or (a.t4 != b.t4 and a.t4 != c.t4 and b.t4 != c.t4))
  and a.id < b.id and b.id < c.id
