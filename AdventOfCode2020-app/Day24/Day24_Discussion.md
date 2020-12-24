# Day 24 - Lobby Layout

<https://adventofcode.com/2020/day/24>

Type of problem: hexagonal grid, Game of Life.

There was at least one puzzle in a previous year that involved a hexagonal grid.  I remembered that it could be represented by the same 2-dimensional coordinate system as a grid of squares.  I did need a few minutes to sketch this on paper to make sure I got my dx's and dy's right.  I started by drawing my hexagons with an edge on top, but realized I needed them to have a *corner* on top.

My first thought for parsing the lines of directions was to use a regular expression.  But then I thought, wait, isn't the parsing ambiguous?  But then I realized it wasn't -- "ne" cannot be parsed as "n" followed by "e", because there is no "n".  I ended up hand-coding the parsing anyway.  It was simple enough that it was faster than refreshing my memory on how to use `NSRegularExpression`.  But I'd have saved a few minutes on that part if I'd had my regex basics down cold.

I was better tonight about:

- **Not agonizing too long over names.**  For example, I initially had a `move` method for processing one **letter** indicating a direction ("n", "s", "e", or "w").  That method changed as I was writing it, so that it was for processing one **line** of input containing multiple direction letters.  I paused for a couple of seconds to try to think of a better name, but resisted the temptation to spend more time than that.  I knew I could clean it up later.  Afterwards I renamed the method to `flipTileColor(directions:)`.
- **Trusting the test.**  I submitted my real answers as soon as my tests passed.  I was tempted to add printf's along the way, to make sure my logic was producing the exact intermediate results given in the puzzle description.  But I resisted that temptation and decided to assume that if my test gave the right answer, my code would almost certainly give me the right final answer.  And it did, in both Part 1 and Part 2.

Speaking of names, it felt awkward thinking about "number of black neighbors".  I tried to ignore that until I'd submitted my correct answers and got around to cleaning up the code.

