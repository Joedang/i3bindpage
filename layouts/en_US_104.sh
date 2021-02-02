#!/usr/bin/env bash
# layout of a generic US 104-key keyboard
# Joe Shields, 2021-02-01
# vim: foldmethod=marker: foldmarker={{{,}}}: nowrap:
layoutName='US English 104-Key'

# layout of keysyms in rows {{{
# Edit this to match the *keysyms* of your keyboard+layout. Use "EOL" to break rows. (Use `xev` to figure out your keysyms.)
declare -a keyLayout=( \
Escape ESCFILL F1 F2 F3 F4 FXNFILL F5 F6 F7 F8 FXNFILL F9 F10 F11 F12 RIGHTFILL Print     Scroll_Lock Break     RIGHTFILL KPFILL EOL \
grave   1 2 3 4 5 6 7 8 9 0 minus equal         BackSpace             RIGHTFILL Insert    Home        Prior     RIGHTFILL Num_Lock KP_Divide KP_Multiply KP_Subtract EOL \
Tab      q w e r t y u i o p bracketleft bracketright bar             RIGHTFILL Delete    End         Next      RIGHTFILL KP_7 KP_8 KP_9  KP_Add      EOL \
Caps_Lock a s d f g h j k l semicolon apostrophe   Return             RIGHTFILL ARROWFILL ARROWFILL   ARROWFILL RIGHTFILL KP_4 KP_5 KP_6  KP_Add      EOL \
Shift_L    z x c v b n m comma period slash       Shift_R             RIGHTFILL ARROWFILL Up          ARROWFILL RIGHTFILL KP_1 KP_2 KP_3  KP_Enter    EOL \
Control_L Super_L Alt_L space Alt_R Super_R Menu Control_R            RIGHTFILL Left      Down        Right     RIGHTFILL KP_0 KP_Decimal KP_Enter    EOL \
button1 button2 button3 \
)
# }}}

# keysym aliases {{{
# Any key rebindings you use should go here. [physical key]=what it acts like
# (This doesn't work well with swapped keys. That would be better descibed in the layout.)
declare -A keyAliases=( \
    [Shift_L]=Shift [Shift_R]=Shift \
    [Contrl_L]=Ctrl [Control_R]=Ctrl \
    [Super_L]=Mod4 [Super_R]=Mod4 \
    [Alt_L]=Mod1 [Alt_R]=Mod1 \
    [grave]=asciitilde \
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
    --color-main-fg: blue;
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
        ESCFILL | FXNFILL | RIGHTFILL | ARROWFILL | KPFILL)
            adhocStyle+=' opacity: 0.0;'
            keyName=''
            ;;
    esac
    case "$key" in
        Ctrl | Control_* | Super_* | Mod4 | Alt | Alt_* | Menu) # bottom row
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
        Control_*)    keyName='Ctrl' ;;
        Super_*)      keyName='🪟' ;;
        Alt_*)        keyName='Alt' ;;
        space)        adhocStyle+='min-width: calc(6.25   * var(--key-width));' ;;
        KPFILL)       adhocStyle+=' min-width: calc(4 * var(--key-width))'; keyName='' ;;
        Num_Lock)     keyName='NL' ;;
        KP_Divide)    keyName='÷' ;;
        KP_Multiply)  keyName='×' ;;
        KP_Subtract)  keyName='-' ;;
        KP_1)         keyName='1' ;;
        KP_2)         keyName='2' ;;
        KP_3)         keyName='3' ;;
        KP_4)         keyName='4' ;;
        KP_5)         keyName='5' ;;
        KP_6)         keyName='6' ;;
        KP_7)         keyName='7' ;;
        KP_8)         keyName='8' ;;
        KP_9)         keyName='9' ;;
        KP_Add)       keyName='+' ;;
        KP_Enter)     keyName='↲' ;;
        KP_0)         adhocStyle+=' min-width: calc(2 * var(--key-width))'; keyName='0' ;;
        KP_Decimal)   keyName='.' ;;
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
