import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/lints/dispose_config.dart';

PluginBase createPlugin() => _FlutterFirePlugin();

class _FlutterFirePlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const DisposeConfig(),
      ];
}
