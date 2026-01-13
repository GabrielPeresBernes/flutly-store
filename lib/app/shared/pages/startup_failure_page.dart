import 'package:flutter/material.dart';

import '../errors/app_exception.dart';
import '../theme/theme_data.dart';
import '../widgets/error_message_widget.dart';

class StartupFailurePage extends StatelessWidget {
  const StartupFailurePage({
    super.key,
    required this.error,
    required this.stacktrace,
  });

  final Object? error;
  final StackTrace? stacktrace;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 24, right: 24),
            child: ErrorMessageWidget(
              error: AppException(
                message:
                    'The app failed to start properly.\nPlease try restarting it.',
                details: error,
                stackTrace: stacktrace,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
