#!/usr/bin/python3

# Based heavily on https://github.com/abaan404/dotfiles
import re
import subprocess, sys, os
import json, requests
import time
from pathlib import Path

def read_shell(command: list | str, shell: bool = False, ignore_error: bool = False, retry: bool = False, _attempts: int = 0, timeout: float | None = None) -> str:

    try:
        p = subprocess.run(command, shell=shell, stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=timeout)
    except subprocess.TimeoutExpired:
        return ""

    if p.returncode != 0:
        print(f"ERROR: {p.stderr.decode('utf-8').strip()}", file=sys.stderr)
        if retry and _attempts < 5:
            time.sleep(1)
            print(f"Retrying {command if isinstance(command, str) else ' '.join(command)} ... {_attempts}", file=sys.stderr)
            return read_shell(command, shell=shell, ignore_error=ignore_error, retry=retry, _attempts = _attempts + 1)

        if ignore_error:
            return ""

        exit(1)

    return p.stdout.decode("utf-8").strip()

class BaseListener:
    def __init__(self, follower_command: list | str, follower_pattern: str, shell: bool = False) -> None:
        self.follower_command = follower_command
        self.follower_pattern = follower_pattern
        self.shell = shell

    def execute(self) -> None:
        if not args.listen:
            return self.dispatch(self.read())
        self.listen()

    def listen(self) -> None:
        with subprocess.Popen(self.follower_command, stdout=subprocess.PIPE, shell=self.shell) as p: # TODO maybe use this to get info than just a hook? meh
            self.dispatch(self.read()) # send initial output
            while not p.poll() and p.stdout:
                output = p.stdout.readline().decode("utf-8")
                if re.match(self.follower_pattern, output):
                    self.dispatch(self.read())

    def dispatch(self, stdout: dict | list) -> None:
        if args.pprint:
            print(json.dumps(stdout, indent=2, ensure_ascii=False))
        else:
            print(json.dumps(stdout, ensure_ascii=False))

    def read(self) -> dict | list:
        ...

class SignalListener(BaseListener):
    def __init__(self, interval: int = 1) -> None:
        self.interval = interval
        self.registered = []

    # TODO maybe make this run on a seperate thread?
    @staticmethod
    def on_enable(var: str):
        def decorator(func):
            setattr(func, 'eww_variable', var)
            setattr(func, 'reset', False)
            return func
        return decorator

    @staticmethod
    def on_signal(var: str):
        def decorator(func):
            setattr(func, 'eww_variable', var)
            return func
        return decorator

    def listen(self) -> None:
        while True:
            for func in self.registered:
                var = getattr(func, 'eww_variable', None)
                data = read_shell(["eww", "get", var])

                if var is not None and data not in ["null", "false"]:
                    func(data)
                    if getattr(func, 'reset', True):
                        read_shell(["eww", "update", f"{var}=null"])

            time.sleep(self.interval)

    def read(self) -> dict | list:
        print(f"Invalid Operation, --listen must be provided for '{args.command}'", file=sys.stderr)
        return {}

class Wifi(SignalListener):
    def __init__(self) -> None:
        super().__init__()
        self.registered.extend([
            self.connect,
            self.scan
        ])

    @SignalListener.on_signal("s_wifi_connect")
    def connect(self, ssid) -> None:
        # TODO handle remembering wifi and open connections
        password = read_shell(["zenity", "--entry", "--hide-text", f"--text=Connecting to {ssid}"], ignore_error=True)
        if read_shell(["nmcli", "device", "wifi", "connect", ssid, "password", password], ignore_error=True):
            read_shell(["notify-send", f"Successfully connected to network {ssid}"])
        else:
            read_shell(["notify-send", f"Could not connect to network {ssid}"])

    @SignalListener.on_enable("s_wifi_scan")
    def scan(self, _) -> None:
        read_shell(["nmcli", "device", "wifi", "rescan"])

        buff = []
        for device in dict.fromkeys(read_shell(["nmcli", "-t", "-f", "SSID", "dev", "wifi", "list"]).split("\n")):
            buff.append({
                "ssid": device
            })
        self.dispatch(buff)

class Power(BaseListener):
    def __init__(self) -> None:
        super().__init__(["journalctl", "-fu", "lenovo-profile.service"], "(.+lenovo-profile)")

    def read(self) -> dict | list:
        status = read_shell(["journalctl", "-u", "lenovo-profile.service", "-n", "1"]).split()[-1]

        return {
            "status": status,
            "glyph": self.glyph(status)
        }

    def glyph(self, data) -> str:
        match data:
            case "Performance":
                return "󰓅 "
            case "Cooling":
                return " "
            case "Balanced":
                return "󰈐 "
            case _:
                return "󰈐 "

