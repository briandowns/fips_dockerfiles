# FIPS 140-2 Dockerfiles

This repository contains Dockerfiles for building Kubernetes as well as other services in that ecosystem and used by Rancher Labs. These builds are generally the same as they are regularly however they're done in asuch a way to replace the typical Go crypto libraries with FIPS 140-2 approved libraries, being BoringCrypto.

A build script is provided to ease the process of building these services.

Examples

```sh
build.sh all
```

```sh
build.sh kubernetes
```

