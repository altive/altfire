# Development

## Add new example package

```shell
flutter create -e \
--org jp.co.altive \
--project-name ${PACKAGE_NAME}_example \
packages/${PACKAGE_NAME}/example
```

### Add dependencies to package

```shell
flutter pub add firebase_core \
firebase_analytics \
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
``````