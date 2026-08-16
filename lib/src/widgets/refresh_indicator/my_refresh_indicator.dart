// lib/src/widgets/arc_refresh_indicator.dart

import 'dart:math' show cos, sin, pi;
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum RefreshStyle { arc, ripple, orbital, wave }

class MyRefreshIndicator extends StatefulWidget {
  const MyRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.color,
    this.size = 40.0,
    this.indicatorHeight = 80.0,
    this.strokeWidth = 2.5,
    this.style = RefreshStyle.orbital,
  });

  final AsyncCallback onRefresh;
  final Widget child;
  final Color? color;
  final double size;
  final double indicatorHeight;
  final double strokeWidth;
  final RefreshStyle style;

  @override
  State<MyRefreshIndicator> createState() => _MyRefreshIndicatorState();
}

class _MyRefreshIndicatorState extends State<MyRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    return CustomRefreshIndicator(
      onRefresh: widget.onRefresh,
      builder:
          (BuildContext context, Widget child, IndicatorController controller) {
            return AnimatedBuilder(
              animation: Listenable.merge([_spin, controller]),
              builder: (context, _) {
                // Clamp indicator slot height to [0, indicatorHeight]
                final slotHeight = (controller.value * widget.indicatorHeight)
                    .clamp(0.0, widget.indicatorHeight);

                final opacity = controller.value.clamp(0.0, 1.0);
                final isVisible = controller.state != IndicatorState.idle;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Indicator slot ──────────────────────────────────────
                    // Always occupies exactly `slotHeight` px — content
                    // starts below this, so they can never overlap.
                    ClipRect(
                      child: SizedBox(
                        height: slotHeight,
                        child: isVisible
                            ? Opacity(
                                opacity: opacity,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: CustomPaint(
                                    size: Size(widget.size, widget.size),
                                    painter: _resolvePainter(
                                      value: controller.value,
                                      state: controller.state,
                                      spinAngle: _spin.value * 2 * pi,
                                      color: color,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),

                    // ── Scrollable content ──────────────────────────────────
                    // Wrapped in Expanded so it fills remaining space.
                    // IgnorePointer blocks taps while actively refreshing
                    // so the user cannot interact with stale content.
                    Expanded(
                      child: IgnorePointer(
                        ignoring: controller.state == IndicatorState.loading,
                        child: child,
                      ),
                    ),
                  ],
                );
              },
            );
          },
      child: widget.child,
    );
  }

  CustomPainter _resolvePainter({
    required double value,
    required IndicatorState state,
    required double spinAngle,
    required Color color,
  }) {
    return switch (widget.style) {
      RefreshStyle.ripple => _RipplePainter(
        value: value,
        state: state,
        spinAngle: spinAngle,
        color: color,
        strokeWidth: widget.strokeWidth,
      ),
      RefreshStyle.orbital => _OrbitalPainter(
        value: value,
        state: state,
        spinAngle: spinAngle,
        color: color,
        strokeWidth: widget.strokeWidth,
      ),
      RefreshStyle.wave => _WavePainter(
        value: value,
        state: state,
        spinAngle: spinAngle,
        color: color,
        strokeWidth: widget.strokeWidth,
      ),
      _ => _ArcPainter(
        value: value,
        state: state,
        spinAngle: spinAngle,
        color: color,
        strokeWidth: widget.strokeWidth,
      ),
    };
  }
}
// ─── Arc Painter (original) ──────────────────────────────────────────────────

class _ArcPainter extends CustomPainter {
  const _ArcPainter({
    required this.value,
    required this.state,
    required this.spinAngle,
    required this.color,
    required this.strokeWidth,
  });

  final double value;
  final IndicatorState state;
  final double spinAngle;
  final Color color;
  final double strokeWidth;

  static const _startAngle = -pi / 2;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color.withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final isLoading = state == IndicatorState.loading;
    final isComplete = state == IndicatorState.complete;

