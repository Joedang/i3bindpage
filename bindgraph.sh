#!/usr/bin/env bash
# Create an HTML file depicting i3 bindings.
# Joe Shields, 2020-12-13

configFile=/home/joedang/.config/i3/config # location of your i3 config file
outputDir=/tmp
cssFile=/home/joedang/src/bash/bindgraph/main.css
headFile=/home/joedang/src/bash/bindgraph/head.html
#source /home/joedang/src/bash/bindgraph/layouts/X230.sh # choose your layout (or write your own)
source /home/joedang/src/bash/bindgraph/layouts/en_US_tenkeyless.sh # choose your layout (or write your own)
BROWSER=${BROWSER:=firefox} # open with firefox, if another default browser is not set

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
for key in "${!keyAliases[@]}"; do
    keyAlias="${keyAliases[$key]}"
    infoArray["$key"]+="${infoArray["$keyAlias"]}"
done

{ # write the output
    cat "$headFile"
    echo "<style>$addedCSS</style>"
    declare -a orphanKeys
    for (( i=0; i<lenLayout; ++i ))
    do
        key="${keyLayout[$i]}" # they keysym in question
        adhocStyle="" # the style that gets applied to the individual key
        keyName=$key # the display name of that key
        translateKeys # apply the keyName as per the keyboard layout script
        if [[ "$key" == "EOL" ]];then
            echo -n "<br/>"
        else
            if [[ "${infoArray[$key]}" == "" ]];then
                echo -n "<div class=key title=\"$key is unbound\" style=\"background: black; $adhocStyle\">$keyName</div>"
            else
                friendlyInfo="$(echo "key: $key"$'\n--------------------\n'"${infoArray[$key]}" | sed 's/"/\&quot;/g' )"
                echo -nE "<div class=key title=\"$friendlyInfo\" style=\"$adhocStyle\">$keyName</div>"
            fi
        fi
    done
    if [[ "${#orphanKeys[@]}" > 0 ]];then
        echo -n "<br/>Warning: the following keys appear in your i3 config, but not this keyboard layout:<br>${orphanKeys[@]}"
    fi
    echo ' </body> </html> '
} > "$outputDir/bindings.html"
cp "$cssFile" "$outputDir/main.css"
"$BROWSER" "$outputDir/bindings.html"
exit 0
