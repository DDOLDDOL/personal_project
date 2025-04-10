import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:personal_project/common/common.dart';

// icon과 text를 같이 child에 할당할 시 8의 간격이 적당합니다 (Recommended)
class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.onPressed,
    this.loadingWhen = false,
    this.borderRadiusValue = 8,
    this.elevation = 2,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.enabledColor = Palette.themeColor,
    this.disabledColor = Palette.buttonDisabledBackground,
    this.enabledButtonTextColor = Colors.white,
    this.disabledButtonTextColor = Palette.buttonDisabledForeground,
    this.border,
    this.width = double.maxFinite,
    this.height = 56,
    this.child,
  });

  final void Function()? onPressed;
  final bool loadingWhen;
  final double borderRadiusValue;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final Color enabledColor;
  final Color disabledColor;
  final Color enabledButtonTextColor;
  final Color disabledButtonTextColor;
  final BorderSide? border;
  final double width;
  final double height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        surfaceTintColor: Colors.transparent,
        elevation: elevation,
        padding: padding,
        fixedSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          side: onPressed == null
              ? BorderSide(width: border?.width ?? 0, color: Colors.grey)
              : border ?? const BorderSide(width: 0, color: Colors.transparent),
        ),
        backgroundColor: enabledColor,
        disabledBackgroundColor: disabledColor,
        foregroundColor: enabledButtonTextColor,
        disabledForegroundColor: disabledButtonTextColor,
      ),
      onPressed: loadingWhen ? () {} : onPressed,
      child: loadingWhen
          ? _loadingIndicator()
          : _Child(
              content: child,
              foregroundColor: onPressed == null
                  ? disabledButtonTextColor
                  : enabledButtonTextColor,
            ),
    );
  }

  Widget _loadingIndicator() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(color: enabledButtonTextColor),
    );
  }
}

class _Child extends StatelessWidget {
  const _Child({
    Key? key,
    required this.content,
    required this.foregroundColor,
  }) : super(key: key);

  final Widget? content;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return content == null
        ? Text('확인', style: _defaultTextStyle)
        : content is Text
            ? DefaultTextStyle(
                style: _defaultTextStyle,
                child: Text(
                  (content! as Text).data!,
                  maxLines: (content! as Text).maxLines,
                  textAlign: (content! as Text).textAlign,
                  overflow: (content! as Text).overflow,
                  style: (content! as Text).style ?? _defaultTextStyle,
                ),
              )
            : content!;
  }

  TextStyle get _defaultTextStyle {
    return TextStyles.semiAccent.copyWith(color: Colors.white);
  }
}

class _ButtonForm extends StatelessWidget {
  const _ButtonForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

enum _ButtonType { large, medium, small, mini }
