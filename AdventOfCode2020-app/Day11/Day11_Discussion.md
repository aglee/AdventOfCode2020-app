# Day 11 - Seating System

<https://adventofcode.com/2020/day/11>

Type of puzzle: Game of Life.

Spent a bunch of time factoring things out so Part 1 was solved by a `SeatGrid` class and Part 2 was solved by a subclass with a couple of simple overrides.  Would have solved Part 2 quicker if I'd just aimed for getting the correct answer and **then** factored things out for "niceness".  I wonder if I can catch myself next time and persuade myself to optimize for getting the answer as quickly as possible.  Part of this is tied up with my kneejerk impulse to wrap things in objects.

I also spent a bunch of time adding a cache of "points of interest" to make Part 2 run faster.  I wonder how much that even mattered.  I never actually tried Part 2 without a cache -- might do so later.  I can't tell if the cache sped up Part 1 -- subjectively, it seemed to take a couple of seconds whether I had the cache or not.  This was the first time this year either of the puzzles has taken noticeable time at all.

I wonder if things would have run faster if I'd used plain old arrays directly instead of the `CharGrid` class.  I wonder if things like method dispatch and subscripting added noticeable overhead.


