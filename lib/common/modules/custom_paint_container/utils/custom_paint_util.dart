import 'dart:math' as math;

import 'package:flutter/material.dart';

// TODO: shouldRepaint, covariant 정리
class CustomPaintUtil extends CustomPainter {
  CustomPaintUtil({
    required this.onPaint,
    this.autoSaveAndRestore = true,
    bool Function(CustomPainter)? shouldRepaint,
    Color? color,
    PaintingStyle? paintingStyle,
    BlendMode? blendMode,
    double? strokeWidth,
    StrokeCap? strokeCap,
  }) : super() {
    setPaint(
      color: color,
      blendMode: blendMode,
      paintingStyle: paintingStyle,
      strokeWidth: strokeWidth,
      strokeCap: strokeCap,
    );
  }

  final void Function(CustomPaintUtil, Size) onPaint;
  final bool autoSaveAndRestore;

  final _paint = Paint();
  Canvas? _canvas;

  void setPaint({
    Color? color,
    PaintingStyle? paintingStyle,
    BlendMode? blendMode,
    double? strokeWidth,
    StrokeCap? strokeCap,
  }) {
    if (color != null) _paint.color = color;
    if (strokeWidth != null) _paint.strokeWidth = strokeWidth;
    if (paintingStyle != null) _paint.style = paintingStyle;
    if (blendMode != null) _paint.blendMode = blendMode;
    if (strokeCap != null) _paint.strokeCap = strokeCap;
  }

