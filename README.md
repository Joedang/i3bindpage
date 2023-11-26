# Bindgraph
Create an HTML file depicting i3 bindings.

This script provides a visual quick-reference of what keys you have bound in i3 and what they do.
This is useful when you have lots of bindings and you're having trouble keeping track of them.

It parses your i3 configuration file in a jenky way, 
generates an HTML file showing which keys are bound, 
and opens that file in a program of your choice.
Keys are depicted as outlined/highlighted HTML elements.
Info about what action a binding triggers is shown as mouse-over text.

# Examples
TODO: images go here

# Dependencies
This is meant to be very hackable and portable.
It uses pure/organic/vanilla/original-recipe HTML, CSS, and Bash (plus some Sed and Cat).

# Files
## layouts/\*.sh
If you want to change the appearance of a particular layout, this is where you should do it.
Each of these files defines a keyboard layout and the exceptions for its appearance.
You can control:  
- the geometric layout of the keys;
- CSS that applies to that particular layout;
- equivalent/remapped key symbols;
- the labels that appear on the keys (important for media keys);
- and the appearance of individual keys (important for large/small keys).  

Check the comments and syntax of the example layouts if you want to make a layout for a special keyboard.
If you do make a new layout, please submit a pull request!

## bindgraph.sh
This is the main script.
It's responsible for parsing the i3 configuration file and generating the HTML.
You shouldn't need to modify this unless you need to fix the parsing to account for weird edge cases 
or change the format of the mouse-over text.
The parsing is a little jenky and does not account for all possible i3 config files. 
It assumes the config is written in a relatively sane style.

TODO: assumptions about the i3 config file

## main.css
This provides the styling info for the HTML.

## head.html
This provides some simple HTML for the start of the output file.

# TODO
- [P] Read from a config file, rather than having the config in the head of the script.
    - [ ] Allow that config to override `main.css`.
- [ ] Maybe use a couple of arrays rather than the giant case statement in `translateKeys()`?
- [ ] Look into light-weight programs that can display things as a pop-up.
- [ ] Do the layout for my CM Storm, so there's another example of a keyboard with lots of function keys.
- [ ] Maybe do an example with some depiction of a mouse with lots of buttons.
- [ ] Get rid of the Sed and Cat dependencies for KoolKid Points™.
