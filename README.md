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

# Step Entrypoint

When using this container image (v2.2.0 and above) in a step (with `docker://`),
you can pass a script directly, similar to `run` by specifying
`entrypoint: /entrypoint.sh`. For example:

```yaml
- name: Build AppImages
  uses: docker://ghcr.io/lite-xl/lite-xl-build-box:v2.2.0
  with:
    entrypoint: /entrypoint.sh
    args: |
      bash scripts/appimage.sh --debug --static --version ${INSTALL_REF} --release
      bash scripts/appimage.sh --debug --nobuild --addons --version ${INSTALL_REF}
```

If you don't use the entrypoint, GitHub Actions will concatenate all the lines
into a single line.
