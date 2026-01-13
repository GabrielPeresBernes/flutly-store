import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router/router.dart';
import '../../../../../shared/extensions/text_theme_extension.dart';
import '../../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../../shared/widgets/app_icon_widget.dart';
import '../../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../domain/entities/order.dart';
import '../../../infra/routes/checkout_route.dart';
import '../../../infra/routes/checkout_route_params.dart';
import '../../bloc/checkout/checkout_cubit.dart';

const _animationDuration = Duration(seconds: 12);
const _completionDuration = Duration(seconds: 1);

class CheckoutPlacingOrderBodyWidget extends StatefulWidget {
  const CheckoutPlacingOrderBodyWidget({super.key});

  @override
  State<CheckoutPlacingOrderBodyWidget> createState() =>
      _CheckoutPlacingOrderBodyWidgetState();
}

class _CheckoutPlacingOrderBodyWidgetState
    extends State<CheckoutPlacingOrderBodyWidget>
    with SingleTickerProviderStateMixin {
  var _progress = 0.0;

  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _animationController
      ..addListener(() {
        setState(() => _progress = _progressAnimation.value);
      })
      ..forward();

    super.initState();
  }

  void _completeProgress(Order order) {
    _animationController.duration = _completionDuration;

    _progressAnimation = Tween<double>(begin: _progress, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Delay navigation to allow users to see the completed progress
          Future<void>.delayed(const Duration(milliseconds: 1500), () {
            Navigator.of(context).pop();
            context.read<CartCubit>().clearCart();
            context.router.push(
              const CheckoutRoute(),
              params: CheckoutRouteParams(order: order),
            );
          });
        }
      })
      ..forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutState>(
      listenWhen: (previous, current) => current is CheckoutPlacingOrderUpdate,
      listener: (context, state) {
        if ((state as CheckoutPlacingOrderUpdate).status ==
            OrderStatus.completed) {
          _completeProgress(state.order!);
        }
      },
      child: BlocBuilder<CheckoutCubit, CheckoutState>(
        buildWhen: (previous, current) => current is CheckoutPlacingOrderUpdate,
        builder: (context, state) {
          final status = (state as CheckoutPlacingOrderUpdate).status;

          final completed = status == OrderStatus.completed;
          final finished = _progress >= 1.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: Align(
                  key: ValueKey<String>(finished ? 'completed' : 'processing'),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    finished
                        ? 'checkout.placing_order.completed_message'.tr()
                        : 'checkout.placing_order.processing_message'.tr(),
                    style: context.bodyMedium.copyWith(
                      color: AppColors.gray100,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: finished
                          ? AppColors.secondary
                          : AppColors.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      crossFadeState: finished
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          minHeight: 50,
                          value: _progress,
                          borderRadius: BorderRadius.circular(10),
                          backgroundColor: AppColors.primary,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.black.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                      secondChild: const SizedBox.shrink(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                            child: Align(
                              key: ValueKey<OrderStatus>(status),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                status.label,
                                style: context.labelMedium.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        AnimatedCrossFade(
                          firstChild: const Padding(
                            padding: EdgeInsets.only(
                              right: 5,
                              top: 1,
                              bottom: 1,
                              left: 1,
                            ),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          secondChild: const AppIconWidget.svgAsset(
                            'check',
                            size: 25,
                            color: AppColors.white,
                          ),
                          crossFadeState: completed
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
