# Development

## Release procedures for an altfire package

Releases are now automated using GitHub Actions. To create a release, follow these steps:

1. Trigger the **Create Release Pull Request** workflow manually from GitHub Actions.
   - If needed, select the package to release.
   - If no package is selected, all modified packages will be included.
2. Review the automatically generated release pull request and merge it after approval.
3. Once the pull request is merged into `main`, the **Publish to pub.dev** workflow will be triggered automatically to publish the updated packages.

### Manual release (if needed)

<details>
<summary>Click to expand manual release steps</summary>

1. Create a branch for the release.
2. Run the `melos version` command.
3. Run `git push origin release --follow-tags` to push the changes and tags.
4. Create a pull request for the pushed branch.
5. Merge the pull request after review.
6. Run the `melos publish` command on the `main` branch.

```shell
# Narrow down the target package as needed.
melos version --scope=altfire_tracker

# Specify the version manually, if necessary.
melos version \
--manual-version altfire_authenticator:0.1.6 \
--manual-version altfire_configurator:0.1.4 \
--manual-version altfire_messenger:0.2.1 \
--manual-version altfire_tracker:0.1.5 \
```
</details>

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