    if (isLoading || isComplete) {
      final sweepAngle = isComplete ? 2 * pi : _breathingSweep();
      canvas.drawArc(
        rect,
        spinAngle + _startAngle,
        sweepAngle,
        false,
        arcPaint,
      );

      canvas.drawArc(
        rect,
        spinAngle + _startAngle - 0.6,
        0.6,
        false,
        Paint()
          ..color = color.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );

      if (!isComplete) {
        final dotAngle = spinAngle + _startAngle + sweepAngle;
        canvas.drawCircle(
          Offset(
            center.dx + radius * cos(dotAngle),
            center.dy + radius * sin(dotAngle),
          ),
          strokeWidth * 1.2,
          Paint()
            ..color = color
            ..style = PaintingStyle.fill,
        );
      }
      canvas.drawCircle(
        center,
        strokeWidth * 1.1,
        Paint()
          ..color = color.withValues(alpha: 0.7)
          ..style = PaintingStyle.fill,
      );

      if (isComplete) {
        final r = size.width * 0.18;
        canvas.drawPath(
          Path()
            ..moveTo(center.dx - r, center.dy)
            ..lineTo(center.dx - r * 0.2, center.dy + r * 0.8)
            ..lineTo(center.dx + r, center.dy - r * 0.6),
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round,
        );
      }
    } else {
      final progress = value.clamp(0.0, 1.0);
      final sweep = progress * 2 * pi * 0.85;
      if (sweep > 0.05) {
        canvas.drawArc(rect, _startAngle, sweep, false, arcPaint);
      }

      if (progress > 0.08) {
        final tipAngle = _startAngle + sweep;
        final tx = center.dx + radius * cos(tipAngle);
        final ty = center.dy + radius * sin(tipAngle);
        final perpAngle = tipAngle + pi / 2;
        final arrowSize = strokeWidth * 2.2;
        final arrowPaint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth * 0.9
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(
          Offset(
            tx - arrowSize * cos(perpAngle - 0.5),
            ty - arrowSize * sin(perpAngle - 0.5),
          ),
          Offset(tx, ty),
          arrowPaint,
        );
        canvas.drawLine(
          Offset(
            tx - arrowSize * cos(perpAngle + 0.5),
            ty - arrowSize * sin(perpAngle + 0.5),
          ),
          Offset(tx, ty),
          arrowPaint,
        );
      }

      final ir = size.width * 0.18;
      final iconPaint = Paint()
        ..color = color.withValues(alpha: progress.clamp(0.3, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth * 0.9
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(
        progress < 0.85
            ? (Path()
                ..moveTo(center.dx, center.dy - ir)
                ..lineTo(center.dx, center.dy + ir)
                ..moveTo(center.dx - ir * 0.7, center.dy + ir * 0.3)
                ..lineTo(center.dx, center.dy + ir)
                ..lineTo(center.dx + ir * 0.7, center.dy + ir * 0.3))
            : (Path()
                ..moveTo(center.dx - ir, center.dy)
                ..lineTo(center.dx - ir * 0.15, center.dy + ir * 0.75)
                ..lineTo(center.dx + ir, center.dy - ir * 0.55)),
        iconPaint,
      );
    }
  }

  double _breathingSweep() =>
      pi + (pi * 2 / 3) * ((sin(spinAngle * 1.5) + 1) / 2);

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.value != value ||
      old.state != state ||
      old.spinAngle != spinAngle ||
      old.color != color;
}

// ─── Ripple Painter (new) ────────────────────────────────────────────────────

class _RipplePainter extends CustomPainter {
  const _RipplePainter({
    required this.value,
    required this.state,
    required this.spinAngle,
    required this.color,
    required this.strokeWidth,
  });

  final double value;
  final IndicatorState state;
  final double spinAngle;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);
    final maxR = size.width / 2;

    final isLoading = state == IndicatorState.loading;
    final isComplete = state == IndicatorState.complete;

