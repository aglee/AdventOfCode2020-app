# Day 15 - Rambunctious Recitation

<https://adventofcode.com/2020/day/15>

The approach in my solution was to remember the turn numbers on which each number was spoken.  I used a dictionary mapping each number that had ever been spoken to a list of turn numbers.

For Part 1 I remembered *all* the times each number was spoken.  That was fine for n = 2020, but way too slow for n = 30,000,000, which was Part 2.  It was a simple tweak to only remember the last two times each number was spoken.  Even so, it took 24 seconds to run for 30,000,000 turns.  This is so slow that I commented out all but one of the Part 2 tests.  I wondered if there was a pattern or formula in the sequence of spoken numbers that I could use to speed up the solution.

I checked /r/adventofcode and saw that other people were saving only a *single turn number* for each number spoken.  I had tried to come up with a solution that saves only a number but hadn't quite had the insights I needed.  *Now* I see how that could work; merely the fact that other people solved it that way enabled me to see, without even reading their solutions.  Interesting the difference it makes knowing in advance that a solution exists.  I haven't tried coding it this way yet.  I noticed other people were reporting longish runtimes as well, and I *think* at least one was doing it the single-number way.

I was a little better this time -- not perfect, but a little better -- about doing things quick-and-tolerably-dirty until I got the right answer to Part 2, and only then tidying the code a little.

For grins I transcribed my solution to Python and ran it in CodeRunner.  To my surprise, the test using [0, 3, 6] as input took even longer to run -- 61 seconds.  I see others got it running much faster than I did with Python though.

My solution is below.  It seems shockingly verbose compared to [this one](https://www.reddit.com/r/adventofcode/comments/kdf85p/2020_day_15_solutions/gfwh4vd/).

I ran [cattbug's](https://www.reddit.com/r/adventofcode/comments/kdf85p/2020_day_15_solutions/gfwfygk/) [solution](https://github.com/besasam/advent-of-code/blob/main/2020/15/15.py) in CodeRunner and it only took 12 seconds.  So maybe I'd see significant gains from the single-number approach.  I can imagine that 30,000,000 integer replacements in a dictionary could be noticeably faster than 30,000,000 array allocations.

```python
#!/usr/bin/env python3

numTurnsTaken = 0
lastNumberSpoken = -1
lastTwoTurnsWhenSpoken = {}

def speak(n):
	global numTurnsTaken
	global lastNumberSpoken
	global lastTwoTurnsWhenSpoken
	
	numTurnsTaken += 1
	lastNumberSpoken = n
	if n in lastTwoTurnsWhenSpoken:
		lastTwoTurnsWhenSpoken[n] = [lastTwoTurnsWhenSpoken[n][-1], numTurnsTaken]
	else:
		lastTwoTurnsWhenSpoken[n] = [numTurnsTaken]

def takeOneTurn():
	global numTurnsTaken
	global lastNumberSpoken
	global lastTwoTurnsWhenSpoken
	
	whenSpoken = lastTwoTurnsWhenSpoken[lastNumberSpoken]
	if len(whenSpoken) == 1:
		speak(0)
	else:
		speak(whenSpoken[-1] - whenSpoken[-2])

def play(inputNums, numTurns):
	global numTurnsTaken
	global lastNumberSpoken
	global lastTwoTurnsWhenSpoken
	
	for n in inputNums:
		speak(n)
	while numTurnsTaken < numTurns:
		takeOneTurn()
	print(lastNumberSpoken)

play([0, 3, 6], 30_000_000)
```
