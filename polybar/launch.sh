#!/usr/bin/env bash

# terminate already runing bar instances
polybar-msg cmd quit

# launch main bar
echo "---" | tee -a /tmp/polybar.log
polybar main 2>&1 | tee -a /tmp/polybar.log & disown

echo "Bars launched..."
