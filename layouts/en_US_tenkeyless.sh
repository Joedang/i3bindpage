#!/usr/bin/env bash
# layout of a generic US "tenkeyless" keyboard

# Edit this to match the *keysyms* of your keyboard+layout. Use "EOL" to break rows. (Use `xev` to figure out your keysyms.)
declare -a keyLayout=( \
Escape ESCFILL F1 F2 F3 F4 FXNFILL F5 F6 F7 F8 FXNFILL F9 F10 F11 F12   RIGHTFILL Print     Scroll_Lock Break     EOL \
grave   1 2 3 4 5 6 7 8 9 0 minus equal         BackSpace               RIGHTFILL Insert    Home        Prior     EOL \
Tab      q w e r t y u i o p bracketleft bracketright bar               RIGHTFILL Delete    End         Next      EOL \
Caps_Lock a s d f g h j k l semicolon apostrophe   Return               RIGHTFILL ARROWFILL ARROWFILL   ARROWFILL EOL \
Shift_L    z x c v b n m comma period slash       Shift_R               RIGHTFILL ARROWFILL Up          ARROWFILL EOL \
Ctrl Mod4 Mod1        space       Mod1 Mod4 FUNCTION Ctrl               RIGHTFILL Left      Down        Right     EOL \
button1 button2 button3 \
)

# Any key rebindings you use should go here. [physical key]=what it acts like
#(This doesn't work well with swapped keys. That would be better descibed in the layout.)
declare -A keyAliases=( \
    [Shift_L]=Shift [Shift_R]=Shift [grave]=asciitilde \
)

# Use this to add layout-specific CSS. (applied after main.css)
# This is mainly useful for very large/small keyboards,
# keyboards that have extra wide/narrow keys, 
# or when you want to use color to help differentiate keyboard layouts.
addedCSS='
:root {
    --key-width: 40px;
    --color-main-fg: pink;
    /*
    --tiny-key-height: calc(0.3 * var(--key-width));
    --tiny-key-width: calc(0.82 * var(--key-width));
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

translateKeys() {
    # Use this to tweak how individual keys (or groups of keys) appear.
    # keyName is what's printed on the physical keycap.
    # Appending to adhocStyle adds CSS to the element.
    case "$key" in # style the tiny keys
        ESCFILL | FXNFILL | RIGHTFILL | ARROWFILL)
            adhocStyle+=' opacity: 0.5;'
            keyName=''
            ;;
    esac
    case "$key" in # Translate the keysym into what will be displayed. Edit to match what's physically on your keys.
        # These don't need to be in order. It's just easier to read that way.
        Escape)               adhocStyle+='min-width: calc(1.3 * var(--tiny-key-width));'; keyName='Esc' ;;
        F[0-9]* | Home | End) ;;
        FXNFILL)      adhocStyle+='min-width: calc(0.4 * var(--key-width))' ;;
        RIGHTFILL)    adhocStyle+='min-width: calc(0.25 * var(--key-width))' ;;
        Print)        keyName='Pscr' ;;
        Scroll_Lock)  keyName='ScLk' ;;
        Break)        keyName='PaBr' ;;
        Insert)       keyName='Ins' ;;
        Delete)       adhocStyle+='min-width: calc(1.3 * var(--tiny-key-width));'; keyName='Del' ;;
        Prior)        keyName='PgUp' ;;
        Next)         keyName='PgDn' ;;
        grave)        keyName='~' ;;
        minus)        keyName='-' ;;
        equal)        keyName='=' ;;
        BackSpace)    adhocStyle+='min-width: calc(2.2 * var(--key-width));'; keyName='Backsp' ;;
        Tab)          adhocStyle+='min-width: calc(1.6 * var(--key-width));' ;;
        bracketleft)  keyName='[' ;;
        bracketright) keyName=']' ;;
        bar)          adhocStyle+='min-width: calc(1.6 * var(--key-width));'; keyName='|' ;;
        Caps_Lock)    adhocStyle+='min-width: calc(1.9 * var(--key-width));' ;;
        semicolon)    keyName=';' ;;
        apostrophe)   keyName="'" ;;
        Return)       adhocStyle+='min-width: calc(2.5 * var(--key-width));' ;;
        Shift_L)      adhocStyle+='min-width: calc(2.5 * var(--key-width));' ;;
        Shift_R)      adhocStyle+='min-width: calc(3.2 * var(--key-width));' ;;
        Shift)        adhocStyle+='min-width: calc(2.7 * var(--key-width));' ;;
        comma)        keyName=',' ;;
        period)       keyName='.' ;;
        slash)        keyName='/' ;;
        FUNCTION)     keyName='Fn' ;;
        Ctrl)         adhocStyle+='min-width: calc(1.3 * var(--key-width));' ;;
        Mod4)         keyName='🪟' ;;
        Mod1)         keyName='Alt' ;;
        space)        adhocStyle+='min-width: calc(9   * var(--key-width));' ;;
        #ARROWFILL)    adhocStyle+='min-width: calc(3.3 * var(--key-width));'; keyName=' ' ;;
        Up)           keyName='↑' ;;
        Down)         keyName='↓' ;;
        Left)         keyName='←' ;;
        Right)        keyName='→' ;;
        button1)      keyName='left click' ;;
        button2)      keyName='middle click' ;;
        button3)      keyName='right click' ;;
    esac
}
