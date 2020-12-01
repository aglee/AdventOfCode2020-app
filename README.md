#  Advent of Code 2020

This year I'm taking a different approach.  I'm doing it all in Swift, and putting all 25 of the puzzles in a single Cocoa app.  My intention is to build a UI that displays a list of the 25 days.  I can click on any of them to run my solution for that day's puzzle and and read my notes about it.

On some days the puzzle will lend itself to some kind of visual display of the solution, perhaps with some sort of animation.  I want to figure out a way to do that when it makes sense.

Technically I don't *have* to build a UI.  I could do all the work in `applicationDidFinishLaunching(_:)` and never even open a window.  I'd still enjoy the convenience of using an Xcode project to organize code and resources ("resources" in the sense of `Bundle.url(forResource:withExtension:)`).  The UI aspect is for fun and to practice relevant skills.



