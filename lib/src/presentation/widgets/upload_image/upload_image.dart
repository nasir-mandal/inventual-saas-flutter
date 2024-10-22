import 'package:flutter/material.dart';
import 'package:inventual/src/utils/contstants.dart';

class UploadImage extends StatelessWidget {
  final String image;

  const UploadImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: ColorSchema.blue.withOpacity(0.05),
            radius: 60,
            backgroundImage: AssetImage(image),
          ),
          const Positioned(
              right: 0,
              child: CircleAvatar(
                  radius: 18,
                  backgroundColor: ColorSchema.primaryColor,
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: ColorSchema.white,
                  )))
        ],
      ),
    );
  }
}
