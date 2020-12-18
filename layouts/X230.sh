#!/usr/bin/env bash
# layout of a ThinkPad X230 notebook's keyboard

# Edit this to match the *keysyms* of your keyboard+layout. Use "EOL" to break rows. (Use `xev` to figure out your keysyms.)
declare -a keyLayout=( \
XF86AudioMute XF86AudioLowerVolume XF86AudioRaiseVolume XF86AudioMicMute XF86Launch1 TINYFILL Power EOL \
XF86WLAN XF86WebCam XF86Display XF86MonBrightnessDown XF86MonBrightnessUp XF86AudioPrev XF86AudioPlay XF86AudioNext EOL \
Escape F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12 Home End Insert Delete EOL \
grave 1 2 3 4 5 6 7 8 9 0 minus equal BackSpace EOL \
Tab q w e r t y u i o p bracketleft bracketright bar EOL \
Escape a s d f g h j k l semicolon apostrophe Return EOL \
Shift z x c v b n m comma period slash Shift EOL \
Ctrl Mod4 Mod1 space Mod1 Print Ctrl EOL \
Prior Up Next EOL \
Left Down Right EOL \
button1 button2 button3 \
)

translateKeys() {
    case "$key" in # style the tiny keys
        Escape | XF86* | TINYFILL | Power | F[0-9]* | Home | End | Insert | Delete | Prior | Next | Up | Down | Left | Right)
            adhocStyle+=' font-size: var(--tiny-key-height); min-width: var(--tiny-key-width);' 
            ;;
    esac
    case "$key" in # Translate the keysym into what will be displayed. Edit to match what's physically on your keys.
        # These don't need to be in order. It's just easier to read that way.
        XF86AudioMute)        keyName='🔇' ;;
        XF86AudioLowerVolume) keyName='🔉' ;;
        XF86AudioRaiseVolume) keyName='🔊' ;;
        XF86AudioMicMute)     keyName='❌🎤' ;;
        XF86Launch1)          keyName='🚀' ;;
        TINYFILL)             adhocStyle+='min-width: calc(10 * var(--key-width));'; keyName=' ' ;;
        XF86WLAN)             keyName='📡' ;;
        XF86WebCam)           keyName='📸🎤' ;; 
        XF86Display)          keyName='📽' ;;
        XF86MonBrightnessDown)keyName='🌞-' ;;
        XF86MonBrightnessUp)  keyName='🌞+' ;;
        XF86AudioPrev)        keyName='|◂' ;;
        XF86AudioPlay)        keyName='▸⏸' ;;
        XF86AudioNext)        keyName='▸|' ;;
        Escape)               adhocStyle+='min-width: calc(1.3 * var(--key-width));'; keyName='Esc' ;;
        F[0-9]* | Home | End) ;;
        Insert)       keyName='Ins' ;;
        Delete)       adhocStyle+='min-width: calc(1.3 * var(--key-width));'; keyName='Del' ;;
        grave)        keyName='~' ;;
        minus)        keyName='-' ;;
        equal)        keyName='=' ;;
        BackSpace)    adhocStyle+='min-width: calc(2.2 * var(--key-width));'; keyName='Backsp' ;;
        Tab)          adhocStyle+='min-width: calc(1.5 * var(--key-width));' ;;
        bracketleft)  keyName='[' ;;
        bracketright) keyName=']' ;;
        bar)          adhocStyle+='min-width: calc(1.5 * var(--key-width));'; keyName='|' ;;
        #CapsLock
        semicolon)    keyName=';' ;;
        apostrophe)   keyName="'" ;;
        Return)       adhocStyle+='min-width: calc(2.5 * var(--key-width));' ;;
        Shift)        adhocStyle+='min-width: calc(2.5 * var(--key-width));' ;;
        comma)        keyName=',' ;;
        period)       keyName='.' ;;
        slash)        keyName='/' ;;
        Ctrl)         adhocStyle+='min-width: calc(1.3 * var(--key-width));' ;;
        Mod4)         keyName='🪟' ;;
        Mod1)         keyName='Alt' ;;
        space)        adhocStyle+='min-width: calc(6   * var(--key-width));' ;;
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
