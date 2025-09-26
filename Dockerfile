FROM chimeralinux/chimera


RUN apk update
RUN apk upgrade

RUN apk add --no-cache \
    linux-headers musl-devel musl-devel-static \
    git curl cmake gmake zlib-ng-compat-devel zlib-ng-compat-devel-static \
    openssl3-devel openssl3-devel-static clang clang-devel clang-devel-static \
    libunwind-devel libunwind-devel-static \
    libcxx-devel-static libcxx-devel libcxxabi-devel-static libcxxabi-devel \
    libatomic-chimera-devel libatomic-chimera-devel-static \
    libarchive-progs libgcc-chimera \
    cargo rust rust-src rust-std python-devel \
    binutils-x86_64 pkgconf bash


RUN ln -s /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so
RUN ln -s /usr/sbin/cc /usr/sbin/musl-gcc

ENV RUSTFLAGS="-C target-feature=+crt-static -C linker=clang -C strip=symbols -C opt-level=s" 
ENV ZT_CARGO_FLAGS="-C target-feature=+crt-static -C linker=clang -C strip=symbols -C opt-level=s"
ENV CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER=clang
ENV CARGO_TARGET_AARCH64_UNKNOWN_LINUX_MUSL_LINKER=clang
ENV ZT_STATIC=1 
ENV ZT_NONFREE=1
ENV XZ_OPT=-e9

COPY build-static-zerotier.sh build-static-zerotier.sh
RUN chmod +x ./build-static-zerotier.sh
RUN bash ./build-static-zerotier.sh
