
#!/bin/bash
# Perform Grep search
SEARCH_TERM=$1
PARAMS=$2
GREP_RAW=`grep --color=always --exclude-dir=.svn -nr"$2" "$1" * 2>/dev/null | sed 's/\[K\s\s*/[K/'`
 
# Fetch number of lines
GREP_LINES=`echo "$GREP_RAW" | wc -l`
# If there is enough output, send to pager, otherwise output directly
LINE_LIMIT=50
if [ "$LINE_LIMIT" -gt "$GREP_LINES" ]
then
    # Lines do not exceed limit, output directly to stdout
    echo "$GREP_RAW"
else
    echo "$GREP_RAW" | less -RX
fi