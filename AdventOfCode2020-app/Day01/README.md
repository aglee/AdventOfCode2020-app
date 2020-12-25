# Day 1 - Report Repair

<https://adventofcode.com/2020/day/1>

Solved both parts using nested loops through the given array of numbers.

For Part 1 I used 2 nested loops.  Could also have used a set to reduce complexity to O(n) (put the whole list in the set, then loop through the list and check if the set contains `2020 - numbers[i]`).

For Part 2 I used 3 nested loops.  Could have used a dictionary to reduce complexity to O(n^2).  The keys would be all possible pairwise sums, the values would be the corresponding pairwise products.  After building the dictionary, loop through the list and see if the dictionary has `2020 - numbers[i]` as a key.


