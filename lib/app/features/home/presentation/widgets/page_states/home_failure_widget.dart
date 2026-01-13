import 'package:flutter/widgets.dart';

import '../../../../../shared/errors/app_exception.dart';
import '../../../../../shared/widgets/error_message_widget.dart';

class HomeFailureWidget extends StatelessWidget {
  const HomeFailureWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final AppException error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ErrorMessageWidget(
                error: error,
                compact: true,
                onRetry: onRetry,
              ),
            ],
          ),
          const SizedBox(height: 300),
        ],
      ),
    );
  }
}
