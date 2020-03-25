/*
ГНОМ + ГНОМ = СКАЛА
*/

with dg as -- цифры
(select level - 1 x from dual connect by level <= 8),
perms as -- перестановки
(select G_.x G, N_.x N, O_.x O, M_.x M, S_.x S, K_.x K, A_.x A, L_.x L
    from dg G_
    join dg N_
      on N_.x not in (G_.x)
    join dg O_
      on O_.x not in (G_.x, N_.x)
    join dg M_
      on M_.x not in (G_.x, N_.x, O_.x)
    join dg S_
      on S_.x not in (G_.x, N_.x, O_.x, M_.x)
    join dg K_
      on K_.x not in (G_.x, N_.x, O_.x, M_.x, S_.x)
    join dg A_
      on A_.x not in (G_.x, N_.x, O_.x, M_.x, S_.x, K_.x)
    join dg L_
      on L_.x not in (G_.x, N_.x, O_.x, M_.x, S_.x, K_.x, A_.x))
select G, N, O, M, '+' "+", G, N, O, M, '=' "=", S, K, A, L, A
  from perms
where (((G * 8 + N) * 8 + O) * 8 + M) +
       (((G * 8 + N) * 8 + O) * 8 + M) =
       ((((S * 8 + K) * 8 + A) * 8 + L) * 8 + A);

/*
GNOM + GNOM = SKALA
4327 + 4327 = 10656
*/