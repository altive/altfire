# AltFire Lints

Provides lint rules for altfire packages.

## Getting started

### pubspec.yaml

```yaml
dev_dependencies:
  altfire_lints: any
  custom_lint: any
```

### analysis_options.yaml

```yaml
include: package:altive_lints/altive_lints.yaml # Your favorite lint package
analyzer:
  plugins:
    - custom_lint # add this one
```

## Rules

- DisposeConfig
