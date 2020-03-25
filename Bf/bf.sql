with
-- ���������, �������� ������
parms as
 (select 
 --',[>,]<.[<.]' -- ������ ������
 --'>>++++++[<+++++++[<+>-]>-]' -- ����� �� ������� ������ �����, ��������� � ����� ������
 '++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.' -- Hello World!\n
 program_text,
         'Input string' input_string,
         16 mem_size,
         1000 max_steps
    from dual),
-- ��� ����������� �������������
brainfuck(data_hex, -- ������ ������
step_n, -- ������� ��������
data_pos, -- ��������� �� ������� ������
prog_pos, -- ��������� �� ������� �������
text_in, -- ������� �����
text_out, -- �������� �����
loop_seek /* ������� ������ ������ / ����� �����:
             = 0 - ������������� ������; 
             < 0 - ������� � ������ ����� (����� ��������);
             > 0 - ����� ����� ����� (����� �� �����)
             ��� ��������� ������ +/-2, +/-3 � �.�. */
) as
 (select rpad('0', mem_size * 2, '0') data_hex, -- ������������� ������ ������
         0 step_n,
         1 data_pos,
         1 prog_pos,
         input_string text_in,
         '' text_out,
         0 loop_seek
    from parms
  union all
  select
  -- ������ ������ -------------------------------
   case
     when loop_seek = 0 then
      case substr(program_text, prog_pos, 1)
        when '+' then -- ������ +1
         substr(data_hex, 1, data_pos - 1) ||
         to_char(mod(to_number(substr(data_hex, data_pos, 2), 'xx') + 1, 256),
                 'fm0x') || substr(data_hex, data_pos + 2)
        when '-' then -- ������ -1
         substr(data_hex, 1, data_pos - 1) ||
         to_char(mod(to_number(substr(data_hex, data_pos, 2), 'xx') + 255, 256),
                 'fm0x') || substr(data_hex, data_pos + 2)
        when ',' then -- ������ = in
         substr(data_hex, 1, data_pos - 1) ||
         to_char(nvl(ascii(substr(text_in, 1, 1)), 0), 'fm0x') ||
         substr(data_hex, data_pos + 2)
        else
         data_hex
      end
     else
      data_hex
   end data_hex,
   -- ������� ����� ---------------------------
   step_n + 1 step_n,
   -- ������� ������ --------------------------
   case
     when loop_seek = 0 then
      case substr(program_text, prog_pos, 1)
        when '>' then -- ������
         mod(data_pos + 2, mem_size * 2)
        when '<' then -- �����
         mod(data_pos - 2 + mem_size * 2, mem_size * 2)
        else
         data_pos
      end
     else
      data_pos
   end data_pos,
   -- ������� ��������� -----------------------
   case
     when (loop_seek = 0 and substr(program_text, prog_pos, 1) = ']' and
          substr(data_hex, data_pos, 2) != '00') or
          (loop_seek < 0 and
          (substr(program_text, prog_pos, 1) != '[' or loop_seek < -1)) then
     -- ���� ������ ����� �����, � ���� ���� �� ����� ��������
     -- ��� ���� ����� ������ �����, � �� �� ������ ��� ������� ������ ����������,
     -- �� �������� �����
      prog_pos - 1
     else
      prog_pos + 1 -- ����� �������� ������
   end prog_pos,
   -- ������� ����� ---------------------------
   case
     when loop_seek = 0 and substr(program_text, prog_pos, 1) = ',' then -- �������� �������
      substr(text_in, 2)
     else
      text_in
   end text_in,
   -- �������� ����� --------------------------
   case
     when loop_seek = 0 and substr(program_text, prog_pos, 1) = '.' then -- ����� �������
      text_out || chr(to_number(substr(data_hex, data_pos, 2), 'xx'))
     else
      text_out
   end text_out,
   -- ���� ������ ������ / ����� ����� --------
   case
     when substr(program_text, prog_pos, 1) = '[' and
          (loop_seek != 0 or substr(data_hex, data_pos, 2) = '00') then
     -- ����� ������� ������ �����
     -- � ����� ��� ���� ��� ���� ��������� �� ����
      loop_seek + 1
     when substr(program_text, prog_pos, 1) = ']' and
          (loop_seek != 0 or substr(data_hex, data_pos, 2) != '00') then
     -- ����� ������� ����� �����
     -- � ����� ��� ���� ��� ���� ���� �� ����� ��������
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
