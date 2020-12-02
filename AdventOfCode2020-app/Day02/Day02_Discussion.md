# Day 2 - Password Philosophy

<https://adventofcode.com/2020/day/2>

Couple of occasions to use the pattern `myArray.filter( myTestCondition ).count`.  Used it to count occurrences of a character in a string (I suspect I overlooked a Foundation function that could have done it for me), and used it to count valid passwords.

I got the right answers by accident.  I had a bug where I was using a 0-based index even though the puzzle instructions explicitly remind us to use a 1-based index.  But this was offset by a bug in my parsing where I'd left a leading space in front of every password. :)



