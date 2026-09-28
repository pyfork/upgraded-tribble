<!-- ux-designer-Opus5.5-agent, 2026-09-28 -->
# Feature: greet

## Brief

A tiny command-line greeter. Someone runs `bash scripts/greet.sh` from the
repo root, optionally with a name, and gets a one-line greeting.

No screens, no network, no stored data. Pure bash, nothing to install.

## Rules

AC-1  When run with a name argument (for example `Ada`), the command prints
      exactly `Hello, Ada!` on one line and exits with code 0.

AC-2  When run with no argument, the command prints exactly `Hello, world!`
      on one line and exits with code 0.

AC-3  When run with an empty-string argument (`""`), the command prints
      exactly `Hello, world!` on one line and exits with code 0.

## States

- Initial / Success: covered by AC-1 to AC-3.
- Loading, Error, Retry, Disabled, Partial: cannot happen (no input other
  than the one optional argument, nothing that can fail).
- Screen sizes, touch, keyboard, screen reader: not applicable (no screen).
