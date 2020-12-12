# Day 11 - Seating System

<https://adventofcode.com/2020/day/11>

Type of puzzle: Game of Life.

Spent a bunch of time factoring things out so Part 1 was solved by a `SeatGrid` class and Part 2 was solved by a subclass with a couple of simple overrides.  Would have solved Part 2 quicker if I'd just aimed for getting the correct answer and **then** factored things out for "niceness".  I wonder if I can catch myself next time and persuade myself to optimize for getting the answer as quickly as possible.  Part of this is tied up with my kneejerk impulse to wrap things in objects.

I also spent a bunch of time adding a cache of "points of interest" to make Part 2 run faster.  (In Part 1, "points of interest" for a given point were its neighboring points.  I realized later I could have reduced to only neighboring **non-floor** points, and could then have further optimized by not checking whether the value was floor.)  This cache was a premature optimization.  I hadn't actually tried running the code without a cache.  Afterwards I did a time comparison.  With no cache, each part took 2-3 seconds.  With cache, 3-4 seconds.  I would have saved time overall by not implementing the cache.

This was the first time this year either of the puzzles has taken noticeable time at all.  I wonder if today's solutions would have run faster if I'd used plain old arrays directly instead of the `CharGrid` class.  I wonder if things like method dispatch and custom subscripting added enough overhead to make the execution times noticeable.  The grids needed 84 passes to stabilize for Part 1, and 90 passes for Part 2.  Doesn't seem like a huge number of operations.


