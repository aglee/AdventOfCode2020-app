# Day 8 - Handheld Halting

<https://adventofcode.com/2020/day/8>

Type of problem: mini-assembly language.

Concepts: console, accumulator, instruction, program (list of instructions), program counter.

Notes:

- Relatively simple compared to past puzzles of this genre.  Only 3 types of instruction, each with exactly 1 argument.  No need to represent addressed memory or lots of registers.  It's possible there will be more complex versions of this puzzle in the future.
- Swift-related notes:
	- I noticed I myself more easily relaxing in terms of making properties private by default.  I allowed my `Day08` class to freely access properties of my `Console` class.  This saved time while I was fiddling around.
	- Using `typealias Instruction = (op: String, arg: Int)` was a handy way of not spending time making a struct for this purpose.  I also used a typealias on Day 7, for clarity: `typealias BagColor = String`.
	- For grins, I used the "Complexity:" tag in a couple of doc comments.


