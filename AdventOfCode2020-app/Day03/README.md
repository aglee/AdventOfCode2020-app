# Day 3 - Toboggan Trajectory

<https://adventofcode.com/2020/day/3>

The main hump here was figuring out how to represent the terrain having indefinite width, or to think of it another way, to represent the input grid as a cylinder.   My solution was to apply a modulus to all x coordinates.

After inspecting the input data, I think it would also have been fine to combine copies of the input grid to make an extra-wide grid like the one shown in the given example.  The extra-wide grid would only have to be wide enough for the toboggan to reach bottom before reaching the right edge, and this required width could easily be calculated.  But the modulo way was quicker to code anyway.

Mike LeSauvage created a delightful animation of his solution: <https://twitter.com/MikeLeSauvage/status/1334636919980871680>.

