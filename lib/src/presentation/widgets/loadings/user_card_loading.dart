import 'package:flutter/material.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shimmer/shimmer.dart';

class UserCardLoading extends StatelessWidget {
  const UserCardLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Shimmer.fromColors(
        baseColor: ColorSchema.grey.withOpacity(0.3),
        highlightColor: ColorSchema.grey.withOpacity(0.1),
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150.0,
                      height: 20.0,
                      color: ColorSchema.white,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Container(
                          width: 20.0,
                          height: 20.0,
                          color: ColorSchema.white,
                        ),
                        const SizedBox(width: 8.0),
                        Container(
                          width: 200.0,
                          height: 20.0,
                          color: ColorSchema.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Container(
                          width: 20.0,
                          height: 20.0,
                          color: ColorSchema.white,
                        ),
                        const SizedBox(width: 8.0),
                        Container(
                          width: 100.0,
                          height: 20.0,
                          color: ColorSchema.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: 80.0,
                      height: 20.0,
                      color: ColorSchema.white,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: ColorSchema.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: ColorSchema.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
