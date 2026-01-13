import 'package:flutter/material.dart';

import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../shared/widgets/buttons/app_outlined_button_widget.dart';

class CartItemQuantityWidget extends StatelessWidget {
  const CartItemQuantityWidget({
    super.key,
    required this.onIncrement,
    required this.onDecrement,
    required this.quantity,
    this.isLoading = false,
  });

  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final int quantity;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: AppOutlinedButtonWidget(
            prefixIcon: 'minus',
            onPressed: onDecrement,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        Container(
          width: 50,
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isLoading
                ? const SizedBox(
                    width: 11,
                    height: 11,
                    child: CircularProgressIndicator(
                      color: AppColors.black,
                      strokeWidth: 1.5,
                    ),
                  )
                : Text('$quantity', style: context.bodyLarge),
          ),
        ),
        SizedBox(
          width: 30,
          height: 30,
          child: AppOutlinedButtonWidget(
            prefixIcon: 'plus',
            onPressed: onIncrement,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
