#!/usr/bin/env python3
"""Watch ./mem.dump on the alternate terminal screen; stop with Ctrl+C."""

from pathlib import Path
from itertools import zip_longest
import re
import shutil
import sys
import time


def format_dump(data, width=80):
    words = data.split()
    if len(words) > 0x1000 or any(
        re.fullmatch(r"[0-9a-fA-F]{4}", word) is None for word in words
    ):
        raise ValueError("expected up to 4096 four-digit hex words")
    entries = [f"{address:03X}: {word.upper()}" for address, word in enumerate(words)]
    columns = max(1, (width + 2) // 11)
    return "\n".join("  ".join(entries[i:i + columns]) for i in range(0, len(entries), columns))


def screen_updates(previous, current):
    updates = []
    for row, (old, new) in enumerate(zip_longest(previous, current, fillvalue=""), 1):
        if old == new:
            continue
        width = max(len(old), len(new))
        old, new = old.ljust(width), new.ljust(width)
        start = None
        for column in range(width + 1):
            if column < width and old[column] != new[column]:
                if start is None:
                    start = column
            elif start is not None:
                updates.append(f"\033[{row};{start + 1}H" + new[start:column])
                start = None
    return "".join(updates)


def main():
    path = Path("mem.dump")
    previous = []
    previous_size = None
    last_data = ""
    empty_since = None
    error_since = None
    terminal = sys.stdout.isatty()
    try:
        if terminal:
            print("\033[?1049h\033[?25l", end="", flush=True)
        while True:
            size = shutil.get_terminal_size()
            try:
                data = path.read_text(encoding="ascii")
                if data.strip():
                    output = format_dump(data, size.columns)
                    last_data = data
                    empty_since = None
                else:
                    now = time.monotonic()
                    if empty_since is None:
                        empty_since = now
                    output = (
                        "Memory is empty" if now - empty_since >= 2
                        else format_dump(last_data, size.columns)
                    )
            except (OSError, UnicodeError, ValueError) as error:
                empty_since = None
                now = time.monotonic()
                if error_since is None:
                    error_since = now
                output = (
                    f"mem.dump: {error}" if now - error_since >= 2
                    else format_dump(last_data, size.columns)
                )
            else:
                error_since = None
            lines = output.splitlines()
            if terminal:
                # ponytail: show the first screen only; add paging for later addresses.
                lines = [line[:size.columns] for line in lines[:size.lines]]
                if size != previous_size:
                    update = "\033[H\033[J" + "\r\n".join(lines)
                else:
                    update = screen_updates(previous, lines)
            else:
                update = output + "\n" if lines != previous else ""
            if update:
                print(update, end="", flush=True)
            previous, previous_size = lines, size
            time.sleep(0.1)
    finally:
        if terminal:
            print("\033[?25h\033[?1049l", end="", flush=True)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
