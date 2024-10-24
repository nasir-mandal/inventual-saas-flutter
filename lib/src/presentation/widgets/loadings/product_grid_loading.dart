import 'package:flutter/material.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shimmer/shimmer.dart';

class ProductGridLoading extends StatelessWidget {
  const ProductGridLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Shimmer.fromColors(
        baseColor: ColorSchema.grey.withOpacity(0.3),
        highlightColor: ColorSchema.grey.withOpacity(0.1),
        child: GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 4.0,
            childAspectRatio: 1,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 120.0,
                  color: ColorSchema.white,
                ),
                const SizedBox(height: 8.0),
                Container(
                  width: double.infinity,
                  height: 16.0,
                  color: ColorSchema.white,
                ),
                const SizedBox(height: 4.0),
                Container(
                  width: 60.0,
                  height: 16.0,
                  color: ColorSchema.white,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
