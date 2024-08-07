>
> **Note: The Workload Services Framework is a benchmarking framework and is not intended to be used for the deployment of workloads in production environments. It is recommended that users consider any adjustments which may be necessary for the deployment of these workloads in a production environment including those necessary for implementing software best practices for workload scalability and security.**
>
# Postgresql

Postgresql is world most popular database. This image is based on [official DockerHub image](https://hub.docker.com/_/postgres) (ver [14.11]). This readme focuses on Intel added scripts and configurations.
Please refer to original readme regarding usage of this image.

## Usage
This image can be used almost exactly like the official DockerHub Postgresql image, with following differences:

1. Run with `--privileged` flag. \
   Some of optimizations are implemented as low-level kernel configuration, \
   To use it the Container have to be executed with escalated privileges
2. Postgresql configurations are passed using `/usr/share/postgresql/postgresql.conf.sample` file. When adding extra configuration remember to include those already present in `postgresql.conf` file.

### Example usage of this image:

``` sh
# build image
docker build . -t postgresql-base:your-tag --build-arg http_proxy --build-arg https_proxy --build-arg no_proxy --network=host
# run container using built image
docker run --name some-postgresql -e POSTGRES_PASSWORD=my-secret-pw --privileged -d postgresql-base:your-tag
```
