import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final double radius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool isLoading;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.height = 40.0,
    this.width = 40.0,
    this.radius = 0.0,
    this.placeholder,
    this.errorWidget,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius.r),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
        imageBuilder: (context, imageProvider) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius.r),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          );
        },
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return placeholder ??
              Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius.r),
                  color: Colors.grey.shade200,
                ),
                child: Center(
                  child: CupertinoActivityIndicator(color: Colors.amber[900]),
                ),
              );
        },
        errorWidget: (context, url, error) {
          return errorWidget ??
              Container(
                height: height,
                width: width,
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius.r),
                  color: Colors.grey.shade200,
                ),
                child: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[400],
                  ),
                ),
              );
        },
      ),
    );
  }
}
