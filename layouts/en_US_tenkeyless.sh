#!/usr/bin/env bash
# layout of a generic US "tenkeyless" keyboard
# Joe Shields, 2021-02-01
# vim: foldmethod=marker: foldmarker={{{,}}}:
layoutName='US English Tenkeyless'

# layout of keysyms in rows {{{
# Edit this to match the *keysyms* of your keyboard+layout. Use "EOL" to break rows. (Use `xev` to figure out your keysyms.)
declare -a keyLayout=( \
Escape ESCFILL F1 F2 F3 F4 FXNFILL F5 F6 F7 F8 FXNFILL F9 F10 F11 F12   RIGHTFILL Print     Scroll_Lock Break     EOL \
grave   1 2 3 4 5 6 7 8 9 0 minus equal         BackSpace               RIGHTFILL Insert    Home        Prior     EOL \
Tab      q w e r t y u i o p bracketleft bracketright bar               RIGHTFILL Delete    End         Next      EOL \
Caps_Lock a s d f g h j k l semicolon apostrophe   Return               RIGHTFILL ARROWFILL ARROWFILL   ARROWFILL EOL \
Shift_L    z x c v b n m comma period slash       Shift_R               RIGHTFILL ARROWFILL Up          ARROWFILL EOL \
Ctrl Mod4 Alt_L        space       Alt_R Mod4 Menu Ctrl               RIGHTFILL Left      Down        Right     EOL \
button1 button2 button3 \
)
# }}}

# keysym aliases {{{
# Any key rebindings you use should go here. [physical key]=what it acts like
#(This doesn't work well with swapped keys. That would be better descibed in the layout.)
declare -A keyAliases=( \
    [Shift_L]=Shift [Shift_R]=Shift [grave]=asciitilde [Contrl_L]=Ctrl [Control_R]=Ctrl [Alt_L]=Mod1 [Alt_R]=Mod1 \
)
# }}}

# layout-specific CSS {{{
# Use this to add layout-specific CSS. (applied after main.css)
# This is mainly useful for very large/small keyboards,
# keyboards that have extra wide/narrow keys, 
# or when you want to use color to help differentiate keyboard layouts.
addedCSS='
:root {
    --key-width: 60px;
    --color-main-fg: pink;
    /*
    --color-main-fg: skyblue;
    --color-highlight-fg: limegreen;
    --color-highlight-bg: #333;
    --color-bound-keys: #222;
    --color-default-bg: #111;
    --color-unbound-keys: black;
    --color-default-fg: var(--color-main-fg);
    */
}
'
# }}}

# key exceptions {{{
translateKeys() {
    # Use this to tweak how individual keys (or groups of keys) appear.
    # keyName is what's printed on the physical keycap.
    # Appending to adhocStyle adds CSS to the element.
    # Protip: If you add up the key widths for each row, you should get the same number for each row. (usually a whole number)
    case "$key" in # style gaps between keys
        ESCFILL | FXNFILL | RIGHTFILL | ARROWFILL)
            adhocStyle+=' opacity: 0.5;'
            keyName=''
            ;;
    esac
    case "$key" in
        Ctrl | Control_L | Control_R | Mod4 | Alt | Alt_L | Alt_R | Menu) # bottom row
            adhocStyle+='min-width: calc(1.25 * var(--key-width));'
            ;;
    esac
    case "$key" in # Translate the keysym into what will be displayed. Edit to match what's physically on your keys.
        # These don't need to be in order. It's just easier to read that way.
        # In this layout, rows are 18.5 keys wide.
        Escape)       keyName='Esc' ;;
        ESCFILL)      adhocStyle+='min-width: calc(1.0 * var(--key-width))' ;;
        F[0-9]* | End) ;;
        Home)         keyName='⌂' ;;
        FXNFILL)      adhocStyle+='min-width: calc(0.5 * var(--key-width))' ;;
        RIGHTFILL)    adhocStyle+='min-width: calc(0.25 * var(--key-width))' ;;
        Print)        keyName='Pnt' ;;
        Scroll_Lock)  keyName='ScL' ;;
        Break)        keyName='PBr' ;;
        Insert)       keyName='Ins' ;;
        Delete)       keyName='Del' ;;
        Prior)        keyName='PUp' ;;
        Next)         keyName='PDn' ;;
        grave)        keyName='~' ;;
        minus)        keyName='-' ;;
        equal)        keyName='=' ;;
        BackSpace)    adhocStyle+='min-width: calc(2 * var(--key-width));'; keyName='Backsp' ;;
        Tab)          adhocStyle+='min-width: calc(1.5 * var(--key-width));' ;;
        bracketleft)  keyName='[' ;;
        bracketright) keyName=']' ;;
        bar)          adhocStyle+='min-width: calc(1.5 * var(--key-width));'; keyName='|' ;;
        Caps_Lock)    adhocStyle+='min-width: calc(1.75 * var(--key-width));'; keyName='Caps' ;;
        semicolon)    keyName=';' ;;
        apostrophe)   keyName="'" ;;
        Return)       adhocStyle+='min-width: calc(2.25 * var(--key-width));' ;;
        Shift_L)      adhocStyle+='min-width: calc(2.25 * var(--key-width));' ;;
        Shift_R)      adhocStyle+='min-width: calc(2.75 * var(--key-width));' ;;
        Shift)        adhocStyle+='min-width: calc(2.5 * var(--key-width));' ;;
        comma)        keyName=',' ;;
        period)       keyName='.' ;;
        slash)        keyName='/' ;;
        Menu)         keyName='▤' ;;
        Ctrl)         ;;
        Mod4)         keyName='🪟' ;;
        Alt_L)        keyName='Alt' ;;
        space)        adhocStyle+='min-width: calc(6.25   * var(--key-width));' ;;
        Alt_L)        keyName='Alt' ;;
        Up)           keyName='↑' ;;
        Down)         keyName='↓' ;;
        Left)         keyName='←' ;;
        Right)        keyName='→' ;;
        button1)      keyName='left click' ;;
        button2)      keyName='middle click' ;;
        button3)      keyName='right click' ;;
    esac
}
# }}}
