# Vim Tricks

## Movement and actions
- <action>i: action on inside, use with (,",',w
- <action>a: action around, use with w to apply on the word
- =%: indent code
- f<char>: goto char in same line, cycle through ;, combine with df)
- vt<char>: visually select till a char
- 0<C-v>jjjjjI--: comment the line using -- for j times (movement) 
- pressing o while in visual mode enables you to change and move the other end of visual block
- viW: selects everything till a white space
- =ap: indent an entire paragraph, yap, vap
- move quickly by skipping sentences using ( and )
- press * or # when on a word to land on the next occurrence effortlessly
- use e and b combination to move quickly from word to word, switch to w when required
- zz: center screen on cursor

## g for goat, g for :g/re/p
An underrated command
- `:g/re` will print at the bottom of the screen all lines matching pattern `re` (default command `p` is used here)
- `:g/pattern/normal @a` plays the `a` macro on all lines matching pattern
- `:g/console/g/two/d` is an example of recursive command, `console` first matches lines containing `console` and then second g filters out matches containing `two` from the earlier matched, then applies `d` command
- `:g/pattern/command` the following form also works: `:g/pattern1/,/pattern2/command` with this, Vim will apply the command within pattern1 and pattern2
    - `/^$/` matches empty lines (with no character)
    - `:g/^$/,/./j` basically matches empty lines (`^$`) and non empty lines (`.`) and joins them (`j`)
- Delimiter can be changed like the substitute command, use any character except for alphabets, numbers, ", |, and \.
    - `:g@console@d` deletes all lines containing console
    - `:g@one@s+const+let+g` matches lines containing one and then uses the substitute to replace const with let (last g for applying substitute on all matches within the matched lines)
- `:g/TODO/t $` copies all lines matching pattern `TODO` at the end of file (:h :copy)
    - Invert also works `:g!/TODO/t $` copy everything except TODOs at end of file
    - `:g/TODO/m $` moves all TODOs instead of copying them
- `:g/console/d _` deletes all lines matching pattern `console` and puts them in black hole register `_`

## References
- https://learnvim.irian.to/basics/registers
