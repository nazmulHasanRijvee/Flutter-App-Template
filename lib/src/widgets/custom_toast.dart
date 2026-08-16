import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class CustomToast {
  static void showSuccess(
    BuildContext context, {
    required String title,
    String? description,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.minimal,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 3),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      borderRadius: BorderRadius.circular(12),
      boxShadow: highModeShadow,
      showProgressBar: false,
    );
  }

  static void showError(
    BuildContext context, {
    required String title,
    String? description,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.minimal,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 3),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      borderRadius: BorderRadius.circular(12),
      boxShadow: highModeShadow,
      showProgressBar: false,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String title,
    String? description,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.minimal,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 3),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      borderRadius: BorderRadius.circular(12),
      boxShadow: highModeShadow,
      showProgressBar: false,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String title,
    String? description,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.minimal,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 3),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      borderRadius: BorderRadius.circular(12),
      boxShadow: highModeShadow,
      showProgressBar: false,
    );
  }
}
