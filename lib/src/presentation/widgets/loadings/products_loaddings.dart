import 'package:flutter/material.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shimmer/shimmer.dart';

class ProductListLoading extends StatelessWidget {
  const ProductListLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorSchema.grey.withOpacity(0.3),
      highlightColor: ColorSchema.grey.withOpacity(0.3),
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80.0,
                  height: 80.0,
                  color: ColorSchema.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16.0,
                        color: ColorSchema.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 16.0,
                        color: ColorSchema.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                      ),
                      Container(
                        width: 100.0,
                        height: 16.0,
                        color: ColorSchema.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
