# Development

## Release procedures for a altfire package.

1. Create a branch for release.
1. Run the `melos version` command.
1. Commit the diff and create a pull request.
1. Merge the pull request after review.
1. Run the `melos publish` command on the `main` branch.

```shell
# Narrow down the target package as needed.
melos version --scope=altfire_tracker
```

## Add new example package

```shell
flutter create -e \
--org jp.co.altive \
--project-name ${PACKAGE_NAME}_example \
packages/${PACKAGE_NAME}/example
```

### Add dependencies to example package

```shell
flutter pub add firebase_core \
'${PACKAGE_NAME}:{"path":"../"}' \
dev:altive_lints 
```

### Configure FlutterFire

```shell
cd packages/${PACKAGE_NAME}/example
flutterfire configure
```

https://console.firebase.google.com/project/flutterfire-adapter

### Update analysis_options.yaml

```yaml
include: package:altive_lints/altive_lints.yaml
analyzer:
  exclude:
    - "lib/firebase_options.dart"
```