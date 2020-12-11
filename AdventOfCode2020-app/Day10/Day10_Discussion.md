# Day 10 - Adapter Array

<https://adventofcode.com/2020/day/10>

Key insight to start with, applicable to both parts: we have to sort the array before working with it.

Part 1 can be expressed as: in traversing the sorted array of numbers, how many jumps are 1's and how many are 3's?

Part 2 can be expressed as: how many subsequences of the array are there such that any pair of consecutive elements differ by at most 3?  (Btw in the past I've thought of "subsequences" as synonmous with "subarrays".  It's only in recent years that I became aware of the more specific usage.)

Key insights for Part 2:

- Creating a `jumps` array.
- Using that to create a `waysToProceed` array.
- Filling in `waysToProceed` backwards, starting at the end.

One of my first ideas was to scan the list of jumps and group them into clusters of 3's and 1's.  That didn't pan out, but it got me thinking that for every position `i`, there's a number of ways a valid sequence could get **to** `i` and a number of ways the sequence could then proceed **from** `i`.  Eventually I realized I only needed the latter.  I could express the problem as, "How many ways can a valid sequence proceed from `i = 0`?"  And the answer would be in `waysToProceed[0]`.

At first I thought about filling in `waysToProceed` from beginning to end, using recursion and memoization, but then hit on the idea of filling it in backwards.  I'm pretty sure I only thought of this because of a talk on dynamic programming I attended at [RC](https://www.recurse.com/).  I think the recursion approach would have worked too, and would have been just as fast (O(n)), but maybe a little harder to reason about, and it would have used more space due to the recursion stack.

