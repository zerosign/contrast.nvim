EXAMPLES_DIR := justfile_directory() / "examples"
SANDBOX_DIR  := justfile_directory() / "sandbox"
STATE_DIR    := SANDBOX_DIR / "state"
DATA_DIR     := SANDBOX_DIR / "data"
CACHE_DIR    := SANDBOX_DIR / "cache"

export NVIM_APPNAME    := "nvim"
export XDG_CONFIG_HOME := justfile_directory() / "sandbox"
export XDG_STATE_HOME  := justfile_directory() / "sandbox" / "state"
export XDG_DATA_HOME   := justfile_directory() / "sandbox" / "data"
export XDG_CACHE_HOME  := justfile_directory() / "sandbox" / "cache"

# Run sandboxed nvim with no arguments
default: _dirs
    @nvim

# Open an example file: just open rust
open example: _dirs
    @nvim {{ EXAMPLES_DIR }}/{{ example }}

# List available examples
examples:
    @ls {{ EXAMPLES_DIR }}/

# Shortcut recipes for each example
rust: _dirs
    @nvim {{ EXAMPLES_DIR }}/cache.rs

go: _dirs
    @nvim {{ EXAMPLES_DIR }}/cache.go

typescript: _dirs
    @nvim {{ EXAMPLES_DIR }}/service.ts

java: _dirs
    @nvim {{ EXAMPLES_DIR }}/service.java

scala: _dirs
    @nvim {{ EXAMPLES_DIR }}/service.scala

zig: _dirs
    @nvim {{ EXAMPLES_DIR }}/cache.zig

c: _dirs
    @nvim {{ EXAMPLES_DIR }}/cache.c

cpp: _dirs
    @nvim {{ EXAMPLES_DIR }}/cache.cpp

prolog: _dirs
    @nvim {{ EXAMPLES_DIR }}/rules.pl

yaml: _dirs
    @nvim {{ EXAMPLES_DIR }}/config.yaml

json: _dirs
    @nvim {{ EXAMPLES_DIR }}/config.json

toml: _dirs
    @nvim {{ EXAMPLES_DIR }}/config.toml

lua: _dirs
    @nvim {{ EXAMPLES_DIR }}/config.lua

# Create sandbox dirs
_dirs:
    @mkdir -p {{ STATE_DIR }}/nvim {{ DATA_DIR }}/nvim {{ CACHE_DIR }}/nvim

# Wipe all sandbox state
clean:
    @rm -rf {{ STATE_DIR }} {{ DATA_DIR }} {{ CACHE_DIR }}
    @echo "Sandbox cleaned."

# Show paths
info:
    @echo "Examples:  {{ EXAMPLES_DIR }}"
    @echo "Config:    {{ SANDBOX_DIR }}/nvim"
    @echo "State:     {{ STATE_DIR }}"
    @echo "Data:      {{ DATA_DIR }}"
    @echo "Cache:     {{ CACHE_DIR }}"

help:
    @just --list
