import 'package:flutter/material.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shimmer/shimmer.dart';

class TableLoadingTwo extends StatelessWidget {
  const TableLoadingTwo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorSchema.grey.withOpacity(0.3),
      highlightColor: ColorSchema.grey.withOpacity(0.1),
      child: ListView.builder(
        itemCount: 20,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
            child: Row(
              children: [
                Container(
                  width: 80.0,
                  height: 40.0,
                  color: ColorSchema.white,
                ),
                const SizedBox(width: 2),
                Container(
                  width: 130.0,
                  height: 40.0,
                  color: ColorSchema.white,
                ),
                const SizedBox(width: 2),
                Container(
                  width: 145.0,
                  height: 40.0,
                  color: ColorSchema.white,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
