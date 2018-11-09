using System;
using StackExchange.Redis;

namespace dd_trace_csharp_linux_example
{
    class Program
    {
        static void Main(string[] args)
        {            
            using (var redis = ConnectionMultiplexer.Connect("redis"))
            {
                do{
                    redis.GetDatabase().StringSet("x", "y");
                    Console.WriteLine(redis.GetDatabase().StringGet("x"));
                } while (true);
            }
        }
    }
}
