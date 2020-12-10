# Day 9 - Encoding Error

<https://adventofcode.com/2020/day/9>

I wasted a lot of time over-engineering Part 1, trying to come up with efficient data structures.  Finally I realized using brute force wouldn't actually take long.  In fact, it was practically instantaneous.

While solving Part 2 I realized I was still over-engineering.  I didn't need an "`XMAS`" object; I could just use plain top-level functions.  I shuffled code around to simplify accordingly, and in such a way that I could specify the tests concisely.

Testing caught a bug in Part 2.  I hadn't noticed the part about needing the min and max of the subsequence -- I'd thought I needed the values at the endpoints.  Easily fixed.

