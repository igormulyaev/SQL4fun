using System;
using System.IO;
using System.Text;

class CMain {
  private const long nMin = 2;
  private const char delimiter = '\t';

  private static long nMax = 99;
  private static bool valuesOutFlag;
  private static bool tableOutFlag;

  private static CMults mults;
  private static int[] sums;

  private static long smMax;
  private static CMults mults2;
  private static int[] sums2;
  //-----------------------------------------------------------------------
  static public void Main (string[] args) {

    if (parseArgs (args)) {
      fillMults(); // Произведения для первого вопроса
    
      fillSums(); // Суммы для второго вопроса
    
      fillMults2(); // Произведения для третьего вопроса
    
      fillSums2(); // суммы для четвертого вопроса
    
      reportOut(); // Вывод отчета
    }
    else
    { helpOut();
    }
  }

  //-----------------------------------------------------------------------
  static private bool parseArgs (string[] args) {
    if (args.Length != 2 || !Int64.TryParse(args[1], out nMax) || nMax < 2) {
      return false;
    }
    valuesOutFlag = args[0].ToUpper().IndexOf('V') >= 0;
    tableOutFlag = args[0].ToUpper().IndexOf('T') >= 0;

    return valuesOutFlag || tableOutFlag;
  }

  //-----------------------------------------------------------------------
  static private void helpOut () {
    Console.WriteLine("Usage: w <out type: v[alues] | t[able]> <nMax>");
  }

  //-----------------------------------------------------------------------
  static private void fillMults () {
    mults = new CMults (nMax * nMax);

    // Подсчет количества встреченных произведения для выбора уникальных 
    for (long a = nMin; a <= nMax; ++a) {
      for (long b = a; b <= nMax; ++b) {
        mults.Inc(a * b);
      }
    }
  }

  //-----------------------------------------------------------------------
  static private void fillSums () {
    sums = new int[nMax + nMax + 1];

    // Если произведение уникально, то сумма недопустима
    for (long sm = nMin + nMin; sm <= nMax + nMax; ++sm) {
      for (long a = nMin; a <= nMax && a <= sm - nMin; ++a) {
        long b = sm - a;
        if (b >= a && b <= nMax) {
          if (mults.Val(a * b) == 1) {
            ++sums[sm];
          }
        }
      }
      if (sums[sm] == 0) {  
        smMax = sm; 
      }
    }
  }

  //-----------------------------------------------------------------------
  static private void fillMults2 () {
    mults2 = new CMults((smMax + 1) * (smMax + 1) / 4); // макс произведение при a = b = smMax / 2

    // Для допустимых сумм ищем уникальные произведения
    for (long sm = nMin + nMin; sm <= smMax; ++sm) {
      if (sums[sm] == 0) {
        for (long a = nMin; a <= nMax && a <= sm - nMin; ++a) {
          long b = sm - a;
          if (b >= a && b <= nMax) {
            mults2.Inc(a * b);
          }
        }
      }
    }
  }

  //-----------------------------------------------------------------------
  static private void fillSums2 () {
    sums2 = new int[smMax + 1];
   
    // ищем сумму, в которой только одно уникальное произведение
    for (long sm = nMin + nMin; sm <= smMax; ++sm) {
      if (sums[sm] == 0) {
        for (long a = nMin; a <= nMax && a <= sm - nMin; ++a) {
          long b = sm - a;
          if (b >= a && b <= nMax) {
            if (mults2.Val(a * b) == 1) {
              ++sums2[sm];
            }
          }
        }
      }
    }
  }

  //-----------------------------------------------------------------------
  static private void reportOut () {
    if (valuesOutFlag) {
      // Вывод найденных ответов
      Console.WriteLine("nMax = " + nMax);

      int cnt = 0;
      long sum_mul = 0;

      for (long sm = nMin + nMin; sm <= smMax; ++sm) {
        if (sums2[sm] == 1) {
          // Ответ в строке с суммой, где есть только одно уникальное произведение
          for (long a = nMin; a <= nMax; ++a) {
            long b = sm - a;
            if (b >= a && b <= nMax && mults2.Val(a * b) == 1) {
              // Нашли уникальное произведение в строке, выводим
              Console.WriteLine("a = " + a + "; b = " + b + "; sum = " + sm + "; mul = " + (a * b));
              ++cnt;
              sum_mul += a * b;
              break;
            }
          }
        }
      }
      Console.WriteLine("Count = " + cnt + "; sum(mul) = " + sum_mul);
    }

    if (tableOutFlag) {
      // Вывод таблицы
      StringBuilder sb = new StringBuilder();
  
      // Заголовок
      sb.Append(nMax);
      for (long a = nMin; a <= nMax; ++a) {
        sb.Append(delimiter);
        sb.Append(a);
      }
  
      Console.WriteLine(sb);
  
      // Тело таблицы
      for (long sm = nMin + nMin; sm <= nMax + nMax; ++sm) {
        sb.Clear();
        sb.Append(sm);
  
        for (long a = nMin; a <= nMax; ++a) {
          sb.Append(delimiter);
  
          long b = sm - a;
          if (b >= a && b <= nMax) {
            char v; // номер фразы, на которой отсеяно сочетание
  
            if (mults.Val(a * b) == 1) { // уникальное произведение
              v = '1'; 
            } else if (sums[sm] != 0) { // сумма, в которой встречается уникальное произведение
              v = '2'; 
            } else if (mults.Val(a * b) > 1) { // неуникальное произведение
              v = '3';
            } else if (sums2[sm] > 1) { // сумма, в которой встречается больше одного уникального произведения
              v = '4'; 
            } else { // Искомая пара чисел
              v = 'X';
            }
            sb.Append(v);
          } 
        }
  
        Console.WriteLine(sb);
      }
    }
  }
}
