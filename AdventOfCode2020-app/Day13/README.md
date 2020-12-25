# Day 13 - TBD

<https://adventofcode.com/2020/day/13>

This was the first time this year I've had to look for help.  Part 1 was straightforward, but I struggled with Part 2.  I was close to figuring out the algorithm I ended up using.  I recognized the general problem from a previous year -- solve for `t` given multiple equations `t = a mod b` with various values of `a` and `b`.  I thought the old problem had been something about water or clocks, but couldn't find it by searching my old code for those words.  Finally I gave up and looked on /r/adventofcode.  I saw the words "[Chinese Remainder Theorem](https://www.reddit.com/r/adventofcode/comments/kc5a23/2020_day_13_part_2_chinese_remainder_theorem/)" -- aha!  Searched my old code for that and found it mentioned in my comments for Advent of Code 2016 Day 15, but I had not actually used that theorem in my code.  Went to Wikipedia, was daunted at first but found the part about proof by construction using "[sieving](https://en.wikipedia.org/wiki/Chinese_remainder_theorem#Search_by_sieving)" and got the idea right away without having to dig much into the math.  Coding it was then straightforward.

