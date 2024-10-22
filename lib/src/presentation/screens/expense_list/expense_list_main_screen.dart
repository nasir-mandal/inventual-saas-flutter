import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/expense/expense_list.dart';
import 'package:inventual/src/presentation/screens/expense_list/expense_list_sections/expense_list_section.dart';
import 'package:inventual/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual/src/presentation/widgets/floating_aciton_button/custom_floating_action_button.dart';
import 'package:inventual/src/presentation/widgets/loadings/table_loading_two.dart';
import 'package:inventual/src/presentation/widgets/not_found.dart';
import 'package:inventual/src/routes/app_routes.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseListMainScreen extends StatefulWidget {
  const ExpenseListMainScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseListMainScreen> createState() => _ExpenseListMainScreenState();
}

class _ExpenseListMainScreenState extends State<ExpenseListMainScreen> {
  final ExpenseListController expenseListController = ExpenseListController();
  late Map<String, dynamic> user = {};
  @override
  void initState() {
    expenseListController.fetchExpenseReport();
    loadUser().then(
      (value) => setState(() {
        user = value ?? {};
      }),
    );
    super.initState();
  }

  Future<Map<String, dynamic>?> loadUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString("user");
    if (userString != null) {
      return jsonDecode(userString) as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final permission = user['userPermissions'];
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(navigateName: "Expense List"),
        ),
        body: Container(
          color: ColorSchema.white70,
          child: Obx(() => expenseListController.isLoading.value == true
              ? const TableLoadingTwo()
              : expenseListController.expenseList.isEmpty
                  ? const NotFound()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Manage Expense List",
                            style: GoogleFonts.raleway(
                                textStyle: const TextStyle(
                                    color: ColorSchema.lightBlack,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                                child: HorizontalExpenseTableSection(
                                    expenseListData:
                                        expenseListController.expenseList))),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    )),
        ),
        floatingActionButton: CustomFloatingActionButton(
            buttonName: "Add Expense",
            routeName: permission['add_permission_expenses']
                ? AppRoutes.expense
                : AppRoutes.noPermission));
  }
}
