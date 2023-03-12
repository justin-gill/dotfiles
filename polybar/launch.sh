#!/usr/bin/env bash

# terminate already runing bar instances
polybar-msg cmd quit

# launch example bar
echo "---" | tee -a /tmp/polybar.log
polybar example 2>&1 | tee -a /tmp/polybar.log & disown

echo "Bars launched..."