    if (isLoading || isComplete) {
      if (!isComplete) {
        // 3 ripple rings expanding outward at staggered phases
        for (int i = 0; i < 3; i++) {
          final phase = (spinAngle * 0.8 + i * 2.1) % (2 * pi);
          final t = (sin(phase) + 1) / 2;
          final r = 4.0 + t * (maxR - 6);
          final opacity = 0.55 * (1 - t);
          canvas.drawCircle(
            center,
            r,
            Paint()
              ..color = color.withValues(alpha: opacity)
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth * 0.75,
          );
        }
      }

      // Spinning dashed outer ring
      final dashPaint = Paint()
        ..color = isComplete ? color : color.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // Draw dashed ring manually (8 dashes)
      const dashCount = 8;
      for (int i = 0; i < dashCount; i++) {
        final startAngle = spinAngle + (i / dashCount) * 2 * pi;
        final sweepAngle = (1 / dashCount) * 2 * pi * 0.55;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: maxR - strokeWidth),
          startAngle,
          sweepAngle,
          false,
          dashPaint,
        );
      }

      // Inner solid dot
      canvas.drawCircle(
        center,
        strokeWidth * 1.4,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );

      if (isComplete) {
        // Burst lines
        for (int i = 0; i < 8; i++) {
          final angle = (i / 8) * 2 * pi;
          final inner = maxR * 0.45;
          final outer = maxR * 0.75;
          canvas.drawLine(
            Offset(cx + inner * cos(angle), cy + inner * sin(angle)),
            Offset(cx + outer * cos(angle), cy + outer * sin(angle)),
            Paint()
              ..color = color.withValues(alpha: 0.65)
              ..strokeWidth = strokeWidth * 0.75
              ..strokeCap = StrokeCap.round,
          );
        }
        // Checkmark
        final r = size.width * 0.16;
        canvas.drawPath(
          Path()
            ..moveTo(cx - r, cy)
            ..lineTo(cx - r * 0.1, cy + r * 0.8)
            ..lineTo(cx + r, cy - r * 0.55),
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round,
        );
      }
    } else {
      // Dragging: concentric rings scale with pull
      final progress = value.clamp(0.0, 1.0);
      const rings = [0.38, 0.62, 1.0];
      for (int i = 0; i < rings.length; i++) {
        final r = rings[i] * (maxR - strokeWidth) * progress;
        if (r < 1) continue;
        canvas.drawCircle(
          center,
          r,
          Paint()
            ..color = color.withValues(alpha: 0.1 + i * 0.1)
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth * 0.7,
        );
      }

      // Center dot grows with pull
      canvas.drawCircle(
        center,
        3.5 * progress + 1.0,
        Paint()
          ..color = color.withValues(alpha: progress.clamp(0.3, 1.0))
          ..style = PaintingStyle.fill,
      );

      // Center icon: down arrow → checkmark at threshold
      final ir = size.width * 0.17 * progress.clamp(0.4, 1.0);
      canvas.drawPath(
        progress < 0.85
            ? (Path()
                ..moveTo(cx, cy - ir * 0.5)
                ..lineTo(cx, cy + ir * 0.5)
                ..moveTo(cx - ir * 0.6, cy + ir * 0.05)
                ..lineTo(cx, cy + ir * 0.65)
                ..lineTo(cx + ir * 0.6, cy + ir * 0.05))
            : (Path()
                ..moveTo(cx - ir, cy)
                ..lineTo(cx - ir * 0.1, cy + ir * 0.8)
                ..lineTo(cx + ir, cy - ir * 0.5)),
        Paint()
          ..color = color.withValues(alpha: progress.clamp(0.3, 1.0))
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth * 0.9
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RipplePainter old) =>
      old.value != value ||
      old.state != state ||
      old.spinAngle != spinAngle ||
      old.color != color;
}
// 3. Paste these two painters at the bottom of the file

// ─── Orbital Painter ─────────────────────────────────────────────────────────

class _OrbitalPainter extends CustomPainter {
  const _OrbitalPainter({
    required this.value,
    required this.state,
    required this.spinAngle,
    required this.color,
    required this.strokeWidth,
  });

