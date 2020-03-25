/*
МАМА + ПАПА = МАМАА
*/

with dg as -- цифры
(select level - 1 x from dual connect by level <= 3),
perms as -- перестановки
(select M_.x M, A_.x A, P_.x P
    from dg M_
    join dg A_
      on A_.x not in (M_.x)
    join dg P_
      on P_.x not in (M_.x, A_.x)
      )
select M, A, M, A, '+' "+", P, A, P, A, '=' "=", M, A, M, A, A
  from perms
where (((M * 3 + A) * 3 + M) * 3 + A) +
       (((P * 3 + A) * 3 + P) * 3 + A) =
       ((((M * 3 + A) * 3 + M) * 3 + A) * 3 + A);
