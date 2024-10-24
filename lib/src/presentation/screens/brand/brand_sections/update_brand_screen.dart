import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/brand/create_brand_controller.dart';
import 'package:inventual_saas/src/presentation/screens/brand/brand_main_screen.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class UpdateBrandScreen extends StatefulWidget {
  final dynamic brand;

  const UpdateBrandScreen({super.key, required this.brand});

  @override
  State<UpdateBrandScreen> createState() => _UpdateBrandScreenState();
}

class _UpdateBrandScreenState extends State<UpdateBrandScreen> {
  final BrandController _createController = BrandController();
  TextEditingController brandNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    "Edit Brand",
                    style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: ColorSchema.lightBlack,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 26,
                    color: ColorSchema.lightBlack,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
          Divider(
            color: ColorSchema.grey.withOpacity(0.3),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(() => Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _createController.pickImage();
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Obx(() {
                            return CircleAvatar(
                              backgroundColor:
                                  ColorSchema.blue.withOpacity(0.05),
                              radius: 60,
                              backgroundImage:
                                  _createController.selectedFile.value != null
                                      ? FileImage(_createController.selectedFile
                                          .value!) as ImageProvider<Object>
                                      : widget.brand['image'].isNotEmpty
                                          ? NetworkImage(widget.brand['image'])
                                              as ImageProvider<Object>
                                          : const AssetImage(
                                                  "assets/images/logo/dell.png")
                                              as ImageProvider<Object>,
                            );
                          }),
                          const Positioned(
                            right: 0,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: ColorSchema.primaryColor,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: ColorSchema.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildOptionalInputTextField(
                    "${widget.brand['title']}",
                    TextInputType.text,
                    _createController.title.value,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.maxFinite,
                    child: buildFromSubmitButton(
                        checkValidation: _createBrand,
                        buttonName: "Update Brand"),
                  ),
                  const SizedBox(height: 40),
                ],
              )))
        ],
      ),
    );
  }

  _createBrand() async {
    if (_formKey.currentState!.validate()) {
      bool successUpdate = await _createController.updateBrand(widget.brand);
      if (successUpdate) {
        Get.off(const BrandMainScreen());
      }
    }
  }
}
