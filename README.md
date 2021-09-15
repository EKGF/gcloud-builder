# ekgf/gcloud-builder

Google Cloud Build builder image with some additional tools:

- curl
- jq (for processing JSON files)
- yq (for processing YAML files)
- unzip zip
- gnupg
- rsync
- helm
- bats
- pkgdiff

## Building this builder

CI is in [Docker Hub](https://hub.docker.com/repository/docker/ekgf/gcloud-builder/builds).

To build it locally:

```
./localbuild.sh
```
