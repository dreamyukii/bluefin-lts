ARG MAJOR_VERSION="${MAJOR_VERSION:-stream10}"
FROM ghcr.io/astral-sh/uv:latest@sha256:01ddc2a91588f1210396433c79c9f58848ad668ea05bda895f5a1a31f2e5b64f AS uv-bin
FROM ghcr.io/ublue-os/config:latest@sha256:e45ff5faf342ea871a88b3e1c86b7cd517545d53fdd88e23ca5a3d56e79b9440 AS config
FROM quay.io/centos-bootc/centos-bootc:$MAJOR_VERSION

# ARM should be handled by $(arch)
ARG ENABLE_DX="${ENABLE_DX:-0}"
ARG ENABLE_HWE="${ENABLE_HWE:-0}"
ARG ENABLE_GDX="${ENABLE_GDX:-0}"
ARG IMAGE_NAME="${IMAGE_NAME:-bluefin}"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-ublue-os}"
ARG MAJOR_VERSION="${MAJOR_VERSION:-lts}"
ARG SHA_HEAD_SHORT="${SHA_HEAD_SHORT:-}"

COPY system_files /
COPY system_files_overrides /var/tmp/system_files_overrides
COPY build_scripts /var/tmp/build_scripts
# FIXME: install UV from EPEL whenever it gets released there, its currently on epel-testing but its broken (07-02-2025)
COPY --from=uv-bin /uv* /var/tmp/system_files_overrides/x86-64-gdx/usr/bin

RUN --mount=type=tmpfs,dst=/tmp --mount=type=bind,from=config,src=/rpms,dst=/tmp/rpms /var/tmp/build_scripts/build.sh
