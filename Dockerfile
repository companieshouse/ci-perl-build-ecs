FROM amazonlinux:2023

ARG gopan_version=0.12
ARG gopan_tag_version=v${gopan_version}

# Update system packages and install build tooling
RUN dnf update && \
    dnf upgrade -y && \
    dnf install -y \
        cmake \
        gcc-c++ \
        gzip \
        openssl \
        openssl-devel \
        perl-deprecate \
        perl-Dumpvalue \
        perl-ExtUtils-MakeMaker \
        perl-English \
        perl-Env \
        perl-FindBin \
        perl-Hash-Util-FieldHash \
        perl-Module-Loaded \
        perl-Module-CoreList \
        perl-Safe \
        perl-Sys-Hostname \
        perl-threads \
        perl-Unicode-Normalize \
        tar \
        zlib-devel && \
    dnf clean all && \
    rm -rf /var/cache/dnf /tmp/*

# Install App::cpanminus
RUN curl -L https://cpanmin.us | perl - App::cpanminus

# Set local time zone
RUN unlink /etc/localtime && ln -s /usr/share/zoneinfo/Europe/London /etc/localtime
