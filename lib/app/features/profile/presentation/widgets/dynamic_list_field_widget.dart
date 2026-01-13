import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../shared/widgets/app_icon_widget.dart';
import '../../../../shared/widgets/buttons/app_outlined_button_widget.dart';
import '../../../../shared/widgets/inputs/app_reactive_text_field_widget.dart';

class DynamicListFieldWidget extends StatefulWidget {
  const DynamicListFieldWidget({
    super.key,
    this.label,
    this.hintText,
    required this.formArray,
  });

  final String? label;
  final String? hintText;
  final FormArray<String> formArray;

  @override
  State<DynamicListFieldWidget> createState() => _DynamicListFieldWidgetState();
}

class _DynamicListFieldWidgetState extends State<DynamicListFieldWidget> {
  late FormArray<String> items;

  @override
  void initState() {
    items = widget.formArray;

    widget.formArray.valueChanges.listen((value) {
      if (value == null || value.isEmpty) {
        setState(() {});
      }
    });

    super.initState();
  }

  void _addItem() {
    FocusScope.of(context).unfocus();
    setState(() => items.add(FormControl<String>(value: '')));
  }

  void _removeItem(int index) {
    FocusScope.of(context).unfocus();
    setState(() => items.removeAt(index));
  }

  void _reorderItem(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
    });
  }

  Widget _buildProxyDecorator(
    Widget child,
    int index,
    Animation<double> animation,
  ) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, value) {
        final t = Curves.easeOut.transform(animation.value);
        final scale = 1.0 - (t * 0.05);
        return Transform.scale(
          scale: scale,
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: value,
          ),
        );
      },
    );
  }

  Widget _buildItem(int index, AbstractControl<Object?> item) {
    return Padding(
      key: ValueKey(item),
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        padding: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.gray300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const AppIconWidget.svgAsset('menu', size: 16),
            Container(
              alignment: Alignment.center,
              width: 40,
              child: Text(
                '${index + 1}. ',
                style: context.bodyMedium,
              ),
            ),
            Expanded(
              child: AppReactiveTextFieldWidget(
                formControl: item as FormControl<String>,
                hintText: 'profile.report_bug.steps.hint'.tr(
                  namedArgs: {'number': '${index + 1}'},
                ),
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => _removeItem(index),
              icon: const AppIconWidget.svgAsset(
                'trash',
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Theme(
        data: baseTheme.copyWith(
          inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            constraints: const BoxConstraints.tightFor(height: 40),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(widget.label ?? '', style: context.bodyMedium),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppOutlinedButtonWidget(
                    onPressed: _addItem,
                    label: 'profile.report_bug.steps.add'.tr(),
                    prefixIcon: 'plus',
                  ),
                  const SizedBox(height: 8),
                  if (items.controls.isEmpty && widget.hintText != null)
                    Text(
                      widget.hintText!,
                      style: context.bodyMedium.copyWith(
                        color: AppColors.gray100,
                      ),
                    ),
                  ReorderableListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    onReorder: _reorderItem,
                    proxyDecorator: _buildProxyDecorator,
                    children: items.controls.mapIndexed(_buildItem).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
