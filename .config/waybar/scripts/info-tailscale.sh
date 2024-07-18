#!/bin/sh

ICON_ACTIVE_MULLVAD="    Mullvad"
ICON_ACTIVE_TAILSCALE="    Tailscale"
ICON_INACTIVE=""
ICON_BOTH_ACTIVE=""

# Check Tailscale status
status_tailscale=$(curl --silent --fail --unix-socket /var/run/tailscale/tailscaled.sock http://local-tailscaled.sock/localapi/v0/status)

if [ $? != 0 ]; then
    status_tailscale="Stopped"
fi

# Check Mullvad VPN status
status_mullvad=$(mullvad status | grep "Connected" | wc -l)

# Determine Tailscale status
if [ "$(echo ${status_tailscale} | jq --raw-output .BackendState)" = "Stopped" ]; then
    tailscale_active=0
else
    tailscale_active=1
fi

# Determine Mullvad VPN status
if [ "${status_mullvad}" -gt 0 ]; then
    mullvad_active=1
else
    mullvad_active=0
fi

# Determine the overall status and display the appropriate icon
if [ ${tailscale_active} -eq 1 ] && [ ${mullvad_active} -eq 1 ]; then
    echo "${ICON_BOTH_ACTIVE}"
elif [ ${tailscale_active} -eq 1 ]; then
    echo "${ICON_ACTIVE_TAILSCALE}"
elif [ ${mullvad_active} -eq 1 ]; then
    echo "${ICON_ACTIVE_MULLVAD}"
else
    echo "${ICON_INACTIVE}"
fi

