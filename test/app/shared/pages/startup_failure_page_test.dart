import 'package:flutly_store/app/shared/pages/startup_failure_page.dart';
import 'package:flutly_store/app/shared/widgets/error_message_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders startup error message', (tester) async {
    const error = 'boom';
    final stack = StackTrace.current;

    await tester.pumpWidget(
      StartupFailurePage(
        error: error,
        stacktrace: stack,
      ),
    );

    expect(find.byType(ErrorMessageWidget), findsOneWidget);
    expect(
      find.text(
        'The app failed to start properly.\nPlease try restarting it.',
      ),
      findsOneWidget,
    );
  });
}
