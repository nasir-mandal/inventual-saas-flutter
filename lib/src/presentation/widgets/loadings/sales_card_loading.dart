import 'package:flutter/material.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shimmer/shimmer.dart';

class SalesCardLoading extends StatelessWidget {
  const SalesCardLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorSchema.grey.withOpacity(0.3),
      highlightColor: ColorSchema.grey.withOpacity(0.1),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: ColorSchema.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: ColorSchema.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: const BoxDecoration(
                    color: ColorSchema.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12.0),
                Container(
                  width: 80.0,
                  height: 16.0,
                  color: ColorSchema.white,
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Container(
              width: double.infinity,
              height: 24.0,
              color: ColorSchema.white,
            ),
            const SizedBox(height: 8.0),
            Container(
              width: 60.0,
              height: 16.0,
              color: ColorSchema.white,
            ),
          ],
        ),
      ),
    );
  }
}
