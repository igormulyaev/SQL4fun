/*
 D O N A L D
+
 G E R A L D
=
 R O B E R T

D = 5: дано
T = 0: D + D = 5 + 5 = 10
E = 9: O + E = O. E = 0 или 9 + перенос. 0 занят, значит 9
A = 4: A + A + 1 = 9. A или 4 или 9. 9 уже занято, значит 4
R = 7: нечетное (L + L + 1), D + 1 + G = 6 + G >= 7. 9 уже занято, значит 7
G = 1: D + G + 1 = R, 5 + G + 1 = 7
L = 8: L + L + 1 = 17
N = 6: N + R = N + 7 >= 10. 3 или 6. Если 3, то B = 0, а 0 уже занят
B = 3: N + R = 6 + 7 = 13
O = 2: последняя оставшаяся цифра

5 2 6 4 8 5
1 9 7 4 8 5
         1 : D + D = 5 + 5 = 10
 1         : E + 1 = 9 + 1 = 10 
   1       : перенос для E
       1   : A + A = 2 * A - четное, чтобы получить 9 нужен перенос из предыдущено разряда
     0     : 4 + 4 + 1 = 9, переноса нет
7 2 3 9 7 0

*/

with dg as -- цифры
 (select level - 1 x from dual connect by level <= 10),
perms as -- перестановки
 (select D_.x D,
         O_.x O,
         N_.x N,
         A_.x A,
         L_.x L,
         G_.x G,
         E_.x E,
         R_.x R,
         B_.x B,
         T_.x T
    from dg D_
    join dg O_
      on O_.x not in (D_.x)
    join dg N_
      on N_.x not in (D_.x, O_.x)
    join dg A_
      on A_.x not in (D_.x, O_.x, N_.x)
    join dg L_
      on L_.x not in (D_.x, O_.x, N_.x, A_.x)
    join dg G_
      on G_.x not in (D_.x, O_.x, N_.x, A_.x, L_.x)
    join dg E_
      on E_.x not in (D_.x, O_.x, N_.x, A_.x, L_.x, G_.x)
    join dg R_
      on R_.x not in (D_.x, O_.x, N_.x, A_.x, L_.x, G_.x, E_.x)
    join dg B_
      on B_.x not in (D_.x, O_.x, N_.x, A_.x, L_.x, G_.x, E_.x, R_.x)
    join dg T_
      on T_.x not in (D_.x, O_.x, N_.x, A_.x, L_.x, G_.x, E_.x, R_.x, B_.x))
select D, O, N, A, L, D, '+' "+", G, E, R, A, L, D, '=' "=", R, O, B, E, R, T
  from perms
 where D = 5
   and (((((D * 10 + O) * 10 + N) * 10 + A) * 10 + L) * 10 + D) +
       (((((G * 10 + E) * 10 + R) * 10 + A) * 10 + L) * 10 + D) =
       (((((R * 10 + O) * 10 + B) * 10 + E) * 10 + R) * 10 + T)