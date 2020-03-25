with
-- ѕараметры, исходные данные
parms as
 (select 
 --',[>,]<.[<.]' -- –еверс строки
 --'>>++++++[<+++++++[<+>-]>-]' -- ќтвет на главный вопрос жизни, ¬селенной и всего такого
 '++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.' -- Hello World!\n
 program_text,
         'Input string' input_string,
         16 mem_size,
         1000 max_steps
    from dual),
-- сам рекурсивный интерпретатор
brainfuck(data_hex, -- пам€ть данных
step_n, -- счетчик итераций
data_pos, -- указатель на текущие данные
prog_pos, -- указатель на текущую команду
text_in, -- ¬ходной текст
text_out, -- ¬ыходной текст
loop_seek /* ѕризнак поиска начала / конца цикла:
             = 0 - интерпретаци€ команд; 
             < 0 - возврат к началу цикла (нова€ итераци€);
             > 0 - поиск конца цикла (выход из цикла)
             дл€ вложенных циклов +/-2, +/-3 и т.д. */
) as
 (select rpad('0', mem_size * 2, '0') data_hex, -- инициализаци€ пам€ти нул€ми
         0 step_n,
         1 data_pos,
         1 prog_pos,
         input_string text_in,
         '' text_out,
         0 loop_seek
    from parms
  union all
  select
  -- пам€ть данных -------------------------------
   case
     when loop_seek = 0 then
      case substr(program_text, prog_pos, 1)
        when '+' then -- данные +1
         substr(data_hex, 1, data_pos - 1) ||
         to_char(mod(to_number(substr(data_hex, data_pos, 2), 'xx') + 1, 256),
                 'fm0x') || substr(data_hex, data_pos + 2)
        when '-' then -- данные -1
         substr(data_hex, 1, data_pos - 1) ||
         to_char(mod(to_number(substr(data_hex, data_pos, 2), 'xx') + 255, 256),
                 'fm0x') || substr(data_hex, data_pos + 2)
        when ',' then -- данные = in
         substr(data_hex, 1, data_pos - 1) ||
         to_char(nvl(ascii(substr(text_in, 1, 1)), 0), 'fm0x') ||
         substr(data_hex, data_pos + 2)
        else
         data_hex
      end
     else
      data_hex
   end data_hex,
   -- счетчик шагов ---------------------------
   step_n + 1 step_n,
   -- позици€ данных --------------------------
   case
     when loop_seek = 0 then
      case substr(program_text, prog_pos, 1)
        when '>' then -- вперед
         mod(data_pos + 2, mem_size * 2)
        when '<' then -- назад
         mod(data_pos - 2 + mem_size * 2, mem_size * 2)
        else
         data_pos
      end
     else
      data_pos
   end data_pos,
   -- позици€ программы -----------------------
   case
     when (loop_seek = 0 and substr(program_text, prog_pos, 1) = ']' and
          substr(data_hex, data_pos, 2) != '00') or
          (loop_seek < 0 and
          (substr(program_text, prog_pos, 1) != '[' or loop_seek < -1)) then
     -- ≈сли найден конец цикла, и надо идти на новую итерацию
     -- »Ћ» идет поиск начала цикла, и он не найден или найдено начало вложенного,
     -- то движемс€ назад
      prog_pos - 1
     else
      prog_pos + 1 -- иначе движемс€ вперед
   end prog_pos,
   -- входной текст ---------------------------
   case
     when loop_seek = 0 and substr(program_text, prog_pos, 1) = ',' then -- загрузка символа
      substr(text_in, 2)
     else
      text_in
   end text_in,
   -- выходной текст --------------------------
   case
     when loop_seek = 0 and substr(program_text, prog_pos, 1) = '.' then -- вывод символа
      text_out || chr(to_number(substr(data_hex, data_pos, 2), 'xx'))
     else
      text_out
   end text_out,
   -- флаг поиска начала / конца цикла --------
   case
     when substr(program_text, prog_pos, 1) = '[' and
          (loop_seek != 0 or substr(data_hex, data_pos, 2) = '00') then
     -- Ќашли признак начала цикла
     -- » поиск уже идет или цикл выполн€ть не надо
      loop_seek + 1
     when substr(program_text, prog_pos, 1) = ']' and
          (loop_seek != 0 or substr(data_hex, data_pos, 2) != '00') then
     -- Ќашли признак конца цикла
     -- » поиск уже идет или надо идти на новую итерацию
      loop_seek - 1
     else
      loop_seek
   end loop_seek
    from brainfuck, parms
   where prog_pos <= length(program_text)
     and step_n < max_steps)
-- select --------------------------------
select substr(program_text, 1, prog_pos - 1) || '(' ||
       substr(program_text, prog_pos, 1) || ')' ||
       substr(program_text, prog_pos + 1) program_text,
       substr(data_hex, 1, data_pos - 1) || '(' ||
       substr(data_hex, data_pos, 2) || ')' ||
       substr(data_hex, data_pos + 2) data_hex,
       step_n,
       data_pos,
       prog_pos,
       text_in,
       text_out,
       loop_seek
  from brainfuck, parms
