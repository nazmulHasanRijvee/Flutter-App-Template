import 'package:material_ui/material_ui.dart';
import 'dart:math' as math;

import 'package:flutter_app_template/core/static/theme/theme.dart';

// ══════════════════════════════════════════════════════════════════
//  EmptyStateWidget  —  fully customizable animated empty state
//
//  Every visual element can be:
//    • shown / hidden via a show* bool
//    • overridden with your own value / widget / style
//
//  Minimal usage (all defaults):
//    EmptyStateWidget()
//
//  Full customization example:
//    EmptyStateWidget(
//      // ── visibility toggles ────────────────────────────────────
//      showIcon:          true,
//      showPulsingRings:  true,
//      showTitle:         true,
//      showSubtitle:      true,
//      showButton:        true,
//      showBouncingDots:  true,
//
//      // ── icon ──────────────────────────────────────────────────
//      icon:              Icons.folder_open_rounded,
//      iconSize:          36,
//      iconColor:         Colors.deepPurple,
//      iconCircleSize:    88,
//      iconCircleColor:   Colors.deepPurple.shade50,
//      iconCircleBorderColor: Colors.deepPurple.shade200,
//      floatAmplitude:    16,
//      floatDuration:     Duration(milliseconds: 2500),
//
//      // ── rings ─────────────────────────────────────────────────
//      ringColor:         Colors.deepPurple,
//      pulseDuration:     Duration(milliseconds: 2200),
//
//      // ── title ─────────────────────────────────────────────────
//      title:             'Nothing here yet',
//      titleStyle:        TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//
//      // ── subtitle ──────────────────────────────────────────────
//      subtitle:          'Tap the button below to add your first item.',
//      subtitleStyle:     TextStyle(fontSize: 14, color: Colors.grey),
//      subtitleMaxLines:  4,
//
//      // ── button ────────────────────────────────────────────────
//      buttonLabel:       'Get started',
//      buttonTextStyle:   TextStyle(fontSize: 14),
//      buttonForegroundColor: Colors.deepPurple,
//      buttonBorderColor: Colors.deepPurple,
//      buttonBorderRadius: 12,
//      buttonPadding:     EdgeInsets.symmetric(horizontal: 28, vertical: 12),
//      onAction:          () => print('tapped'),
//      // OR replace the button entirely:
//      customButton:      ElevatedButton(onPressed: ..., child: Text('Go')),
//
//      // ── dots ──────────────────────────────────────────────────
//      dotCount:          3,
//      dotSize:           6,
//      dotColor:          Colors.deepPurple.shade200,
//      dotBounceHeight:   8,
//      dotDuration:       Duration(milliseconds: 1200),
//
//      // ── layout ────────────────────────────────────────────────
//      padding:           EdgeInsets.all(40),
//      spacing:           20,
//
//      // ── fade-in ───────────────────────────────────────────────
//      fadeDuration:      Duration(milliseconds: 800),
//    )
// ══════════════════════════════════════════════════════════════════

class EmptyStateWidget extends StatefulWidget {
  // ── visibility toggles ──────────────────────────────────────────
  final bool showIcon;
  final bool showPulsingRings;
  final bool showTitle;
  final bool showSubtitle;
  final bool showButton;
  final bool showBouncingDots;

  // ── icon ────────────────────────────────────────────────────────
  final IconData icon;
  final double iconSize;
  final Color? iconColor;
  final double iconCircleSize;
  final Color? iconCircleColor;
  final Color? iconCircleBorderColor;
  final double floatAmplitude;
  final Duration floatDuration;

  // ── rings ───────────────────────────────────────────────────────
  final Color? ringColor;
  final Duration pulseDuration;

  // ── title ───────────────────────────────────────────────────────
  final String title;
  final TextStyle? titleStyle;

  // ── subtitle ────────────────────────────────────────────────────
  final String subtitle;
  final TextStyle? subtitleStyle;
  final int subtitleMaxLines;

