# Day 15 - Rambunctious Recitation

<https://adventofcode.com/2020/day/15>

I was a little better today -- not perfect, but a little better -- about doing things quick-and-(tolerably)-dirty until I got the right answer to Part 2, and only then tidying the code a little.

The approach in my solution was to remember the turn numbers on which each number was spoken.  I used a dictionary mapping each number that had ever been spoken to a list of turn numbers.

For Part 1 I remembered *all* the times each number was spoken.  That was fine for n = 2020, but way too slow for n = 30,000,000, which was Part 2.  Using printf's I could see every additional million turns was taking (IIRC) 10 seconds longer than the previous million turns.  It was a simple tweak to only remember the last two times each number was spoken, and that's how I got the answer to Part 2.  Even so, it took 24 seconds to run for 30,000,000 turns, on my first-gen M1 MBA.  This was so slow that I commented out all but one of the Part 2 tests.  I wondered if there was a pattern or formula in the sequence of spoken numbers that I could use to speed up the solution, but I couldn't spot one.

I checked /r/adventofcode and saw that other people were saving only a *single turn number* for each number spoken.  I had tried to come up with a solution along those lines but hadn't quite seen how.  But once I saw that such a solution existed, *now* I was able to see it, without even reading other people's solutions.  Interesting how knowing in advance that a solution exists affects ability to see it.  I've noticed the same when watching chess videos by [Agadmator](https://www.youtube.com/c/AGADMATOR/videos) and others.  There are winning moves I'd never have spotted on my own, but once the commentator pauses the game and asks if we can figure out what the winning move was, *then* I can sometimes spot it.

After committing my [initial solution](3abe6a182be4de3ed597df4ba48822fdf8d47f24), I modified it to use the single-number approach and now it runs in 7 seconds rather than 24 seconds.


## Python versions

For grins I transcribed my initial solution to Python and ran it in CodeRunner.  To my surprise, the test using [0, 3, 6] as input took even longer to run -- 61 seconds.  I see others got it running much faster than I did with Python though.

My Python solution is below.  It seems shockingly verbose compared to [this one](https://www.reddit.com/r/adventofcode/comments/kdf85p/2020_day_15_solutions/gfwh4vd/).

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
UPDATE: After improving my Swift solution to run in only 7 seconds (rather than 24), I transcribed that to Python, and the result (below) is also improved by a similar factor (21 seconds rather than 61).

```python
#!/usr/bin/env python3

class MemoryGame:
	def __init__(self):
		self.lastNumberSpoken = -1
		self.lastTurnNumber = 0
		self.history = dict()
	
	def play(self, inputNums, numTurns):
		for n in inputNums:
			self.speak(n)
		while self.lastTurnNumber < numTurns:
			self.speakNext()
		return self.lastNumberSpoken

	def speakNext(self):
		whenLastNumberWasPreviouslySpoken = self.history.get(self.lastNumberSpoken)
		if whenLastNumberWasPreviouslySpoken:
			self.speak(self.lastTurnNumber - whenLastNumberWasPreviouslySpoken)
		else:
			self.speak(0)

	def speak(self, n):
		if self.lastTurnNumber > 0:
			self.history[self.lastNumberSpoken] = self.lastTurnNumber
		self.lastTurnNumber += 1
		self.lastNumberSpoken = n

game = MemoryGame()
print(game.play([0, 3, 6], 30_000_000))
```
