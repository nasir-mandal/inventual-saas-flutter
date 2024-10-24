import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class CustomLoading extends StatelessWidget {
  final dynamic opacity;
  final bool isColorOpacity;
  const CustomLoading({
    super.key,
    required this.opacity,
    this.isColorOpacity = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        opacity: opacity ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: Container(
          color: ColorSchema.primaryColor.withOpacity(0.15),
          child: const Center(
            child: GFLoader(
              size: GFSize.LARGE,
              type: GFLoaderType.circle,
            ),
          ),
        ),
      ),
    );
  }
}
