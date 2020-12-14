#  Advent of Code 2020

This year I'm taking a different approach.  I'm doing it all in Swift, and putting all 25 of the puzzles in a single Cocoa app.  My intention is to build a UI that displays a list of the 25 days.  I can click on any of them to run my solution for that day's puzzle and and read my notes about it.

On some days the puzzle will lend itself to some kind of visual display of the solution, perhaps with some sort of animation.  I want to figure out a way to do that when it makes sense.

Technically I don't *have* to build a UI.  I could do all the work in `applicationDidFinishLaunching(_:)` and never even open a window.  I'd still enjoy the convenience of using an Xcode project to organize code and resources ("resources" in the sense of `Bundle.url(forResource:withExtension:)`).  The UI aspect is for fun and to practice relevant skills.


## Things to think about

- Add more data structures and algorithms, e.g. `A*`, e.g. `CountedSet`.  I looked at the Swift algorithms stuff, it doesn't seem to be what I mean.  I could go through past years of my own code, and also of course look for stuff on GitHub and/or SPM.  Could be a good way to learn to use git modules and/or SPM.
	- Add tests for my Common stuff, partly to burn the ideas into my brain a little better, partly just because it feels nice to see things work correctly, partly to learn how to use Xcode's testing setup.
- What's the deal with Xcode always forcing my `.txt` files to end with a newline?  Doesn't matter for my purposes, just wondering.
- I've been copy-pasting the puzzle descriptions as plain text and adding a bit of Markdown.  The result looks fine but doesn't capture all the highlighting and links.  Would it be worth grabbing the HTML and CSS instead?  Or maybe pasting into .rtf files rather than plain text?  I'd only grab the problem descriptions, not the surrounding stuff like ads and site navigation.
- Should I put the correct final answers I got somewhere, so when I run the code later I can have the satisfaction of seeing it still works on the real data and not just the test data?  I haven't been wanting to, out of perhaps a misguided concern about spoilers/cheating.  Perhaps it's even less of a concern this year, since I'm not posting my solutions publicly right away.




