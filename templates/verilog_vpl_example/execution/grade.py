#!/usr/bin/env python3
# Grading script.
from generate import o1, o2


def expected_lines():
    return [f"{a}{b}" for a, b in zip(o1, o2)]


def read_lines(path):
    try:
        with open(path, "r", encoding="utf-8") as stream:
            return [line.strip() for line in stream if line.strip()]
    except OSError:
        return []


actual = read_lines("evaluate.out")
expected = expected_lines()

score = 0
if len(actual) >= len(expected):
    score = sum(1 for got, want in zip(actual[: len(expected)], expected) if got == want)

print(score * 100 // len(expected))
