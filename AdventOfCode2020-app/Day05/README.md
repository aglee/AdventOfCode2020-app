# Day 5 - Binary Boarding

<https://adventofcode.com/2020/day/5>

The key to Part 1 was recognizing that the two parts of the seat specifier are binary numbers using different characters as digits instead of "0" and "1".

The key to Part 2 was sorting the list and scanning it to find where the numbers stop being consecutive.  As a sanity check I printed the sorted list so that I could check my answer by inspecting the list by eye.  Good thing I did this before submitting my answer, because it was wrong.  I was returning `i` when I should have been returning `sortedSeatIDs[0] + i`.


