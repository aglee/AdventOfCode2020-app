# Day 14 - Docking Data

<https://adventofcode.com/2020/day/14>

Type of puzzle: bit arithmetic; representing a sparse, infinite memory space (conveniently I already had a `Memory` object I'd used before); computing all subsets of a set (which in turn led to bit arithmetic again, as I used bitmasks to do it).

I had solved Part 1, and had copy-pasted that code to begin solving Part 2.  I could have proceeded without thinking about Part 1 again, but instead I spent time factoring stuff out into a base class with a subclass for Part 1 and a subclass for Part 2.  I could have done this *after* solving Part 2, but I succumbed to the impulse.

To calculate all the floating masks for Part 2 I constructed arrays of strings that were "0" or "1", and converted them to integers using `Int(_:radix:)`, rather than use bit arithmetic.  It seemed to require less cogntive labor, and it felt less error-prone in this case to deal with array indices, with index 0 always on the left, than with bit positions, where the zeroeth bit is on the right and I'd have to subtract from 36 (or 35?) in just the right place.