  // ── button ──────────────────────────────────────────────────────
  final String buttonLabel;
  final TextStyle? buttonTextStyle;
  final Color? buttonForegroundColor;
  final Color? buttonBorderColor;
  final double buttonBorderRadius;
  final EdgeInsets buttonPadding;
  final VoidCallback? onAction;

  /// Provide a completely custom button widget; replaces the default OutlinedButton.
  final Widget? customButton;

  // ── dots ────────────────────────────────────────────────────────
  final int dotCount;
  final double dotSize;
  final Color? dotColor;
  final double dotBounceHeight;
  final Duration dotDuration;

  // ── layout ──────────────────────────────────────────────────────
  final EdgeInsets padding;
  final double spacing;

  // ── fade-in ─────────────────────────────────────────────────────
  final Duration fadeDuration;

  const EmptyStateWidget({
    super.key,
    // visibility
    this.showIcon = true,
    this.showPulsingRings = true,
    this.showTitle = true,
    this.showSubtitle = true,
    this.showButton = true,
    this.showBouncingDots = true,
    // icon
    this.icon = Icons.photo_outlined,
    this.iconSize = 30,
    this.iconColor,
    this.iconCircleSize = 80,
    this.iconCircleColor,
    this.iconCircleBorderColor,
    this.floatAmplitude = 12,
    this.floatDuration = const Duration(milliseconds: 3000),
    // rings
    this.ringColor,
    this.pulseDuration = const Duration(milliseconds: 2800),
    // title
    this.title = 'No items yet',
    this.titleStyle,
    // subtitle
    this.subtitle =
        'Your collection is empty. Add your first item to get started.',
    this.subtitleStyle,
    this.subtitleMaxLines = 3,
    // button
    this.buttonLabel = 'Add your first item',
    this.buttonTextStyle,
    this.buttonForegroundColor,
    this.buttonBorderColor,
    this.buttonBorderRadius = 8,
    this.buttonPadding = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 10,
    ),
    this.onAction,
    this.customButton,
    // dots
    this.dotCount = 3,
    this.dotSize = 5,
    this.dotColor,
    this.dotBounceHeight = 6,
    this.dotDuration = const Duration(milliseconds: 1400),
    // layout
    this.padding = const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
    this.spacing = 24,
    // fade
    this.fadeDuration = const Duration(milliseconds: 600),
  });

  @override
  State<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends State<EmptyStateWidget>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _pulseController;
  late AnimationController _dotController;
  late AnimationController _fadeController;

  late Animation<double> _floatAnim;
  late Animation<double> _pulse1Anim;
  late Animation<double> _pulse2Anim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _floatController = AnimationController(
      vsync: this,
      duration: widget.floatDuration,
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: 0, end: -widget.floatAmplitude).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: widget.pulseDuration,
    )..repeat(reverse: true);

    _pulse1Anim = Tween<double>(begin: 0.85, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulse2Anim = Tween<double>(begin: 0.88, end: 1.08).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Interval(0.15, 1.0, curve: Curves.easeInOut),
      ),
    );

    _dotController = AnimationController(
      vsync: this,
      duration: widget.dotDuration,
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: widget.fadeDuration,
    )..forward();

    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(EmptyStateWidget old) {
    super.didUpdateWidget(old);
    if (old.floatDuration != widget.floatDuration ||
        old.pulseDuration != widget.pulseDuration ||
        old.dotDuration != widget.dotDuration ||
        old.fadeDuration != widget.fadeDuration ||
        old.floatAmplitude != widget.floatAmplitude) {
      _floatController.dispose();
      _pulseController.dispose();
      _dotController.dispose();
      _fadeController.dispose();
      _initAnimations();
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    _dotController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(_fadeAnim),
        child: Center(
          child: Padding(
            padding: widget.padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _spaced([
                if (widget.showIcon) _buildIconSection(cs),
                if (widget.showTitle) _buildTitle(context),
                if (widget.showSubtitle) _buildSubtitle(context, cs),
                if (widget.showButton) _buildButton(cs),
                if (widget.showBouncingDots) _buildDots(cs),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconSection(ColorScheme cs) {
    return AnimatedBuilder(
      animation: Listenable.merge([_floatController, _pulseController]),
      builder: (context, _) {
        final outerSize = widget.iconCircleSize * 1.75;
        final innerSize = widget.iconCircleSize * 1.375;

        return SizedBox(
          width: outerSize,
          height: outerSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.showPulsingRings)
                Transform.scale(
                  scale: _pulse2Anim.value,
                  child: Opacity(
                    opacity: _lerpOpacity(_pulseController.value, 0.08, 0.18),
                    child: Container(
                      width: outerSize,
                      height: outerSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.ringColor ?? cs.outline,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              if (widget.showPulsingRings)
                Transform.scale(
                  scale: _pulse1Anim.value,
                  child: Opacity(
                    opacity: _lerpOpacity(_pulseController.value, 0.15, 0.4),
                    child: Container(
                      width: innerSize,
                      height: innerSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.ringColor ?? cs.outline,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              Transform.translate(
                offset: Offset(0, _floatAnim.value),
                child: Container(
                  width: widget.iconCircleSize,
                  height: widget.iconCircleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.iconCircleColor ?? cs.surface,
                    border: Border.all(
                      color:
                          widget.iconCircleBorderColor ??
                          cs.outline.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      widget.icon,
                      size: widget.iconSize,
                      color:
                          widget.iconColor ?? cs.primary.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _lerpOpacity(double t, double min, double max) =>
      min + (max - min) * ((math.sin(t * math.pi) + 1) / 2);

  /// Inserts [spacing] only between visible children.
  List<Widget> _spaced(List<Widget?> children) {
    final visible = children.whereType<Widget>().toList();
    final result = <Widget>[];
    for (var i = 0; i < visible.length; i++) {
      result.add(visible[i]);
      if (i < visible.length - 1) result.add(SizedBox(height: widget.spacing));
    }
    return result;
  }

  Widget _buildTitle(BuildContext context) => Text(
    widget.title,
    style:
        widget.titleStyle ??
        Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
    textAlign: TextAlign.center,
  );

  Widget _buildSubtitle(BuildContext context, ColorScheme cs) => Text(
    widget.subtitle,
    style:
        widget.subtitleStyle ??
        Theme.of(context).textTheme.bodySmall?.copyWith(
          color: cs.onSurface.withValues(alpha: 0.45),
          height: 1.6,
          fontSize: 13,
        ),
    textAlign: TextAlign.center,
    maxLines: widget.subtitleMaxLines,
    overflow: TextOverflow.ellipsis,
  );

  Widget _buildButton(ColorScheme cs) {
    if (widget.customButton != null) return widget.customButton!;
    return OutlinedButton(
      onPressed: widget.onAction,
      style: OutlinedButton.styleFrom(
        foregroundColor: widget.buttonForegroundColor ?? cs.primary,
        side: BorderSide(
          color: widget.buttonBorderColor ?? cs.primary,
          width: 1,
        ),
        padding: widget.buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.buttonBorderRadius),
        ),
      ),
      child: Text(
        widget.buttonLabel,
        style:
            widget.buttonTextStyle ??
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildDots(ColorScheme cs) => _BouncingDots(
    controller: _dotController,
    count: widget.dotCount,
    dotSize: widget.dotSize,
    dotColor: widget.dotColor ?? cs.onSurface.withValues(alpha: 0.3),
    bounceHeight: widget.dotBounceHeight,
  );
}

// ══════════════════════════════════════════════════════════════════
//  BouncingDots
// ══════════════════════════════════════════════════════════════════

class _BouncingDots extends StatelessWidget {
  final AnimationController controller;
  final int count;
  final double dotSize;
  final Color dotColor;
  final double bounceHeight;

  const _BouncingDots({
    required this.controller,
    required this.count,
    required this.dotSize,
    required this.dotColor,
    required this.bounceHeight,
  });

  double _bounceCurve(double t) {
    if (t < 0.4) return math.sin(t / 0.4 * math.pi);
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final delay = i * 0.16;
              final t = ((controller.value - delay) % 1.0).clamp(0.0, 1.0);
              final bounce = _bounceCurve(t);
              return Transform.translate(
                offset: Offset(0, -bounce * bounceHeight),
                child: Opacity(
                  opacity: 0.3 + bounce * 0.7,
                  child: Container(
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dotColor,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  Demo / Playground  —  remove in production
// ══════════════════════════════════════════════════════════════════

void main() => runApp(const _DemoApp());

class _DemoApp extends StatelessWidget {
  const _DemoApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF4A80F0),
        useMaterial3: true,
      ),
      home: const _PlaygroundPage(),
    );
  }
}

class _PlaygroundPage extends StatefulWidget {
  const _PlaygroundPage();
  @override
  State<_PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<_PlaygroundPage> {
  // ── visibility ──────────────────────────────────────────────────
  bool showIcon = true;
  bool showRings = true;
  bool showTitle = true;
  bool showSubtitle = true;
  bool showButton = true;
  bool showDots = true;

  // ── content ─────────────────────────────────────────────────────
  String title = 'No items yet';
  String subtitle =
      'Your collection is empty. Add your first item to get started.';
  String buttonLabel = 'Add your first item';
  IconData icon = Icons.photo_outlined;

  // ── numeric ─────────────────────────────────────────────────────
  double iconSize = 30;
  double iconCircleSize = 80;
  double floatAmplitude = 12;
  double dotCount = 3;
  double dotSize = 5;
  double dotBounce = 6;
  double spacing = 24;
  double titleFontSize = 18;
  double subtitleFontSize = 13;

  // ── colour ──────────────────────────────────────────────────────
  Color accentColor = const Color(0xFF4A80F0);

  static const _iconOptions = <String, IconData>{
    'photo': Icons.photo_outlined,
    'search': Icons.search_rounded,
    'inbox': Icons.inbox_outlined,
    'tasks': Icons.check_circle_outline_rounded,
    'folder': Icons.folder_open_rounded,
    'star': Icons.star_outline_rounded,
    'bookmark': Icons.bookmark_outline_rounded,
    'chat': Icons.chat_bubble_outline_rounded,
  };

  static const _colorOptions = <String, Color>{
    'Blue': Color(0xFF4A80F0),
    'Purple': Color(0xFF7C3AED),
    'Teal': Color(0xFF0F9D82),
    'Coral': Color(0xFFD85A30),
    'Pink': Color(0xFFD4537E),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Empty State Playground')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 600;
          final preview = Container(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
            child: EmptyStateWidget(
              showIcon: showIcon,
              showPulsingRings: showRings,
              showTitle: showTitle,
              showSubtitle: showSubtitle,
              showButton: showButton,
              showBouncingDots: showDots,
              icon: icon,
              iconSize: iconSize,
              iconColor: accentColor.withValues(alpha: 0.75),
              iconCircleSize: iconCircleSize,
              iconCircleColor: accentColor.withValues(alpha: 0.08),
              iconCircleBorderColor: accentColor.withValues(alpha: 0.25),
              floatAmplitude: floatAmplitude,
              ringColor: accentColor,
              title: title,
              titleStyle: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              subtitle: subtitle,
              subtitleStyle: TextStyle(
                fontSize: subtitleFontSize,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.45),
                height: 1.6,
              ),
              buttonLabel: buttonLabel,
              buttonForegroundColor: accentColor,
              buttonBorderColor: accentColor,
              onAction: () => ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Button tapped!'))),
              dotCount: dotCount.round(),
              dotSize: dotSize,
              dotColor: accentColor.withValues(alpha: 0.4),
              dotBounceHeight: dotBounce,
              spacing: spacing,
            ),
          );

          final controls = Material(
            elevation: 1,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('Visibility'),
                  _toggle(
                    'Icon',
                    showIcon,
                    (v) => setState(() => showIcon = v),
                  ),
                  _toggle(
                    'Pulsing rings',
                    showRings,
                    (v) => setState(() => showRings = v),
                  ),
                  _toggle(
                    'Title',
                    showTitle,
                    (v) => setState(() => showTitle = v),
                  ),
                  _toggle(
                    'Subtitle',
                    showSubtitle,
                    (v) => setState(() => showSubtitle = v),
                  ),
                  _toggle(
                    'Button',
                    showButton,
                    (v) => setState(() => showButton = v),
                  ),
                  _toggle(
                    'Bouncing dots',
                    showDots,
                    (v) => setState(() => showDots = v),
                  ),

                  _sectionHeader('Content'),
                  _textField('Title', title, (v) => setState(() => title = v)),
                  _textField(
                    'Subtitle',
                    subtitle,
                    (v) => setState(() => subtitle = v),
                  ),
                  _textField(
                    'Button',
                    buttonLabel,
                    (v) => setState(() => buttonLabel = v),
                  ),

                  _sectionHeader('Icon'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _iconOptions.entries.map((e) {
                      final sel = icon == e.value;
                      return GestureDetector(
                        onTap: () => setState(() => icon = e.value),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: sel ? accentColor : Colors.grey.shade300,
                              width: sel ? 2 : 1,
                            ),
                          ),
                          child: Icon(
                            e.value,
                            size: 20,
                            color: sel ? accentColor : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  _slider(
                    'Icon size',
                    iconSize,
                    16,
                    56,
                    (v) => setState(() => iconSize = v),
                  ),
                  _slider(
                    'Circle size',
                    iconCircleSize,
                    48,
                    120,
                    (v) => setState(() => iconCircleSize = v),
                  ),
                  _slider(
                    'Float amplitude',
                    floatAmplitude,
                    0,
                    24,
                    (v) => setState(() => floatAmplitude = v),
                  ),

                  _sectionHeader('Typography'),
                  _slider(
                    'Title size',
                    titleFontSize,
                    12,
                    28,
                    (v) => setState(() => titleFontSize = v),
                  ),
                  _slider(
                    'Subtitle size',
                    subtitleFontSize,
                    10,
                    18,
                    (v) => setState(() => subtitleFontSize = v),
                  ),

                  _sectionHeader('Dots'),
                  _slider(
                    'Count',
                    dotCount,
                    1,
                    7,
                    (v) => setState(() => dotCount = v),
                  ),
                  _slider(
                    'Size',
                    dotSize,
                    3,
                    12,
                    (v) => setState(() => dotSize = v),
                  ),
                  _slider(
                    'Bounce height',
                    dotBounce,
                    2,
                    16,
                    (v) => setState(() => dotBounce = v),
                  ),

                  _sectionHeader('Layout'),
                  _slider(
                    'Spacing',
                    spacing,
                    8,
                    48,
                    (v) => setState(() => spacing = v),
                  ),

                  _sectionHeader('Accent colour'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _colorOptions.entries.map((e) {
                      final sel = accentColor == e.value;
                      return GestureDetector(
                        onTap: () => setState(() => accentColor = e.value),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: e.value,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: sel ? Colors.black : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );

          if (wide) {
            return Row(
              children: [
                Expanded(flex: 3, child: preview),
                SizedBox(width: 300, child: controls),
              ],
            );
          } else {
            return Column(
              children: [
                SizedBox(height: 280, child: preview),
                Expanded(child: controls),
              ],
            );
          }
        },
      ),
    );
  }

  // ── control helpers ─────────────────────────────────────────────

  Widget _sectionHeader(String label) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 6),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    ),
  );

  Widget _toggle(String label, bool value, ValueChanged<bool> onChanged) =>
      SwitchListTile.adaptive(
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(label, style: const TextStyle(fontSize: 13)),
        value: value,
        onChanged: onChanged,
      );

  Widget _slider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              value.round().toString(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: (max - min).round(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _textField(
    String label,
    String value,
    ValueChanged<String> onChanged,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      style: const TextStyle(fontSize: 13),
      onChanged: onChanged,
    ),
  );
}
