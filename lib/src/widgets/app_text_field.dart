import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/static/theme/theme.dart';

typedef Validator = String? Function(String value);

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final Validator? validator;

  final String? hintText;
  final String? labelText;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final bool obscureText;
  final bool enableToggleObscure;
  final Widget? obscureIcon;
  final Widget? obscureIconOff;

  final TextInputType keyboardType;
  final TextInputAction? textInputAction;

  final int maxLines;
  final int? maxLength;

  final bool enabled;
  final bool readOnly;
  final bool validateOnEmpty;

  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onTap;

  final FocusNode? focusNode;
  final bool enableInvalidShake;

  const AppTextField({
    super.key,
    required this.controller,
    this.validator,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enableToggleObscure = false,
    this.obscureIcon,
    this.obscureIconOff,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.validateOnEmpty = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.enableInvalidShake = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField>
    with SingleTickerProviderStateMixin {
  String? errorText;

  bool _obscure = false;

  Timer? _debounce;

  late final AnimationController _controller;
  late final Animation<double> _offset;

  @override
  void initState() {
    super.initState();

    _obscure = widget.obscureText;

    widget.controller.addListener(_onChanged);

    // shake animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _offset = Tween<double>(
      begin: 0,
      end: 6,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_controller);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validate(widget.controller.text);
    });
  }

  void _onChanged() {
    final value = widget.controller.text;

    widget.onChanged?.call(value);

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _validate(value);
    });
  }

  void _validate(String value) {
    if (widget.validator == null) return;

    if (!widget.validateOnEmpty && value.trim().isEmpty) {
      setState(() => errorText = null);
      return;
    }

    final result = widget.validator!(value);

    if (result != errorText) {
      setState(() {
        errorText = result;
      });

      if (result != null) {
        _triggerShake();
      }
    }
  }

  void _triggerShake() {
    if (widget.enableInvalidShake) {
      _controller.forward(from: 0);
    }
  }

  void _toggleVisibility() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offset,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_offset.value, 0),
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            obscureText: _obscure,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            onSubmitted: widget.onSubmitted,
            decoration: InputDecoration(
              hintText: widget.hintText,
              labelText: widget.labelText,
              errorText: errorText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.enableToggleObscure
                  ? IconButton(
                      onPressed: _toggleVisibility,
                      icon: _obscure
                          ? (widget.obscureIconOff ??
                                const Icon(Icons.visibility_off))
                          : (widget.obscureIcon ??
                                const Icon(Icons.visibility)),
                    )
                  : widget.suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  context.dimensions.padding.p12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
