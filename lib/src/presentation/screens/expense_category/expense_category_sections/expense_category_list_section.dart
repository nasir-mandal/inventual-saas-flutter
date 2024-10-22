import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/presentation/screens/expense_category/expense_category_sections/expense_category_update_section.dart';
import 'package:inventual/src/presentation/widgets/toast/delete_toast.dart';
import 'package:inventual/src/utils/contstants.dart';

class ExpenseCategoryListSection extends StatefulWidget {
  final dynamic isSmallScreen;
  final dynamic categoryList;

  const ExpenseCategoryListSection(
      {super.key, required this.isSmallScreen, required this.categoryList});

  @override
  State<ExpenseCategoryListSection> createState() =>
      _ExpenseCategoryListSectionState();
}

class _ExpenseCategoryListSectionState
    extends State<ExpenseCategoryListSection> {
  @override
  Widget build(BuildContext context) {
    if (widget.categoryList.isEmpty) {
      return Expanded(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/other/empty_product.png",
            width: 350,
          ),
          Text(
            "No Category Found",
            style: GoogleFonts.raleway(
                fontWeight: FontWeight.w500,
                fontSize: 24,
                color: ColorSchema.white54),
          )
        ],
      )));
    } else {
      return Expanded(
        child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: widget.categoryList.length,
            itemBuilder: (context, index) {
              final category = widget.categoryList[index];
              return Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      category["category-name"],
                      style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: ColorSchema.lightBlack,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        category["subCategory-name"],
                        style: GoogleFonts.nunito(),
                      ),
                    ),
                    trailing: PopupMenuButton(
                      padding: EdgeInsets.zero,
                      color: ColorSchema.white,
                      onSelected: (value) {
                        if (value == 'Edit') {
                          buildModalBottomSheet(context, category);
                        } else if (value == 'Delete') {
                          setState(() {
                            DeleteToast.showDeleteToast(
                                context, category["category-name"]);
                            widget.categoryList.removeAt(index);
                          });
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'Edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                size: 20,
                                color: ColorSchema.blue.withOpacity(0.7),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                size: 20,
                                color: ColorSchema.danger.withOpacity(0.7),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: ColorSchema.borderColor)
                ],
              );
            }),
      );
    }
  }

  void buildModalBottomSheet(BuildContext context, category) {
    showModalBottomSheet(
      backgroundColor: ColorSchema.white,
      elevation: 0,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      context: context,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: ExpenseCategoryUpdateSection(category: category),
        );
      },
    );
  }
}
