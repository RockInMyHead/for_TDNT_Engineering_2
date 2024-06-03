using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace rk
{
    class Program
    {
        public static int RabinKarp(string First, string Second, int q, int x)
        {
            int n = First.Length;
            int m = Second.Length;
            int h = (int)Math.Pow(x, m - 1) % q;
            int obraz = 0;
            int firstpozition = 0;
            for (int i = 1; i <= m; i++)
            {
                obraz += (((int)Math.Pow(x, m - i)) * Second[i - 1]) % q;
                firstpozition += (((int)Math.Pow(x, m - i)) * First[i - 1]) % q;
            }
            for (int i = 0; i < n - m; i++)
            {
                if (firstpozition == obraz)
                {
                    return i;
                }
                else if (i < n - m)
                {
                    firstpozition = (x * (firstpozition - First[i] * h) + First[i + m]) % q;
                }
            }
            return -1;
        }
        static void Main(string[] args)
        {
            int q = (int)Math.Pow(2, 31) - 1;
            int x = 2;
            Console.WriteLine(RabinKarp("tyu123456789", "123", q, x));
        }
    }
}
