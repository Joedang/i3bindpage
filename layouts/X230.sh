#!/usr/bin/env bash
# layout of a ThinkPad X230 notebook's keyboard

# Edit this to match the *keysyms* of your keyboard+layout. Use "EOL" to break rows. (Use `xev` to figure out your keysyms.)
declare -a keyLayout=( \
XF86AudioMute XF86AudioLowerVolume XF86AudioRaiseVolume XF86AudioMicMute XF86Launch1 TINYFILL Power EOL \
XF86Lock XF86Sleep XF86WLAN XF86WebCam XF86Display XF86MonBrightnessDown XF86MonBrightnessUp XF86AudioPrev XF86AudioPlay XF86AudioNext EOL \
Escape F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12 Home End Insert Delete EOL \
grave 1 2 3 4 5 6 7 8 9 0 minus equal BackSpace EOL \
Tab q w e r t y u i o p bracketleft bracketright bar EOL \
Caps_Lock a s d f g h j k l semicolon apostrophe Return EOL \
Shift_L z x c v b n m comma period slash Shift_R EOL \
FUNCTION Control_L Mod4 Mod1 space Mod1 Print Control_R ARROWFILL EOL \
Prior Up Next EOL \
Left Down Right EOL \
button1 button2 button3 \
)

# Any key rebindings you use should go here. [physical key]=what it acts like
#(This doesn't work well with swapped keys. That would be better of descibed in the layout.)
declare -A keyAliases=( \
    [Shift_L]=Shift [Shift_R]=Shift [grave]=asciitilde [Caps_Lock]=Escape [Contrl_L]=Ctrl [Control_R]=Ctrl \
)

# Use this to add layout-specific CSS. (applied after main.css)
# This is mainly useful for very large/small keyboards,
# keyboards that have extra wide/narrow keys, 
# or when you want to use color to help differentiate keyboard layouts.
addedCSS='
:root {
    --key-width: 60px;
    --tiny-key-width: calc(0.855 * var(--key-width));
    /*
    --color-main-fg: pink;
    --tiny-key-height: calc(0.3 * var(--key-width));
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
    # Protip: If you add up the key widths for each row, you should get the same number for each row. (usually a whole number)
    # X230: normal rows add up to 15*--key-width, tiny rows add up to 17.5*--tiny-key-width.
    case "$key" in # style the tiny keys
        Escape | XF86* | TINYFILL | Power | F[0-9]* | Home | End | Insert | Delete | Prior | Next | Up | Down | Left | Right)
            adhocStyle+=' font-size: var(--tiny-key-height); min-width: var(--tiny-key-width);' 
            ;;
    esac
    case "$key" in 
        *FILL*) adhocStyle+=' opacity: 0.2;' ;;
    esac
    case "$key" in # Translate the keysym into what will be displayed. Edit to match what's physically on your keys.
        # These don't need to be in order. It's just easier to read that way.
        XF86AudioMute)        keyName='🔇' ;;
        XF86AudioLowerVolume) keyName='🔉' ;;
        XF86AudioRaiseVolume) keyName='🔊' ;;
        XF86AudioMicMute)     keyName='❌🎤' ;;
        XF86Launch1)          keyName='🚀' ;;
        TINYFILL)             adhocStyle+='min-width: calc(11.5 * var(--tiny-key-width));'; keyName=' ' ;;
        XF86Lock)             keyName='🔒' ;;
        XF86Sleep)            keyName='🌜' ;;
        XF86WLAN)             keyName='📡' ;;
        XF86WebCam)           keyName='📸🎤' ;; 
        XF86Display)          keyName='📽' ;;
        XF86MonBrightnessDown)keyName='🌞-' ;;
        XF86MonBrightnessUp)  keyName='🌞+' ;;
        XF86AudioPrev)        keyName='|◂' ;;
        XF86AudioPlay)        keyName='▸⏸' ;;
        XF86AudioNext)        keyName='▸|' ;;
        Power)                keyName='⏻' ;;
        Escape)               adhocStyle+='min-width: calc(1.25 * var(--tiny-key-width));'; keyName='Esc' ;;
        F[0-9]* | Home | End) ;;
        Insert)       keyName='Ins' ;;
        Delete)       adhocStyle+='min-width: calc(1.25 * var(--tiny-key-width));'; keyName='Del' ;;
        grave)        keyName='~' ;;
        minus)        keyName='-' ;;
        equal)        keyName='=' ;;
        BackSpace)    adhocStyle+='min-width: calc(2.00 * var(--key-width));'; keyName='Backsp' ;;
        Tab)          adhocStyle+='min-width: calc(1.50 * var(--key-width));' ;;
        bracketleft)  keyName='[' ;;
        bracketright) keyName=']' ;;
        bar)          adhocStyle+='min-width: calc(1.50 * var(--key-width));'; keyName='|' ;;
        Caps_Lock)    adhocStyle+='min-width: calc(1.75 * var(--key-width));'; keyName='Caps' ;;
        semicolon)    keyName=';' ;;
        apostrophe)   keyName="'" ;;
        Return)       adhocStyle+='min-width: calc(2.25 * var(--key-width));' ;;
        Shift_L)      adhocStyle+='min-width: calc(2.25 * var(--key-width));' ;;
        Shift_R)      adhocStyle+='min-width: calc(2.75 * var(--key-width));' ;;
        Shift)        adhocStyle+='min-width: calc(2.50 * var(--key-width));' ;;
        comma)        keyName=',' ;;
        period)       keyName='.' ;;
        slash)        keyName='/' ;;
        FUNCTION)     keyName='Fn' ;;
        Ctrl)         adhocStyle+='min-width: calc(1.25 * var(--key-width));' ;;
        Control_L)    adhocStyle+='min-width: calc(1.25 * var(--key-width));'; keyName='Ctrl' ;;
        Mod4)         keyName='🪟' ;;
        Mod1)         keyName='Alt' ;;
        space)        adhocStyle+='min-width: calc(5.00   * var(--key-width));' ;;
        Control_R)    keyName='Ctrl';;
        ARROWFILL)    adhocStyle+='min-width: calc(2.75 * var(--key-width));'; keyName=' ' ;;
        Prior)        keyName='PgUp' ;;
        Next)         keyName='PgDn' ;;
        Up)           keyName='↑' ;;
        Down)         keyName='↓' ;;
        Left)         keyName='←' ;;
        Right)        keyName='→' ;;
        button1)      keyName='left click' ;;
        button2)      keyName='middle click' ;;
        button3)      keyName='right click' ;;
    esac
}
