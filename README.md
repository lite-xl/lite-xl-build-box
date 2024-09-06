# Lite XL Build Box

> **Note**
> The Ubuntu variant of the build box is considered obsolete and will be removed in the future.
> Please migrate to the CentOS variant.

This is a Docker image of the setup used to build Lite XL.
It is based on manylinux_2014 with some workarounds to ensure libdecor support.

## Notes

Before installing anything,
you will need to uninstall `libdecor-devel` to prevent
any broken dependencies error during installation.

# Installed packages

- `wget`
- `curl`
- `zip`
- `unzip`
- `ccache`
- `sudo`
- `rh-python38` (configured as `python3`)
- `pip` (provided by `rh-python38`)
- `git`
- `cmake`
- `meson`
- `ninja`
- `fuse`
- `fuse3`
- `libX11-devel`
- `libXi-devel`
- `libXcursor-devel`
- `libxkbcommon-devel`
- `libXrandr-devel`
- `wayland-devel`
- `wayland-protocols-devel`
- `dbus-devel`
- `ibus-devel`
- `SDL2-devel`
- `clang`
- `gcc-aarch64-linux-gnu`
- `gcc-c++-aarch64-linux-gnu`
- `binutils-aarch64-linux-gnu`
- `libdecor-devel` (package yanked from RHEL8)

# Step Entrypoint

When using this container image in a step (with `docker://`),
you can pass a script directly, similar to `run` by specifying
`entrypoint: /entrypoint.sh`. For example:

```yaml
- name: Build AppImages
  uses: docker://ghcr.io/lite-xl/lite-xl-build-box-manylinux:v2.2.0
  with:
    entrypoint: /entrypoint.sh
    args: |
      bash scripts/appimage.sh --debug --static --version ${INSTALL_REF} --release
      bash scripts/appimage.sh --debug --nobuild --addons --version ${INSTALL_REF}
```

If you don't use the entrypoint, GitHub Actions will concatenate all the lines
into a single line.

<details>
<summary>Instructions for Ubuntu</summary>

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
- `clang`
- `gcc-aarch64-linux-gnu`
- `binutils-aarch64-linux-gnu`
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

</details>

