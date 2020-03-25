-- ����������������� ��������� ��������
with par as
-- ���������
 (select 181 x_cnt, -- ���������� ����� �� ��� X
         -1.7 x_start, -- ��������� ���������� X
         1 / 80 x_step, -- ��� �� X
         81 y_cnt, -- ���������� ����� �� ��� Y
         -1 y_start, -- ��������� ���������� Y
         1 / 40 y_step, -- ��� �� Y
         64 max_depth -- ������������ ���������� �������� �� �����
    from dual),
-- ��������� ������ ����� �� x
xs as
 (select x_start + (level - 1) * x_step x, max_depth
    from par
  connect by level <= x_cnt),
-- ��������� ������ ����� �� y
ys as
 (select y_start + (level - 1) * y_step y from par connect by level <= y_cnt),
-- ����������� ������
mandelbrot(cur_depth,
x,
y,
re,
im) as
 (select max_depth cur_depth, x, y, x re, y im
    from xs
   cross join ys
  union all
  select cur_depth - 1, x, y, re * re - im * im + x, 2 * re * im + y
    from mandelbrot
   where re * re + im * im < 4
     and cur_depth > 1)
-- select ----------------------------
select listagg(c) within group(order by x) sx -- ��������� �������������� ������ �� ��������
  from (select -- ��� ������ ����� ������� ������������ �������, �� ������� ������� �����������, �
        -- �������� ��������������� �� ������
         x,
         y,
         substr(' @@@@@@@########%%%%%%%%********;;;;;;;;::::::::,,,,,,,,........',
                min(cur_depth),
                1) c
          from mandelbrot
         group by x, y)
 group by y
 order by y;

with mandelbrot(n,
x,
y,
re,
im) AS
 (select 1, x, y, x, y
    from (select (nx.n - 1) / 60 - 2 x, (ny.n - 1) / 40 - 1 y
            from (select level n from dual connect by level <= 180) nx
           cross join (select level n from dual connect by level <= 80) ny)
  union all
  select n + 1, x, y, re * re - im * im + x, 2 * re * im + y
    from mandelbrot
   where re * re + im * im < 4
     and n < 64)
select listagg(c) within group(order by x) sx
  from (select substr('........,,,,,,,,::::::::;;;;;;;;********%%%%%%%%########@@@@@@@ ',
                      max(n),
                      1) c,
               x,
               y
          from mandelbrot
         group by x, y)
 group by y
 order by y;

with mandelbrot(n,
x,
y,
re,
im) AS
 (select 1, x, y, x, y
    from (select (nx.n - 1) / 240 - 0.5 x, (ny.n - 1) / 160 - 1 y
            from (select level n from dual connect by level <= 180) nx
           cross join (select level n from dual connect by level <= 80) ny)
  union all
  select n + 1, x, y, re * re - im * im + x, 2 * re * im + y
    from mandelbrot
   where re * re + im * im < 4
     and n < 64)
select listagg(c) within group(order by x) sx
  from (select substr('........,,,,,,,,::::::::;;;;;;;;********%%%%%%%%########@@@@@@@ ',
                      max(n),
                      1) c,
               x,
               y
          from mandelbrot
         group by x, y)
 group by y
 order by y;

with mandelbrot(n,
x,
y,
re,
im) AS
 (select 1, x, y, x, y
    from (select (nx.n - 1) / 960 - 0.2 x, (ny.n - 1) / 640 - 1 y
            from (select level n from dual connect by level <= 180) nx
           cross join (select level n from dual connect by level <= 80) ny)
  union all
  select n + 1, x, y, re * re - im * im + x, 2 * re * im + y
    from mandelbrot
   where re * re + im * im < 4
     and n < 64)
select listagg(c) within group(order by x) sx
  from (select substr('........,,,,,,,,::::::::;;;;;;;;********%%%%%%%%########@@@@@@@ ',
                      max(n),
                      1) c,
               x,
               y
          from mandelbrot
         group by x, y)
 group by y
 order by y;
