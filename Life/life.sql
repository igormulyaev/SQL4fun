with
-- параметры - количество поколений, ширина, высота и количество элементов
parms as (select last_gen, width, height, width * height total_cells
    from (select 8 last_gen, 10 width, 7 height from dual)
),
-- Исходное поле
src_field as (
  select rpad(lpad(rpad('0010', width, '0') || rpad('0001', width, '0') ||
                    rpad('0111', width, '0'),
                    width * 4,
                    '0'),
               total_cells,
               '0') field
    from parms
),
-- Жизнь, как она есть
life(gen, i, field, next_field) as (
  select 0 gen, 0 i, field, '' next_field
    from src_field
  union all
  select case
           when i = total_cells then
            gen + 1
           else
            gen
         end gen,
         mod(i + 1, total_cells + 1) i,
         case
           when i = total_cells then
            translate(next_field, '0123456789ABCDEFGH', '000100000001100000')
           else
            field
         end field,
         case
           when i = total_cells then
            ''
           else
            next_field ||
            substr('0123456789ABCDEFGH',
                   substr(field, i + 1, 1) * 9 +
                   substr(field,
                          mod(i + total_cells - width - 1, total_cells) + 1,
                          1) + substr(field,
                                      mod(i + total_cells - width, total_cells) + 1,
                                      1) +
                   substr(field,
                          mod(i + total_cells - width + 1, total_cells) + 1,
                          1) +
                   substr(field, mod(i + total_cells - 1, total_cells) + 1, 1) +
                   substr(field, mod(i + 1, total_cells) + 1, 1) +
                   substr(field, mod(i + width - 1, total_cells) + 1, 1) +
                   substr(field, mod(i + width, total_cells) + 1, 1) +
                   substr(field, mod(i + width + 1, total_cells) + 1, 1) + 1,
                   1)
         end next_field
    from life, parms
   where gen < last_gen
     and i <= total_cells
)
-- select --------------------------------------
select case
         when y = -1 then
          'Generation ' || gen
         else
          translate(substr(field, y * width + 1, width), '01', '.X')
       end v
  from life
 cross join (select level - 2 y, width
               from parms
             connect by level <= height + 1) ys
 where i = 0
 order by gen, y;
