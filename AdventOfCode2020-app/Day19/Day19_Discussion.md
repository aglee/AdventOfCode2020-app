# Day 19 - Monster Messages

<https://adventofcode.com/2020/day/19>

The puzzle description for Part 1 used a small example where it was easy to list all valid strings for the grammar.  I looked at the "real" input and suspected maybe I could use that approach, but had a feeling it would be more useful to write a parser.  I had a repeat of the feeling I had yesterday, that it would have been helpful if my knowledge of grammars and parsers was stronger.

It turned out that for Part 2 I could reuse my Part 1 code with only a minor tweak.  I realized that even though loops had been introduced into the grammar, my recursion would still always terminate, because every level of recursion moved closer and closer to the end of the string.  The puzzle description warned that there were now infinitely many valid strings, but that was okay, because my approach had not been to generate all valid strings.

For Part 2 I had to change my array of rules to a dictionary, since the rule numbers were no longer all consecutive.  This required almost no changes other than the declaration.  I only had to force-unwrap dictionary lookups in two places -- `rules[x]` became `rules[x]!`.

