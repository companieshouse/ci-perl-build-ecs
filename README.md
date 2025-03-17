# ci-perl-build-ecs

A Docker configuration for Perl-based CHS services deployed to ECS.

## Build Tools

The following list details the build tools required by all CHS Perl-based services which will be installed in the container image:

- Perl 5.18.2 (compiled from source with the `-Dusethreads` flag)
- GNU libc 2.34
- Perlbrew 1.0.1
- GoPAN 0.12 (for dependency resolution when building `*-deps` projects)

> [!NOTE]
> Versions are correct at time of writing but may be subject to change as future versions of the container image are built.

## Dependencies

The following list details the distribution-managed packages installed in the container image and the reason for their inclusion:

| Name                  | Purpose                                                                                                |
|-----------------------|--------------------------------------------------------------------------------------------------------|
| `awscli-2`            | Used to retrieve non distribution-managed dependency packages from the S3 release bucket               |
| `git`, `tar`, `unzip` | Required for working with `git` submodules as well as `.zip` and `.tar.gz` files during service builds |
| `@Development tools`, `procps-ng` | Required when building Perl from source and during service builds for compiled modules     |
| `openssl`, `openssl-devel` | SSL libraries used by multiple tools and Perl modules                                             |
| `perl-ExtUtils-MakeMaker` `perl-deprecate` | Required dependencies of [Perlbrew](https://perlbrew.pl/)                         |

In addition to the distribution-managed packages detailed above, the following tools are also installed:

| Name                                             | Purpose                                                                            |
|--------------------------------------------------|------------------------------------------------------------------------------------|
| [GoPAN](https://github.com/companieshouse/gopan) | Used to retrieve private and external dependencies when building `*-deps` projects |
