import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// LintRule to ensure that Config instances are disposed.
class DisposeConfig extends DartLintRule {
  /// Default constructor.
  const DisposeConfig() : super(code: _code);

  static const _code = LintCode(
    name: 'dispose_config',
    problemMessage: "Undisposed instance of 'Config'.\n"
        "Try invoking 'dispose' in the function in which the "
        "'Config' was created.",
  );

  /// Returns true if the given [type] is a Config of altfire_configurator.
  bool _isConfig(DartType type) => const TypeChecker.fromName(
        'Config',
        packageName: 'altfire_configurator',
      ).isExactlyType(type);

  /// Returns all method invocations in the given [node].
  Iterable<MethodInvocation> _traverseMethodInvocations(AstNode node) {
    final methodInvocations = <MethodInvocation>[];
    void visitNode(AstNode node) {
      if (node is MethodInvocation) {
        methodInvocations.add(node);
      }
      if (node is FunctionExpressionInvocation) {
        final function = node.function;
        if (function is MethodInvocation) {
          methodInvocations.add(function);
        }
      }
      node.childEntities.whereType<AstNode>().forEach(visitNode);
    }

    visitNode(node);
    return methodInvocations;
  }

  /// Returns all prefixed identifiers in the given [node].
  Iterable<PrefixedIdentifier> _traversePrefixedIdentifiers(AstNode node) {
    final prefixedIdentifiers = <PrefixedIdentifier>[];
    void visitNode(AstNode node) {
      if (node is PrefixedIdentifier) {
        prefixedIdentifiers.add(node);
      }
      node.childEntities.whereType<AstNode>().forEach(visitNode);
    }

    visitNode(node);
    return prefixedIdentifiers;
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addFieldDeclaration((node) {
      final targetType = node.fields.type?.type;
      if (targetType == null) {
        return;
      }
      if (!_isConfig(targetType)) {
        return;
      }

      final compilationUnit = node.thisOrAncestorOfType<CompilationUnit>();
      if (compilationUnit == null) {
        return;
      }

      final methodInvocations = _traverseMethodInvocations(compilationUnit);
      for (final field in node.fields.variables) {
        var isDisposed = false;
        for (final methodInvocation in methodInvocations) {
          final target = methodInvocation.realTarget;
          if (target is! SimpleIdentifier) {
            continue;
          }
          final methodName = methodInvocation.methodName.name;
          if (target.name == field.name.lexeme && methodName == 'dispose') {
            isDisposed = true;
            break;
          }
        }

        if (!isDisposed) {
          reporter.atNode(field, _code);
        }
      }
    });

    context.registry.addVariableDeclarationStatement((node) {
      final variables = node.variables.variables;
      for (final variable in variables) {
        final variableType = variable.declaredFragment?.element.type;
        if (variableType == null) {
          continue;
        }

        if (!_isConfig(variableType)) {
          continue;
        }

        final function = node.thisOrAncestorOfType<FunctionBody>();
        if (function == null) {
          continue;
        }

        var isDisposed = false;

        final methodInvocations = _traverseMethodInvocations(function);
        for (final methodInvocation in methodInvocations) {
          final target = methodInvocation.realTarget;
          if (target is! SimpleIdentifier) {
            continue;
          }
          final methodName = methodInvocation.methodName.name;
          if (target.name == variable.name.lexeme && methodName == 'dispose') {
            isDisposed = true;
            break;
          }
        }

        final prefixIdentifiers = _traversePrefixedIdentifiers(function);
        for (final prefixedIdentifier in prefixIdentifiers) {
          final prefix = prefixedIdentifier.prefix;
          final identifier = prefixedIdentifier.identifier;
          if (prefix.name == variable.name.lexeme &&
              identifier.name == 'dispose') {
            isDisposed = true;
            break;
          }
        }
        if (!isDisposed) {
          reporter.atNode(node, _code);
        }
      }
    });
  }
}
