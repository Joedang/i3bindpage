#!/usr/bin/env bash
# Create an HTML file depicting i3 bindings.
# Joe Shields, 2020-12-13

configFile=config

declare -a keyLayout=( \
XF86AudioMute XF86AudioLowerVolume XF86AudioRaiseVolume XF86AudioMicMute XF86Launch1 EOL \
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

declare -A infoArray # holds the mouse-over text for each key
mode="" # tracks the current mode in the config file
while read -r line
do
    field=pre
    binding=""
    action=""
    for word in $line
    do
        if [[ "$field" == 'pre' && "$word" =~ bindsym ]]; then
            field=binding
        elif [ "$field" = binding ]; then
            binding="$word"
            field=action
        elif [ "$field" = action ]; then
            action+="$word "
        elif [[ "$field" == 'pre' && "$word" == mode ]];then
            echo FOUND A MODE
            echo full line: "$line"
            echo
            field=mode
            mode=""
        elif [[ "$field" = mode && "$word" != "{" ]];then
            mode+=" $word"
        elif [[ -n "$mode" && "$word" =~ '^}' ]];then
            mode=NOMODE
            echo EXITING MODE: "$mode"
            echo full line: "$line"
            echo
        fi
    done
    if [ -n "$action" ]; then
        key=${binding##*+}
        echo full line: "$line"
        echo binding: "$binding"
        echo key: "$key"
        echo action: "$action"
        echo mode: "$mode"
        echo
        #keyArray
        [[ -n "$mode" ]] && infoArray["$key"]+="in$mode mode:"$'\n'
        infoArray["$key"]+="$binding"$'\n'
        infoArray["$key"]+=$'\t'"$action"$'\n'
        infoArray["$key"]+=$'--------------------\n'
        #bindArray["$key"]="$binding"
        #actionArray["$key"]="$action"
    fi
done < <(\
            sed -r -e '
                s/#[^"'\'']*//;
                s/^\s*#.*//;
                s/^\s*bindsym\s*--[[:alnum:]]*/bindsym/; 
                s/exec\s*--[[:alnum:]-]*//; 
                ' "$configFile"\
                | sed -r -e ':x /\\$/ { N; s/\\\n//g ; bx }; s/\s+/ /g;'\
        ) # remove unnecessary stuff (continued lines, bindsym flags, exec flags, multi-spaces, comments)


#declare -a keyLayout=(q w e r t y)
#declare -a row0=( XF86AudioMute XF86AudioLowerVolume XF86AudioRaiseVolume XF86AudioMicMute XF86Launch1 )
#declare -a row1=( Escape F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12 Home End Delete)
#declare -a row2=( grave 1 2 3 4 5 6 7 8 9 0 minus equal BackSpace)
#declare -a row3=(Tab q w e r t y u i o p bracketleft bracketright bar)
#declare -a keyLayout=('q' 'w' 'e' 'r' 't' 'y' 'u' 'i' 'o' 'p' '[' ']' '\' 'a' 's' 'd' 'f' 'g' 'h' 'j' 'k' 'l' ';' \' 'z' 'x' 'c' 'v' 'b' 'n' 'm' ',' '.' '/')
#lenBinds=${#bindArray[@]}
#lenActions=${#actionArray[@]}
lenLayout=${#keyLayout[@]}
#echo length of binding array: $lenBinds
#echo length of action array: $lenActions
#echo length of layout: $lenLayout
#echo ---------- Here\'s the layout... ----------
#for (( i=0; i<lenLayout; ++i ))
#do
#    key="${keyLayout[$i]}"
#    echo i: $i
#    echo key: $key
#    #echo binding: "${bindArray[$key]}"
#    #echo action: "${actionArray[$key]}"
#    echo info: "${infoArray[$key]}"
#    echo
#done
{
    echo '
        <!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="UTF-8" />
        <link rel="stylesheet" href="main.css">
        <style>
        :root { 
            --color-default-fg: var(--color-misc-fg); 
            --key-width: 4%;
            --tiny-key-height: 12pt;
            --tiny-key-width: 3%
        }
        </style>
        <base target="_blank" rel="noopener noreferrer">
        <title>Keyboard Bindings</title>
        </head>
        <body>
        <h1 style="text-align: center;">Keyboard Bindings</h1>
    '
    for (( i=0; i<lenLayout; ++i ))
    do
        key="${keyLayout[$i]}"
        adhocStyle=""
        keyName=$key
        # Translate the keysym into what will be displayed. Edit to match what's on your keyboard.
        case "$key" in 
            XF86AudioMute)        keyName='🔇' ;;
            XF86AudioLowerVolume) keyName='🔉' ;;
            XF86AudioRaiseVolume) keyName='🔊' ;;
            XF86AudioMicMute)     keyName='❌🎤' ;;
            XF86Launch1)          keyName='🚀' ;;
            Escape)               adhocStyle='min-width: calc(1.3 * var(--key-width)); font-size: var(--tiny-key-height);'; keyName='Esc' ;;
            F[0-9]* | Home | End) adhocStyle=' font-size: var(--tiny-key-height); min-width: var(--tiny-key-width);' ;;
            #Home)         adhocStyle=' font-size: var(--tiny-key-height);' ;;
            #End)          adhocStyle=' font-size: var(--tiny-key-height);' ;;
            Insert)       adhocStyle=' font-size: var(--tiny-key-height); min-width: var(--tiny-key-width);'; keyName='Ins' ;;
            Delete)       adhocStyle='min-width: calc(1.3 * var(--key-width)); font-size: var(--tiny-key-height);'; keyName='Del' ;;
            grave)        keyName='~' ;;
            minus)        keyName='-' ;;
            equal)        keyName='=' ;;
            BackSpace)    adhocStyle='min-width: calc(2.2 * var(--key-width));'; keyName='Backsp' ;;
            Tab)          adhocStyle='min-width: calc(1.5 * var(--key-width));' ;;
            bracketleft)  keyName='[' ;;
            bracketright) keyName=']' ;;
            bar)          adhocStyle='min-width: calc(1.5 * var(--key-width));'; keyName='|' ;;
            #CapsLock
            semicolon)    keyName=';' ;;
            apostrophe)   keyName="'" ;;
            Return)       adhocStyle='min-width: calc(2.5 * var(--key-width));' ;;
            Shift)        adhocStyle='min-width: calc(2.5 * var(--key-width));' ;;
            comma)        keyName=',' ;;
            period)       keyName='.' ;;
            slash)        keyName='/' ;;
            Ctrl)         adhocStyle='min-width: calc(1.3 * var(--key-width));' ;;
            Mod4)         keyName='Sup' ;;
            Mod1)         keyName='Alt' ;;
            space)        adhocStyle='min-width: calc(6   * var(--key-width));' ;;
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
        if [[ "$key" == "EOL" ]];then
            #echo "<div class=key style=\"width: 100%;\"></div>"
            echo "<hr/>"
        else
            if [[ "${infoArray[$key]}" == "" ]];then
                echo "<div class=key title=\"$key is unbound\" style=\"background: black; $adhocStyle\">$keyName</div>"
            else
                friendlyInfo="$(echo "key: $key"$'\n--------------------\n'"${infoArray[$key]}" | sed 's/"/\&quot;/g' )"
                echo -E "<div class=key title=\"$friendlyInfo\" style=\"$adhocStyle\">$keyName</div>"
            fi
        fi
    done
    echo '
        </body>
        </html>
    '
} > bindings.html
