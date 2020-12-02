#  Advent of Code 2020

This year I'm taking a different approach.  I'm doing it all in Swift, and putting all 25 of the puzzles in a single Cocoa app.  My intention is to build a UI that displays a list of the 25 days.  I can click on any of them to run my solution for that day's puzzle and and read my notes about it.

On some days the puzzle will lend itself to some kind of visual display of the solution, perhaps with some sort of animation.  I want to figure out a way to do that when it makes sense.

Technically I don't *have* to build a UI.  I could do all the work in `applicationDidFinishLaunching(_:)` and never even open a window.  I'd still enjoy the convenience of using an Xcode project to organize code and resources ("resources" in the sense of `Bundle.url(forResource:withExtension:)`).  The UI aspect is for fun and to practice relevant skills.


## Things to think about

- How I set up testing.  Seems I could improve.  Things to consider:
	- Part 1 and Part 2 have separate sets of tests.
	- Both sets of tests may or may not use the same inputs.
	- Right now I have the test inputs in text files, part of me thinks I should make more of the testing data-driven in this way, e.g. put the expected outputs in text files as well rather than in code.  And have some sort of config file that maps the two.  OTOH sometimes that might feel like overkill, like if the input and output are both short strings.  Think about the file format of the config file.  Maybe the config should be in code after all.
- Add more data structures and algorithms, e.g. `A*`, e.g. `CountedSet`.  I looked at the Swift algorithms stuff, it doesn't seem to be what I mean.  I could go through past years of my own code, and also of course look for stuff on GitHub and/or SPM.  Could be a good way to learn to use git modules and/or SPM.



