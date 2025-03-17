# Lite XL Build Box

> [!IMPORTANT]
> As of v4.0.0, the Ubuntu variant **is no longer available**.

This is a Docker image of the setup used to build Lite XL.
It is based on manylinux_2014 with some workarounds to ensure libdecor support.

# Installed packages

- Python 3.11 (provided by manylinux)
- `wget`
- `curl`
- `zip`
- `unzip`
- `ccache`
- `sudo`
- `pip` (provided by `cp311-cp311`)
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
- `libdecor-devel` (package yanked from Raven Extras)
- `appimagetool` (in `/opt/appimagetool/bin`)
- `bsdtar` (in `/opt/appimagetool/bin`)
- `mksquashfs` (in `/opt/appimagetool/bin`)
- `unsquashfs` (in `/opt/appimagetool/bin`)
- `desktop-file-install` (in `/opt/appimagetool/bin`)
- `desktop-file-validate` (in `/opt/appimagetool/bin`)
- `update-desktop-database` (in `/opt/appimagetool/bin`)
- `appstreamcli` (in `/opt/appimagetool/bin`)
- `zsyncmake` (in `/opt/appimagetool/bin`)
- `lpm` (in `/opt/lpm/bin`)

# GitHub Actions

The recommended way of using this build box is via the `lite-xl-build-box` Action.
This action sets up the container environment correctly and runs a script in the container.

```yaml
- name: Build AppImages
  uses: lite-xl/lite-xl-build-box@v4
  with:
    run: |
      bash scripts/appimage.sh --debug --static --version ${INSTALL_REF} --release
      bash scripts/appimage.sh --debug --nobuild --addons --version ${INSTALL_REF}

- name: Build AppImages (aarch64)
  uses: lite-xl/lite-xl-build-box@v4
  with:
    platform: linux/arm64
    run: |
      bash scripts/appimage.sh --debug --static --version ${INSTALL_REF} --release
      bash scripts/appimage.sh --debug --nobuild --addons --version ${INSTALL_REF}
```

# Step Entrypoint

When using this container image in a step (with `docker://`),
you can pass a script directly, similar to `run` by specifying
`entrypoint: /entrypoint.sh`. For example:

```yaml
- name: Build AppImages
  uses: docker://ghcr.io/lite-xl/lite-xl-build-box-manylinux:latest
  with:
    entrypoint: /entrypoint.sh
    args: |
      bash scripts/appimage.sh --debug --static --version ${INSTALL_REF} --release
      bash scripts/appimage.sh --debug --nobuild --addons --version ${INSTALL_REF}
```

If you don't use the entrypoint, GitHub Actions will concatenate all the lines
into a single line.

