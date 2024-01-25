import 'package:altfire_tracker/altfire_tracker.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class MockFirebaseAppWithCollectionEnabled implements TestFirebaseCoreHostApi {
  @override
  Future<PigeonInitializeResponse> initializeApp(
    String appName,
    PigeonFirebaseOptions initializeAppRequest,
  ) async {
    return PigeonInitializeResponse(
      name: appName,
      options: PigeonFirebaseOptions(
        apiKey: '123',
        projectId: '123',
        appId: '123',
        messagingSenderId: '123',
      ),
      pluginConstants: {
        'plugins.flutter.io/firebase_crashlytics': {
          'isCrashlyticsCollectionEnabled': true,
        },
      },
    );
  }

  @override
  Future<List<PigeonInitializeResponse?>> initializeCore() async {
    return [
      PigeonInitializeResponse(
        name: defaultFirebaseAppName,
        options: PigeonFirebaseOptions(
          apiKey: '123',
          projectId: '123',
          appId: '123',
          messagingSenderId: '123',
        ),
        pluginConstants: {
          'plugins.flutter.io/firebase_crashlytics': {
            'isCrashlyticsCollectionEnabled': true,
          },
        },
      ),
    ];
  }

  @override
  Future<PigeonFirebaseOptions> optionsFromResource() async {
    return PigeonFirebaseOptions(
      apiKey: '123',
      projectId: '123',
      appId: '123',
      messagingSenderId: '123',
    );
  }
}

void setupFirebaseCrashlyticsMocks(List<MethodCall> methodCallLog) {
  TestWidgetsFlutterBinding.ensureInitialized();

  TestFirebaseCoreHostApi.setup(MockFirebaseAppWithCollectionEnabled());

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(MethodChannelFirebaseCrashlytics.channel,
          (MethodCall methodCall) async {
    methodCallLog.add(methodCall);
    switch (methodCall.method) {
      case 'Crashlytics#checkForUnsentReports':
        return {
          'unsentReports': true,
        };
      case 'Crashlytics#setCrashlyticsCollectionEnabled':
        final arguments = methodCall.arguments as Map<String, dynamic>;
        return <String, dynamic>{
          'isCrashlyticsCollectionEnabled': arguments['enabled'],
        };
      case 'Crashlytics#didCrashOnPreviousExecution':
        return {
          'didCrashOnPreviousExecution': true,
        };
      case 'Crashlytics#recordError':
        return null;
      default:
        return false;
    }
  });
}
