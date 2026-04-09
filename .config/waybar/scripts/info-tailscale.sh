#!/bin/sh

ICON_ACTIVE_TAILSCALE="    Tailscale"
ICON_INACTIVE=""
ICON_BOTH_ACTIVE=""

# Check Tailscale status
status_tailscale=$(curl --silent --fail --unix-socket /var/run/tailscale/tailscaled.sock http://local-tailscaled.sock/localapi/v0/status)

if [ $? != 0 ]; then
    status_tailscale="Stopped"
fi

# Determine Tailscale status
if [ "$(echo ${status_tailscale} | jq --raw-output .BackendState)" = "Running" ]; then
    tailscale_active=1
else
    tailscale_active=0
fi


# Determine the overall status and display the appropriate icon
if [ ${tailscale_active} -eq 1 ] && [ ${mullvad_active} -eq 1 ]; then
    echo "${ICON_BOTH_ACTIVE}"
elif [ ${tailscale_active} -eq 1 ]; then
    echo "${ICON_ACTIVE_TAILSCALE}"
else
    echo "${ICON_INACTIVE}"
fi

