import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/lints/dispose_config.dart';

/// Plugin for the AltFire lints.
PluginBase createPlugin() => _AltFirePlugin();

class _AltFirePlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const DisposeConfig(),
      ];
}
