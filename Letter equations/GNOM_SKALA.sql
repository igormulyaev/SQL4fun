/*
ГНОМ+ГНОМ=СКАЛА
*/

with dg as -- цифры
(select level - 1 x from dual connect by level <= 8),
perms as -- перестановки
(select G_.x G, N_.x N, O_.x O, M_.x M, S_.x S, C_.x C, A_.x A, L_.x L
    from dg G_
    join dg N_
      on N_.x not in (G_.x)
    join dg O_
      on O_.x not in (G_.x, N_.x)
    join dg M_
      on M_.x not in (G_.x, N_.x, O_.x)
    join dg S_
      on S_.x not in (G_.x, N_.x, O_.x, M_.x)
    join dg C_
      on C_.x not in (G_.x, N_.x, O_.x, M_.x, S_.x)
    join dg A_
      on A_.x not in (G_.x, N_.x, O_.x, M_.x, S_.x, C_.x)
    join dg L_
      on L_.x not in (G_.x, N_.x, O_.x, M_.x, S_.x, C_.x, A_.x))
select G, N, O, M, '+' "+", G, N, O, M, '=' "=", S, C, A, L, A
  from perms
where (((G * 8 + N) * 8 + O) * 8 + M) +
       (((G * 8 + N) * 8 + O) * 8 + M) =
       ((((S * 8 + C) * 8 + A) * 8 + L) * 8 + A);

G            N            O            M           +             G            N            O            M           =             S             C             A             L              A
4             3             2             7             +             4             3             2             7             =             1             0             6             5             6