  void _setPaintOnlyWhileDrawing(
    void Function() draw, {
    Color? color,
    PaintingStyle? paintingStyle,
    BlendMode? blendMode,
    double? strokeWidth,
    StrokeCap? strokeCap,
  }) {
    final previousColor = _paint.color;
    final previousPaintingStyle = _paint.style;
    final previousBlendMode = _paint.blendMode;
    final previousStrokeWidth = _paint.strokeWidth;
    final previousStrokeCap = _paint.strokeCap;

    setPaint(
      color: color,
      paintingStyle: paintingStyle,
      blendMode: blendMode,
      strokeWidth: strokeWidth,
      strokeCap: strokeCap,
    );

    draw();

    setPaint(
      color: previousColor,
      paintingStyle: previousPaintingStyle,
      blendMode: previousBlendMode,
      strokeWidth: previousStrokeWidth,
      strokeCap: previousStrokeCap,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;

    if (autoSaveAndRestore) saveCanvas();
    onPaint(this, size);
    if (autoSaveAndRestore) restoreCanvas();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void saveCanvas({
    Rect rect = Rect.largest,
  }) {
    _canvas?.saveLayer(rect, _paint);
  }

  void restoreCanvas() => _canvas?.restore();

  /// 변이 4개인 일반 사변형을 그립니다
  ///
  /// leftTop -> rightTop -> rightBottom -> leftBottom 순으로 꼭짓점 인자를 입력 받습니다
  void drawQuadrilateral(
    Offset leftTop,
    Offset rightTop,
    Offset rightBottom,
    Offset leftBottom, {
    bool filled = true,
    Color? color,
    BlendMode? blendMode,
    double? strokeWidth,
    StrokeCap? strokeCap,
  }) {
    _setPaintOnlyWhileDrawing(
      () {
        final path = Path()
          ..moveTo(leftTop.dx, leftTop.dy)
          ..lineTo(rightTop.dx, rightTop.dy)
          ..lineTo(rightBottom.dx, rightBottom.dy)
          ..lineTo(leftBottom.dx, leftBottom.dy)
          ..close();

        _canvas?.drawPath(path, _paint);
      },
      paintingStyle: filled ? PaintingStyle.fill : PaintingStyle.stroke,
      color: color,
      strokeWidth: strokeWidth,
      blendMode: blendMode,
      strokeCap: strokeCap,
    );
  }

  void drawRectangle(
    double left,
    double top,
    double width,
    double height, {
    bool filled = true,
    Color? color,
    BlendMode? blendMode,
    double? strokeWidth,
    StrokeCap? strokeCap,
  }) {
    _setPaintOnlyWhileDrawing(
      () => _canvas?.drawRect(Rect.fromLTWH(left, top, width, height), _paint),
      paintingStyle: filled ? PaintingStyle.fill : PaintingStyle.stroke,
      color: color,
      strokeWidth: strokeWidth,
      blendMode: blendMode,
      strokeCap: strokeCap,
    );
  }

  void drawRectangleFromRect(
    Rect rect, {
    bool filled = true,
    Color? color,
    BlendMode? blendMode,
    double? strokeWidth,
    StrokeCap? strokeCap,
  }) {
    _setPaintOnlyWhileDrawing(
      () => _canvas?.drawRect(rect, _paint),
      paintingStyle: filled ? PaintingStyle.fill : PaintingStyle.stroke,
      color: color,
      strokeWidth: strokeWidth,
      blendMode: blendMode,
      strokeCap: strokeCap,
    );
  }

  void drawTriangle(
    Offset point1,
    Offset point2,
    Offset point3, {
    bool filled = true,
    Color? color,
    BlendMode? blendMode,
    double? strokeWidth,
    StrokeCap? strokeCap,
  }) {
    _setPaintOnlyWhileDrawing(
      () {
        final path = Path()
          ..moveTo(point1.dx, point1.dy)
          ..lineTo(point2.dx, point2.dy)
          ..lineTo(point3.dx, point3.dy)
          ..close();

        _canvas?.drawPath(path, _paint);
      },
      paintingStyle: filled ? PaintingStyle.fill : PaintingStyle.stroke,
      color: color,
      strokeWidth: strokeWidth,
      blendMode: blendMode,
      strokeCap: strokeCap,
    );
  }

  /// [onlySegmentNotSector]가 true일 시 활꼴을, false일 시 부채꼴을 그립니다
  void drawCircularShape(
    double left,
    double top,
    double width,
    double height,
    double startAngle,
    double sweepAngle, {
    bool filled = true,
    bool onlySegmentNotSector = false,
    Color? color,
    BlendMode? blendMode,
    double? strokeWidth,
    StrokeCap? strokeCap,
  }) {
    // TODO: 타원의 부채꼴 형을 그릴 때에는 중심각이 맞지 않아 수정이 필요합니다

    assert(
      width >= 0 && height >= 0,
      "'width' and 'height' don't have negative value",
    );
    assert(sweepAngle > 0, "'sweepAngle' must have positive value");
    assert(
      onlySegmentNotSector || filled,
      'Circular sector shape must be filled',
    );

    final center = Offset(left + width / 2, top + height / 2);
    final startTheta = (startAngle % 360) * math.pi / 180;
    final sweepTheta = ((sweepAngle - 1) % 360 + 1) * math.pi / 180;
    final endTheta = startTheta + sweepTheta;

    _setPaintOnlyWhileDrawing(
      () {
        _canvas?.drawArc(
          Rect.fromLTWH(left, top, width, height),
          startTheta,
          sweepTheta,
          false,
          _paint,
        );

        final p1 = Offset(
          center.dx + width / 2 * math.cos(startTheta),
          center.dy - height / 2 * math.sin(-startTheta),
        );

        final p2 = Offset(
          center.dx + width / 2 * math.cos(endTheta),
          center.dy - height / 2 * math.sin(-endTheta),
        );

        if (!onlySegmentNotSector) {
          drawTriangle(
            center,
            p1, p2,
            // Offset(
            //   center.dx + width * math.cos(startTheta),
            //   center.dy + height * math.sin(-startTheta),
            // ),
            // Offset(
            //   center.dx + width * math.cos(sweepTheta),
            //   center.dy + height * math.sin(-sweepTheta),
            // ),
          );
        }
      },
      paintingStyle: filled ? PaintingStyle.fill : PaintingStyle.stroke,
      color: color,
      strokeWidth: strokeWidth,
      blendMode: blendMode,
      strokeCap: strokeCap,
    );
  }

  void drawCircle(
    Offset center,
    double radius, {
    bool filled = true,
    Color? color,
    BlendMode? blendMode,
    double? strokeWidth,
    StrokeCap? strokeCap,
  }) {
    _setPaintOnlyWhileDrawing(
      () => _canvas?.drawCircle(center, radius, _paint),
      paintingStyle: filled ? PaintingStyle.fill : PaintingStyle.stroke,
      color: color,
      strokeWidth: strokeWidth,
      blendMode: blendMode,
      strokeCap: strokeCap,
    );
  }

  void drawLine(
    double startX,
    double startY,
    double endX,
    double endY, {
    Color? color,
    BlendMode? blendMode,
    double? strokeWidth,
    StrokeCap? strokeCap,
  }) {
    _setPaintOnlyWhileDrawing(
      () {
        _canvas?.drawLine(Offset(startX, startY), Offset(endX, endY), _paint);
      },
      color: color,
      strokeWidth: strokeWidth,
      blendMode: blendMode,
      strokeCap: strokeCap,
    );
  }

  void drawDashedLine(
    double startX,
    double startY,
    double endX,
    double endY, {
    double strokeWidth = 1,
    double? dashSpace,
    Color? color,
    BlendMode? blendMode,
    double? strokeLength,
    StrokeCap? strokeCap,
  }) {
    _setPaintOnlyWhileDrawing(
      () {
        final length = _getLength(startX, endX, startY, endY);

        final strokeXGap =
            (strokeLength ?? _paint.strokeWidth) / length * (endX - startX);
        final strokeYGap =
            (strokeLength ?? _paint.strokeWidth) / length * (endY - startY);

        var (curserX, curserY) = (startX, startY);

        while (true) {
          var nextEndX = curserX + strokeXGap;
          var nextEndY = curserY + strokeYGap;

          final isOverLength =
              _getLength(nextEndX, nextEndY, curserX, curserY) >=
                  _getLength(endX, endY, curserX, curserY);

          (nextEndX, nextEndY) =
              isOverLength ? (endX, endY) : (nextEndX, nextEndY);

          drawLine(curserX, curserY, nextEndX, nextEndY);

          if (isOverLength) break;

          final nextCurserX = nextEndX +
              strokeXGap *
                  (dashSpace ?? _paint.strokeWidth) /
                  (strokeLength ?? _paint.strokeWidth);
          final nextCurserY = nextEndY +
              strokeYGap *
                  (dashSpace ?? _paint.strokeWidth) /
                  (strokeLength ?? _paint.strokeWidth);

          final isOut =
              _getLength(nextCurserX, nextCurserY, curserX, curserY) >=
                  _getLength(endX, endY, curserX, curserY);

          if (isOut) break;

          curserX = nextCurserX;
          curserY = nextCurserY;
        }
      },
      color: color,
      strokeWidth: strokeWidth,
      blendMode: blendMode,
      strokeCap: strokeCap,
    );
  }

  double _getLength(double x1, double y1, double x2, double y2) {
    return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2));
  }
}
