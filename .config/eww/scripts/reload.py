#!/usr/bin/python3

import subprocess, sys, os
import dotenv
import requests
import pywal

from PIL import Image
from string import Template
from pathlib import Path

dotenv.load_dotenv()

CONFIG = {
    "config_path": Path("~/.config").expanduser(),
    "wallpaper_folder": Path("~/Pictures/wallpapers").expanduser(),
}

def flatten_dict(dictionary: dict, parent_key: str = '', separator: str = '_'):
    items = []
    for key, value in dictionary.items():
        new_key = parent_key + separator + key if parent_key else key
        if isinstance(value, dict):
            items.extend(flatten_dict(value, new_key, separator=separator).items())
        else:
            items.append((new_key, value))
    return dict(items)

if __name__ == "__main__":
    # selects random image from wallpaper folder
    wallpaper = pywal.image.get(CONFIG["wallpaper_folder"])

    subprocess.Popen(["swww", "img", wallpaper, "--transition-type=right"])

    # use pywal to get colors
    colors = pywal.colors.get(wallpaper)
    pywal.export.every(colors)

    colors = flatten_dict(colors)
    subprocess.Popen(['eww', 'r'])

