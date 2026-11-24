#!/usr/bin/env python3
"""Watch ./mem.dump. Type /<hex address> and press Enter to toggle yellow text.

Stop with Ctrl+C.
"""

from pathlib import Path
from itertools import zip_longest
import os
import re
import select
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


def highlight_line(line, highlighted):
    return re.sub(
        r"(^|  )([0-9A-F]{3}: )([0-9A-F]{1,4})(?=  |$)",
        lambda entry: (
            entry[1] + entry[2] + f"\033[33m{entry[3]}\033[39m"
            if int(entry[2][:3], 16) in highlighted else entry[0]
        ),
        line,
    )


def screen_updates(previous, current):
    # Redraw changed rows so cursor positions never count color escapes as text.
    return "".join(
        f"\033[{row};1H\033[K{new}"
        for row, (old, new) in enumerate(zip_longest(previous, current, fillvalue=""), 1)
        if old != new
    )


def main():
    path = Path("mem.dump")
    previous = []
    previous_size = None
    last_data = ""
    empty_since = None
    error_since = None
    terminal = sys.stdout.isatty()
    input_fd = None
    original_termios = None
    highlighted = set()
    try:
        if terminal and sys.stdin.isatty() and os.name == "posix":
            import termios

            input_fd = sys.stdin.fileno()
            original_termios = termios.tcgetattr(input_fd)
            settings = original_termios.copy()
            settings[3] = (settings[3] | termios.ICANON) & ~(termios.ECHO | termios.ECHONL)
            termios.tcsetattr(input_fd, termios.TCSANOW, settings)
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
                if highlighted:
                    lines = [highlight_line(line, highlighted) for line in lines]
                if size != previous_size:
                    update = "\033[H\033[J" + screen_updates([], lines)
                else:
                    update = screen_updates(previous, lines)
            else:
                update = output + "\n" if lines != previous else ""
            if update:
                print(update, end="", flush=True)
            previous, previous_size = lines, size
            if input_fd is None:
                time.sleep(0.1)
            elif select.select([input_fd], [], [], 0.1)[0]:
                command = os.read(input_fd, 4096)
                match = re.fullmatch(rb"/(?:0[xX])?([0-9a-fA-F]{1,3})\n", command)
                if match:
                    highlighted.symmetric_difference_update({int(match[1], 16)})
                elif not command:
                    input_fd = None
    finally:
        if original_termios is not None:
            termios.tcsetattr(sys.stdin.fileno(), termios.TCSANOW, original_termios)
        if terminal:
            print("\033[?25h\033[?1049l", end="", flush=True)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
