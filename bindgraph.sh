#!/usr/bin/env bash
# Create an HTML file depicting i3 bindings.
# Joe Shields, 2020-12-13

configFile=config # location of your i3 config file
output=bindings.html # file to be [over]written

# Edit this to match the *keysyms* of your keyboard+layout. Use "EOL" to break rows. (Use `xev` to figure out your keysyms.)
declare -a keyLayout=( \
XF86AudioMute XF86AudioLowerVolume XF86AudioRaiseVolume XF86AudioMicMute XF86Launch1 EOL \
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
translateNames() {
    # Translate the keysym into what will be displayed. Edit to match what's physically on your keyboard.
    case "$key" in 
        Escape | XF86* | F[0-9]* | Home | End | Insert | Delete | Prior | Next | Up | Down | Left | Right)
            adhocStyle+=' font-size: var(--tiny-key-height); min-width: var(--tiny-key-width);' 
            ;;
    esac
    case "$key" in 
        XF86AudioMute)        keyName='🔇' ;;
        XF86AudioLowerVolume) keyName='🔉' ;;
        XF86AudioRaiseVolume) keyName='🔊' ;;
        XF86AudioMicMute)     keyName='❌🎤' ;;
        XF86Launch1)          keyName='🚀' ;;
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

declare -A infoArray # holds the mouse-over text for each key
lenLayout=${#keyLayout[@]} # length of the layout array
mode="" # tracks the current mode in the config file
while read -r line # parse the config file
do
    field=pre # tracks the field being looking at
    binding="" # records the current binding being looked at
    action="" # records the action associated with the binding
    for word in $line
    do # This is realy dirty and only correctly parses *most* valid config files.
        if [[ "$field" == 'pre' && "$word" =~ bindsym ]]; then
            field=binding
        elif [ "$field" = binding ]; then
            binding="$word"
            field=action
        elif [ "$field" = action ]; then
            action+="$word "
        elif [[ "$field" == 'pre' && "$word" == mode ]];then
            field=mode
            mode=""
        elif [[ "$field" = mode && "$word" != "{" ]];then
            mode+=" $word"
        elif [[ -n "$mode" && "$word" =~ '^}' ]];then
            mode=""
        fi
    done
    if [ -n "$action" ]; then
        key=${binding##*+} # i3 only has single key (multi-modifier) bindings. Grab the last thing in the binding.
        [[ -n "$mode" ]] && infoArray["$key"]+="in$mode mode:"$'\n'
        infoArray["$key"]+="$binding"$'\n'
        infoArray["$key"]+=$'\t'"$action"$'\n'
        infoArray["$key"]+=$'--------------------\n'
        if [[ ! "${keyLayout[@]}" =~ "$key" ]];then
            echo "Warning: $key appears in your i3 config, but not this keyboard layout." 1>&2
            [[ "${orphanKeys[@]}" =~ "$key" ]] || orphanKeys+=("$key")
        fi
    fi
# Munge the raw config. Remove obvious comments, flags to bindsym, exec plus its flags, continued lines, and multi-spaces.
done < <(\
            sed -r -e '
                s/#[^"'\'']*//;
                s/^\s*#.*//;
                s/^\s*bindsym\s*--[[:alnum:]]*/bindsym/; 
                s/exec\s*--[[:alnum:]-]*//; 
                ' "$configFile"\
                | sed -r -e ':x /\\$/ { N; s/\\\n//g ; bx }; s/\s+/ /g;'\
        ) 

{ # write the output
    cat head.html
    declare -a orphanKeys
    for (( i=0; i<lenLayout; ++i ))
    do
        key="${keyLayout[$i]}"
        adhocStyle=""
        keyName=$key
        translateNames
        if [[ "$key" == "EOL" ]];then
            echo "<br/>"
        else
            if [[ "${infoArray[$key]}" == "" ]];then
                echo "<div class=key title=\"$key is unbound\" style=\"background: black; $adhocStyle\">$keyName</div>"
            else
                friendlyInfo="$(echo "key: $key"$'\n--------------------\n'"${infoArray[$key]}" | sed 's/"/\&quot;/g' )"
                echo -E "<div class=key title=\"$friendlyInfo\" style=\"$adhocStyle\">$keyName</div>"
            fi
        fi
    done
    if [[ "${#orphanKeys[@]}" > 0 ]];then
        echo "<br/>Warning: the following keys appear in your i3 config, but not this keyboard layout:<br>${orphanKeys[@]}"
    fi
    echo ' </body> </html> '
} > "$output"
exit 0
