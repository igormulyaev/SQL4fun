with nums as
 (select --+ materialize
   level + 1 n
    from dual
  connect by level < 9999),
src as
 (select --+ materialize
 nums1.n n1, nums2.n n2, nums1.n * nums2.n p, nums1.n + nums2.n s
    from nums nums1
   cross join nums nums2
   where nums1.n <= nums2.n),
q1 as
 (select --+ materialize
   src.*,
   -- 1. я не знаю этих чисел => когда произведение можно разложить на множители единственным образом, то эти числа известны, поэтому такие сочетания исключаем
   case
     when count(*) over(partition by p) = 1 then
      n1 || '*' || n2
   end p1
    from src),
q1_1 as
 (select --+ materialize
  s, min(n1||'+'||n2) p1_1
    from q1
   where p1 is not null
   group by s),
q2 as
 (select --+ materialize
   q1.*,
   -- 2. я знал, что ты не знаешь => сумма чисел не может быть разложена на слагаемые, исключенные в п.1, поэтому такие сочетания исключаем
   case
     when q1_1.s is not null then
      q1_1.p1_1
   end s2
    from q1
    left join q1_1
      on q1.s = q1_1.s),
q3 as
 (select --+ materialize
   q2.*,
   -- 3. тогда я знаю эти числа => для оставшихся вариантов произведение раскладывется на множители единственным образом
   case
     when count(case when s2 is null then 1 end) over(partition by p) > 1 and s2 is null then
      case when n1||'*'||n2 = min(case when s2 is null then n1||'*'||n2 end) over (partition by p) then max(case when s2 is null then n1||'*'||n2 end) over (partition by p)
        else min(case when s2 is null then n1||'*'||n2 end) over (partition by p) end
   end p3
    from q2
   ),
q4 as
 (select --+ materialize
   q3.*,
   -- 4. тогда и я знаю эти числа => для оставшихся вариантов сумма раскладывется на слагаемые единственным образом
   case
     when count(case when s2 is null and p3 is null then 1 end) over(partition by s) > 1 and s2 is null and p3 is null then
      case when n1||'+'||n2 = min(case when s2 is null and p3 is null then n1||'+'||n2 end) over (partition by s) then
        max(case when s2 is null and p3 is null then n1||'+'||n2 end) over (partition by s)
        else min(case when s2 is null and p3 is null then n1||'+'||n2 end) over (partition by s) end
   end s4
    from q3
   )
select q4.*, case when coalesce(p1, s2, p3, s4) is null then n1 || ', ' || n2 end answer 
from q4 
where 1=1
and coalesce(p1, s2, p3, s4) is null 
--and (p = 5494 or s =149)
order by 1 ,2
/* 9999:
N1	N2	P	S	P1	S2	P3	S4	ANSWER
4	13	52	17					4, 13
4	61	244	65					4, 61
4	181	724	185					4, 181
4	229	916	233					4, 229
8	239	1912	247					8, 239
16	73	1168	89					16, 73
16	111	1776	127					16, 111
16	163	2608	179					16, 163
32	131	4192	163					32, 131
32	311	9952	343					32, 311
64	73	4672	137					64, 73
64	127	8128	191					64, 127
64	309	19776	373					64, 309
*/

