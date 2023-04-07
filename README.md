# Lite XL Build Box

This is a Docker image of the setup used to build Lite XL.
It is based on Ubuntu 18.04 with some workarounds to ensure libdecor support.

## Notes

Before installing anything,
you will need to uninstall `libdecor-0-dev` and `libdecor-0` to prevent
any broken dependencies error during installation.

# Installed packages

- `ccache`
- `sudo`
- `build-essential`
- `python3`
- `python3-pip`
- `git`
- `cmake`
- `meson`
- `ninja`
- `libfuse2` 
- `wayland-protocols`
- `libsdl2-dev`
- `libdecor-0` (package yanked from Ubuntu 20.04)
- `libdecor-0-dev` (package yanked from Ubuntu 20.04)

