# n.b. This image will not build on a rootless container as the Perl test suite is not capability aware
FROM amazonlinux:2023

ARG perlbrew_root=/opt/perlbrew

ARG perl_version=5.18.2
ARG perl_build_args=-Dusethreads

ARG gopan_version=0.12
ARG gopan_tag_version=v${gopan_version}

# Update system packages and install build tooling
RUN dnf update && \
    dnf upgrade -y && \
    dnf groupinstall -y "Development Tools" && \
    dnf install -y awscli-2 git gzip openssl openssl-devel tar

# Install vendor packages for build-time Perl compilation tests
RUN yum install -y procps-ng

# Install vendor packages to support Perlbrew installation
RUN yum install -y perl-ExtUtils-MakeMaker perl-deprecate

# Install GoPAN for dependency resolution
ADD https://github.com/companieshouse/gopan/releases/download/${gopan_tag_version}/gopan-${gopan_version}-linux_amd64.tar.gz /gopan-${gopan_version}-linux_amd64.tar.gz
RUN tar -C /usr/local/bin -xzf /gopan-${gopan_version}-linux_amd64.tar.gz && \
    rm -f /gopan-${gopan_version}-linux_amd64.tar.gz

# Install Perlbrew to support Perl source build
ENV PERLBREW_ROOT=${perlbrew_root}
RUN curl -L https://install.perlbrew.pl | bash

# Add Perlbrew to PATH environment variable
ENV PATH ${perlbrew_root}/bin:$PATH

# Patch and build Perl from source tree using additional build arguments and install App::cpanminus
# and Test::Harness (the latter provides a TAP harness for running tests with the 'prove' command)
RUN source /opt/perlbrew/etc/bashrc && \
    perlbrew install -v perl-${perl_version} ${perl_build_args} && \
    perlbrew install-cpanm -v && \
    perlbrew use perl-${perl_version} && \
    cpanm Test::Harness

# Set local time zone
RUN unlink /etc/localtime && ln -s /usr/share/zoneinfo/Europe/London /etc/localtime