class Workspaces(BaseListener):
    def __init__(self) -> None:
        super().__init__(["socat", "-u", f"UNIX-CONNECT:/tmp/hypr/{os.environ['HYPRLAND_INSTANCE_SIGNATURE']}/.socket2.sock", "-"], "(workspace)")

        # persistent
        self.persistent = [
            {"id": 1, "glyph": ""},
            {"id": 2, "glyph": ""},
            {"id": 3, "glyph": "󰠮"},
            {"id": 4, "glyph": "󰝚"}
        ]

    def read(self):
        time.sleep(0.1) # weird bug in hyprctl causes same pinned windows to show up twice in `hyprctl workspaces` yeeeeeeee
        current = json.loads(read_shell(["hyprctl", "activeworkspace", "-j"]))["id"]
        workspaces = json.loads(read_shell(["hyprctl", "workspaces", "-j"]))
        active = [*self.persistent] # avoid referencing

        for workspace in workspaces:
            id = workspace.get("id")
            if id not in (x["id"] for x in active) and id > 0: # ignore scratchpad
                active.append({"id": id, "glyph": id})

        if current not in (x["id"] for x in active):
            active.append({"id": current, "glyph": ""})

        return {
            "active": active,
            "current": current
        }

class Network(BaseListener):
    def __init__(self) -> None:
        super().__init__("nmcli monitor & journalctl -fu bluetooth.service", "(.+\\sconnected|.+\\sdisconnected|Connectivity|.+bluetoothd)", shell=True)

    def read(self) -> list | dict:
        buff = {}
        buff["bluetooth"] = read_shell("bluetoothctl info | grep 'Name' | sed 's/\\sName:\\s//g'", shell=True) or None
        buff["ssid"] = None
        buff["type"] = None
        buff["device"] = None
        buff["connectivity"] = read_shell(["nmcli", "-t", "-f", "CONNECTIVITY", "general", "status"])

        status = read_shell(["nmcli", "device", "status"])
        for data in status.split("\n")[1:]: # ignore header
            device, device_type, device_state, device_connection = re.sub("(\\s(\\s+))", "|", data.strip()).split("|") # re.split is wack
            if args.types and device_type not in args.types:
                continue

            if device_state == "connected":
                buff["type"] = device_type
                buff["ssid"] = device_connection
                buff["device"] = device
                break

        return buff

class Audio(BaseListener):
    def __init__(self) -> None:
        super().__init__(["pactl", "subscribe"], ".+(sink|source|server)")

    def read(self) -> dict | list:
        buff = {}
        for output in ["sink"]:
            data = json.loads(read_shell(["pactl", "-f", "json", "list", f"{output}s"]))

            if isinstance(data, dict):
                data = [data]

            if args.default:
                data = self.default(data, output)

            if args.brief:
                data = self.brief(data)

            buff[output] = data

        return buff

    def default(self, data: list, output: str) -> list:
        default_device = read_shell(["pactl", f"get-default-{output}"])
        for i, device in enumerate(data):
            if device.get("name") == default_device:
                data.insert(0, data.pop(i))
                break

        return data

    def brief(self, data: list) -> list:
        buff = []
        for device in data:
            port = device.get("ports")
            buff.append({
                "name": device.get("name"),
                "alias": device.get("description"),
                "bus": device.get("properties").get("device.bus"),
                "mute": device.get("mute"),
                "volume": int(device.get("volume").get("front-left").get("value_percent")[:-1]),
                "port": port[0].get("type") if port else "Invalid"
            })
        return buff

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    subparser = parser.add_subparsers(dest="command")
    subparser.required = False

    parser.add_argument("-l", "--listen", help="Listen for changes", action="store_true")
    parser.add_argument("-pp", "--pprint", help="Pretty print output", action="store_true")

    audio = subparser.add_parser("audio")
    audio.add_argument("-d", "--default", help="Show default sink and source", action="store_true")
    audio.add_argument("-b", "--brief", help="Show brief output", action="store_true")

    player = subparser.add_parser("player")
    player.add_argument("-p", "--player", help="Show a particular player")

    network = subparser.add_parser("network")
    network.add_argument("-t", "--types", help="Select device type", nargs="+", default=[])

    schedule = subparser.add_parser("schedule")
    workspaces = subparser.add_parser("workspaces")
    power = subparser.add_parser("power")
    wifi = subparser.add_parser("wifi")

    args = parser.parse_args()
    match args.command:
        case "audio":
            Audio().execute()
        case "network":
            Network().execute()
        case "workspaces":
            Workspaces().execute()
        case "power":
            Power().execute()
        case "wifi":
            Wifi().execute()

