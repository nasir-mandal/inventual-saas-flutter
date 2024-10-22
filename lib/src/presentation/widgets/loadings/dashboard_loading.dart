import 'package:flutter/material.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shimmer/shimmer.dart';

class DashboardLoading extends StatelessWidget {
  const DashboardLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: ColorSchema.grey.withOpacity(0.3),
                    highlightColor: ColorSchema.grey.withOpacity(0.1),
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: ColorSchema.grey.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: ColorSchema.grey.withOpacity(0.3),
                        highlightColor: ColorSchema.grey.withOpacity(0.1),
                        child: Container(
                          width: 100.0,
                          height: 16.0,
                          color: ColorSchema.grey.withOpacity(0.3),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Shimmer.fromColors(
                        baseColor: ColorSchema.grey.withOpacity(0.3),
                        highlightColor: ColorSchema.grey.withOpacity(0.1),
                        child: Container(
                          width: 60.0,
                          height: 12.0,
                          color: ColorSchema.grey.withOpacity(0.3),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Shimmer.fromColors(
              baseColor: ColorSchema.grey.withOpacity(0.3),
              highlightColor: ColorSchema.grey.withOpacity(0.1),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 100.0,
                decoration: BoxDecoration(
                  color: ColorSchema.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                ),
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: ColorSchema.grey.withOpacity(0.3),
                    highlightColor: ColorSchema.grey.withOpacity(0.1),
                    child: Column(
                      children: [
                        Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: ColorSchema.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          width: 60.0,
                          height: 12.0,
                          color: ColorSchema.grey.withOpacity(0.3),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Shimmer.fromColors(
              baseColor: ColorSchema.grey.withOpacity(0.3),
              highlightColor: ColorSchema.grey.withOpacity(0.1),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 100.0,
                decoration: BoxDecoration(
                  color: ColorSchema.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
