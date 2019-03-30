#!/usr/bin/env python3

from json import loads
from sys import argv, stdin


def main():
    data = stdin.read()
    print(loads(data))
    print(argv)


if __name__ == "__main__":
    main()
