import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// TODO: obscureText일 때 자체적으로 obscurity를 풀어주는 suffix 아이콘을 가져야합니다
class TextInputField extends StatelessWidget {
  /// OutlineInputBorder shape의 TextFormField입니다
  const TextInputField({
    Key? key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onTap,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    this.title,
    this.labelText,
    this.errorText,
    this.hintText,
    this.backgroundColor,
    this.cursorColor,
    this.initialValue,
    this.maxLength,
    this.maxValue,
    this.maxLines = 1,
    this.hintStyle = const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
    this.textStyle = const TextStyle(fontSize: 14),
    this.floatingLabelStyle = const TextStyle(color: Colors.black),
    this.prefixIcon,
    this.suffixIcon,
    this.innerPrefixIcon,
    this.innerSuffixIcon,
    this.keyboardType,
    this.borderRadiusValue = 8,
    this.filled = true,
    this.enabled = true,
    this.autoFocus = false,
    this.obscureText = false,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.showBorder = true,
    this.enabledBorderSide,
    this.disabledBorderSide,
    this.focusedBorderSide,
    this.focusedErrorBorderSide,
    this.errorBorderSide,
    this.errorMaxLines,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
  }) : super(key: key);

  final FocusNode? focusNode;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final EdgeInsetsGeometry contentPadding;
  final double borderRadiusValue;
  final int? maxLength;
  final double? maxValue;
  final int maxLines;
  final String? title;
  final String? labelText;
  final String? errorText;
  final String? hintText;
  final String? initialValue;
  final TextStyle hintStyle;
  final TextStyle textStyle;
  final TextStyle floatingLabelStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? innerPrefixIcon;
  final Widget? innerSuffixIcon;
  final TextInputType? keyboardType;
  final bool filled;
  final bool enabled;
  final bool autoFocus;
  final bool obscureText;
  final FloatingLabelBehavior floatingLabelBehavior;
  final bool showBorder;
  final BorderSide? enabledBorderSide;
  final BorderSide? disabledBorderSide;
  final BorderSide? focusedBorderSide;
  final BorderSide? focusedErrorBorderSide;
  final BorderSide? errorBorderSide;
  final Color? backgroundColor;
  final Color? cursorColor;
  final int? errorMaxLines;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 4),
            child: Text(
              title!,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF424242),
              ),
            ),
          ),
        Row(
          children: [
            if (prefixIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: prefixIcon,
              ),
            Expanded(
              child: TextFormField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(maxLength),
                  if (maxValue != null) _MaxNumberTextInputFormatter(maxValue!),
                ],
                textAlign: textAlign,
                textAlignVertical: textAlignVertical,
                enabled: enabled,
                autofocus: autoFocus,
                controller: controller,
                initialValue: initialValue,
                cursorColor: cursorColor ?? Colors.grey.shade900,
                onTap: onTap,
                onChanged: onChanged,
                focusNode: focusNode,
                obscureText: obscureText,
                keyboardType: keyboardType,
                style: textStyle,
                maxLines: maxLines,
                decoration: InputDecoration(
                  errorMaxLines: errorMaxLines,
                  labelStyle: TextStyle(
                    fontSize: 14,
                    color: errorText == null ? Colors.grey : Colors.red,
                  ),
                  contentPadding: contentPadding,
                  fillColor: enabled
                      ? backgroundColor ?? Colors.white
                      : Colors.grey.shade200,
                  // filled: !enabled,
                  filled: filled || !enabled,
                  enabledBorder: OutlineInputBorder(
                    borderSide: _enabledBorderSide,
                    borderRadius: BorderRadius.circular(borderRadiusValue),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: _disabledBorderSide,
                    borderRadius: BorderRadius.circular(borderRadiusValue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: _focusedBorderSide,
                    borderRadius: BorderRadius.circular(borderRadiusValue),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: _focusedErrorBorderSide,
                    borderRadius: BorderRadius.circular(borderRadiusValue),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: _errorBorderSide,
                    borderRadius: BorderRadius.circular(borderRadiusValue),
                  ),
                  errorText: errorText,
                  hintText: hintText,
                  labelText: labelText,
                  floatingLabelStyle: floatingLabelStyle,
                  hintStyle: hintStyle,
                  floatingLabelBehavior: floatingLabelBehavior,
                  prefixIcon: innerPrefixIcon,
                  suffixIcon: innerSuffixIcon,
                ),
              ),
            ),
            if (suffixIcon != null)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: suffixIcon,
              ),
          ],
        ),
      ],
    );
  }

  BorderSide get _enabledBorderSide {
    return showBorder
        ? enabledBorderSide ?? BorderSide(width: 1, color: Colors.grey.shade400)
        : BorderSide.none;
  }

  BorderSide get _disabledBorderSide {
    return showBorder
        ? disabledBorderSide ??
            BorderSide(width: 1, color: Colors.grey.shade400)
        : BorderSide.none;
  }

  BorderSide get _focusedBorderSide {
    return showBorder
        ? focusedBorderSide ?? BorderSide(width: 1, color: Colors.grey.shade900)
        : BorderSide.none;
  }

  BorderSide get _focusedErrorBorderSide {
    return showBorder
        ? focusedErrorBorderSide ??
            const BorderSide(width: 1, color: Color(0xFFF3213B))
        : BorderSide.none;
  }

  BorderSide get _errorBorderSide {
    return showBorder
        ? errorBorderSide ??
            const BorderSide(width: 1, color: Color(0xFFF3213B))
        : BorderSide.none;
  }
}

class _MaxNumberTextInputFormatter extends TextInputFormatter {
  const _MaxNumberTextInputFormatter(this.maxValue) : super();

  // In this app, fixed to 2 decimal places
  final double maxValue;

  @override
  TextEditingValue formatEditUpdate(_, newValue) {
    final newValueToDouble = double.tryParse(newValue.text);
    if (newValueToDouble == null) return newValue;

    return const TextEditingValue().copyWith(
      text: NumberFormat('#.##').format(
        min<double>(newValueToDouble, maxValue),
      ),
    );
  }
}