  final double value;
  final IndicatorState state;
  final double spinAngle;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);
    final maxR = size.width / 2;

    final isLoading = state == IndicatorState.loading;
    final isComplete = state == IndicatorState.complete;

    if (isLoading || isComplete) {
      if (!isComplete) {
        // Orbit guide rings
        for (final r in [maxR - strokeWidth, maxR * 0.55]) {
          canvas.drawCircle(
            center,
            r,
            Paint()
              ..color = color.withValues(alpha: 0.1)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.0,
          );
        }

        // 4 outer dots with trailing fade
        const outerN = 4;
        for (int i = 0; i < outerN; i++) {
          final baseA = spinAngle + i * (2 * pi / outerN);
          for (int t = 1; t <= 4; t++) {
            canvas.drawCircle(
              Offset(
                cx + (maxR - strokeWidth) * cos(baseA - t * 0.22),
                cy + (maxR - strokeWidth) * sin(baseA - t * 0.22),
              ),
              1.8,
              Paint()
                ..color = color.withValues(alpha: 0.07 * t)
                ..style = PaintingStyle.fill,
            );
          }
          canvas.drawCircle(
            Offset(
              cx + (maxR - strokeWidth) * cos(baseA),
              cy + (maxR - strokeWidth) * sin(baseA),
            ),
            strokeWidth * 1.2,
            Paint()
              ..color = color
              ..style = PaintingStyle.fill,
          );
        }

        // 2 inner counter-rotating dots
        for (int i = 0; i < 2; i++) {
          final a = -spinAngle * 1.4 + i * pi;
          canvas.drawCircle(
            Offset(cx + maxR * 0.55 * cos(a), cy + maxR * 0.55 * sin(a)),
            strokeWidth * 0.85,
            Paint()
              ..color = color.withValues(alpha: 0.75)
              ..style = PaintingStyle.fill,
          );
        }
      }

      // Pulsing / solid center
      final pulse = isComplete ? 1.0 : 1.0 + 0.15 * sin(spinAngle * 3);
      canvas.drawCircle(
        center,
        strokeWidth * 1.6 * pulse,
        Paint()
          ..color = color.withValues(alpha: 0.9)
          ..style = PaintingStyle.fill,
      );

      if (isComplete) {
        // 12-ray starburst
        for (int i = 0; i < 12; i++) {
          final a = (i / 12) * 2 * pi;
          final inner = i.isEven ? maxR * 0.38 : maxR * 0.52;
          final outer = i.isEven ? maxR * 0.72 : maxR * 0.62;
          canvas.drawLine(
            Offset(cx + inner * cos(a), cy + inner * sin(a)),
            Offset(cx + outer * cos(a), cy + outer * sin(a)),
            Paint()
              ..color = color.withValues(alpha: i.isEven ? 0.8 : 0.35)
              ..strokeWidth = i.isEven ? 1.8 : 1.1
              ..strokeCap = StrokeCap.round,
          );
        }
        // Filled center dot + white check
        canvas.drawCircle(
          center,
          maxR * 0.35,
          Paint()
            ..color = color
            ..style = PaintingStyle.fill,
        );
        final r = maxR * 0.16;
        canvas.drawPath(
          Path()
            ..moveTo(cx - r, cy)
            ..lineTo(cx - r * 0.1, cy + r * 0.85)
            ..lineTo(cx + r, cy - r * 0.5),
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round,
        );
      }
    } else {
      // Dragging: dots orbit into place
      final p = value.clamp(0.0, 1.0);
      final orbitR = maxR * 0.5 + p * maxR * 0.4;
      canvas.drawCircle(
        center,
        orbitR,
        Paint()
          ..color = color.withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );

      const n = 5;
      for (int i = 0; i < n; i++) {
        final a = (i / n) * 2 * pi - pi / 2;
        final dotR = strokeWidth * (0.5 + p);
        canvas.drawCircle(
          Offset(cx + orbitR * cos(a), cy + orbitR * sin(a)),
          dotR,
          Paint()
            ..color = color.withValues(alpha: 0.3 + 0.7 * (i / n) * p)
            ..style = PaintingStyle.fill,
        );
      }

      // Center icon
      final ir = size.width * 0.16 * p.clamp(0.4, 1.0);
      canvas.drawPath(
        p < 0.85
            ? (Path()
                ..moveTo(cx, cy - ir)
                ..lineTo(cx, cy + ir)
                ..moveTo(cx - ir * 0.65, cy + ir * 0.3)
                ..lineTo(cx, cy + ir)
                ..lineTo(cx + ir * 0.65, cy + ir * 0.3))
            : (Path()
                ..moveTo(cx - ir, cy)
                ..lineTo(cx - ir * 0.1, cy + ir * 0.8)
                ..lineTo(cx + ir, cy - ir * 0.5)),
        Paint()
          ..color = color.withValues(alpha: p.clamp(0.3, 1.0))
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth * 0.9
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(_OrbitalPainter old) =>
      old.value != value ||
      old.state != state ||
      old.spinAngle != spinAngle ||
      old.color != color;
}

// ─── Wave Painter ─────────────────────────────────────────────────────────────

class _WavePainter extends CustomPainter {
  const _WavePainter({
    required this.value,
    required this.state,
    required this.spinAngle,
    required this.color,
    required this.strokeWidth,
  });

  final double value;
  final IndicatorState state;
  final double spinAngle;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final isLoading = state == IndicatorState.loading;
    final isComplete = state == IndicatorState.complete;

    const n = 7;
    const barW = 4.5;
    const gap = 2.0;
    const totalW = n * barW + (n - 1) * gap;
    final startX = cx - totalW / 2 + barW / 2;
    const maxH = 22.0;

    if (isLoading) {
      // Animated sine wave bars
      for (int i = 0; i < n; i++) {
        final x = startX + i * (barW + gap);
        final phase = spinAngle * 2.2 + i * (pi * 2 / n) * 0.85;
        final t = (sin(phase) + 1) / 2;
        final h = 4.0 + t * maxH;
        final op = 0.35 + 0.65 * t;
        final rr = RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(x, cy), width: barW, height: h),
          const Radius.circular(barW / 2),
        );
        canvas.drawRRect(
          rr,
          Paint()
            ..color = color.withValues(alpha: op)
            ..style = PaintingStyle.fill,
        );
      }
      // Baseline
      canvas.drawLine(
        Offset(cx - totalW / 2, cy + maxH / 2 + 4),
        Offset(cx + totalW / 2, cy + maxH / 2 + 4),
        Paint()
          ..color = color.withValues(alpha: 0.12)
          ..strokeWidth = 1.0,
      );
    } else if (isComplete) {
      // Hill silhouette bars
      const heights = [4.0, 10.0, 18.0, 10.0, 4.0];
      const cn = 5;
      const cBarW = 4.0;
      const cGap = 3.0;
      const cTotalW = cn * cBarW + (cn - 1) * cGap;
      final cStartX = cx - cTotalW / 2 + cBarW / 2;
      for (int i = 0; i < cn; i++) {
        final x = cStartX + i * (cBarW + cGap);
        final h = heights[i];
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(x, cy), width: cBarW, height: h),
            const Radius.circular(cBarW / 2),
          ),
          Paint()
            ..color = color.withValues(alpha: 0.25)
            ..style = PaintingStyle.fill,
        );
      }
      // Check ring + mark
      canvas.drawCircle(
        Offset(cx, cy),
        size.width * 0.38,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth * 0.9,
      );
      final ir = size.width * 0.16;
      canvas.drawPath(
        Path()
          ..moveTo(cx - ir, cy)
          ..lineTo(cx - ir * 0.1, cy + ir * 0.8)
          ..lineTo(cx + ir, cy - ir * 0.5),
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    } else {
      // Dragging: bars grow with pull amount
      final p = value.clamp(0.0, 1.0);
      const dn = 5;
      const dBarW = 4.0;
      const dGap = 3.0;
      const dTotalW = dn * dBarW + (dn - 1) * dGap;
      final dStartX = cx - dTotalW / 2 + dBarW / 2;
      for (int i = 0; i < dn; i++) {
        final x = dStartX + i * (dBarW + dGap);
        final wave = sin((i / (dn - 1)) * pi);
        final h = (4.0 + p * 18.0 * (0.35 + 0.65 * wave)).clamp(2.0, 22.0);
        final op = 0.25 + 0.65 * p * (0.4 + 0.6 * wave);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(x, cy), width: dBarW, height: h),
            const Radius.circular(dBarW / 2),
          ),
          Paint()
            ..color = color.withValues(alpha: op)
            ..style = PaintingStyle.fill,
        );
      }
      // Down arrow hint below bars
      if (p > 0.1) {
        canvas.drawPath(
          Path()
            ..moveTo(cx, cy + 16)
            ..lineTo(cx - 5, cy + 11)
            ..moveTo(cx, cy + 16)
            ..lineTo(cx + 5, cy + 11),
          Paint()
            ..color = color.withValues(alpha: p)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.8
            ..strokeCap = StrokeCap.round,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_WavePainter old) =>
      old.value != value ||
      old.state != state ||
      old.spinAngle != spinAngle ||
      old.color != color;
}
