# Day 12 - Rain Risk

<https://adventofcode.com/2020/day/12>

Part 1 pitfall: I didn't read carefully enough, and didn't see that the "value" part of the "L" and "R" instructions was a number of degrees.  I was treating all turns as being 90 degrees.  The test passed because the test data happened to use only a turn of 90 degrees.  But I got the wrong answer for the "real" Part 1 data and had to go back and read more carefully.  I *felt* like I was being too hasty even I was submitting the answer.

Part 2 pitfall: I got the math wrong on rotating the waypoint, because I was thinking of regular Cartesian coordinates, where positive y is north, but in the rest of my code positive y is south.  I didn't have this bug in Part 1 because in Part 1 I could use my `MoveDirection` enum where I'd already gotten the math right.  Fortunately I caught the bug in testing, so when I submitted my Part 2 answer it was right the first time.  Afterwards I added rotation methods to `GridPoint` and changed my solution to use `GridPoint`.  If I need them in the future I won't have to risk getting the math wrong again.


