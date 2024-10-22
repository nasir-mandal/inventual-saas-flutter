import 'package:get/get.dart';
import 'package:inventual/src/presentation/screens/add_product/add_product_main_screen.dart';
import 'package:inventual/src/presentation/screens/add_user/add_user_main_screen.dart';
import 'package:inventual/src/presentation/screens/analytics/analytics_main_screen.dart';
import 'package:inventual/src/presentation/screens/authentication/find_supplier.dart';
import 'package:inventual/src/presentation/screens/authentication/login_screen.dart';
import 'package:inventual/src/presentation/screens/authentication/register_screen.dart';
import 'package:inventual/src/presentation/screens/biller/biller_main_screen.dart';
import 'package:inventual/src/presentation/screens/biller/biller_sections/create_biller_section.dart';
import 'package:inventual/src/presentation/screens/brand/brand_main_screen.dart';
import 'package:inventual/src/presentation/screens/category/category_main_screen.dart';
import 'package:inventual/src/presentation/screens/customer/customer_main_screen.dart';
import 'package:inventual/src/presentation/screens/customer/customer_sections/create_customer_section.dart';
import 'package:inventual/src/presentation/screens/customer_reports/customer_reports_main_screen.dart';
import 'package:inventual/src/presentation/screens/dashboard/dashboard_main_screen.dart';
import 'package:inventual/src/presentation/screens/discount_reports/discount_report_main_screen.dart';
import 'package:inventual/src/presentation/screens/expense/expense_main_screen.dart';
import 'package:inventual/src/presentation/screens/expense_category/expense_category_main_Screen.dart';
import 'package:inventual/src/presentation/screens/expense_list/expense_list_main_screen.dart';
import 'package:inventual/src/presentation/screens/expense_reports/expense_reports_main_screen.dart';
import 'package:inventual/src/presentation/screens/management/management_main_screen.dart';
import 'package:inventual/src/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:inventual/src/presentation/screens/payment_reports/payment_reports_main_screen.dart';
import 'package:inventual/src/presentation/screens/pos_sales/pos_sales_main_screen.dart';
import 'package:inventual/src/presentation/screens/products/products_main_screen.dart';
import 'package:inventual/src/presentation/screens/products_reports/products_reports_main_screen.dart';
import 'package:inventual/src/presentation/screens/profile/profile_main_screen.dart';
import 'package:inventual/src/presentation/screens/purchase/create_purchase/create_purchase_main_screen.dart';
import 'package:inventual/src/presentation/screens/purchase/create_purchase_return/create_purchase_return_main_screen.dart';
import 'package:inventual/src/presentation/screens/purchase/purchase_main_screen.dart';
import 'package:inventual/src/presentation/screens/purchase/purchase_sections/purchase_return_section.dart';
import 'package:inventual/src/presentation/screens/purchase_reports/purchase_reports_main_screen.dart';
import 'package:inventual/src/presentation/screens/reports/report_main_screen.dart';
import 'package:inventual/src/presentation/screens/sales/salesSections/create_sales_return/create_sales_return_main_screen.dart';
import 'package:inventual/src/presentation/screens/sales/salesSections/sales_return_section.dart';
import 'package:inventual/src/presentation/screens/sales/sales_main_screen.dart';
import 'package:inventual/src/presentation/screens/splash_screen/splash_screen.dart';
import 'package:inventual/src/presentation/screens/stock_reports/stock_reports_main_screen.dart';
import 'package:inventual/src/presentation/screens/supplier/supplier_main_screen.dart';
import 'package:inventual/src/presentation/screens/supplier/supplier_sections/create_supplier_section.dart';
import 'package:inventual/src/presentation/screens/supplier_reports/supplier_reports_main_screen.dart';
import 'package:inventual/src/presentation/screens/tax_report/tax_report_main_screen.dart';
import 'package:inventual/src/presentation/screens/unit/unit_management_main_screen.dart';
import 'package:inventual/src/presentation/screens/user_reports/user_reports_main_screen.dart';
import 'package:inventual/src/presentation/screens/user_role/user_role_main_screen.dart';
import 'package:inventual/src/presentation/screens/warehouse/warehouse_main_screen.dart';
import 'package:inventual/src/presentation/screens/warehouse/warehouse_sections/add_warehouse_section.dart';
import 'package:inventual/src/presentation/screens/warehouse_reports/warehouse_reports_main_screen.dart';
import 'package:inventual/src/presentation/widgets/no_permission_page.dart';

class AppRoutes {
  static const String onboarding = "/onboarding";
  static const String login = "/login";
  static const String register = "/register";
  static const String findSupplier = "/findSupplier";
  static const String forgotPassword = "/forgotPassword";
  static const String dashboard = "/dashboard";
  static const String analytics = "/analytics";
  static const String sales = "/sales";
  static const String posSales = "/posSales";
  static const String purchase = "/purchase";
  static const String products = "/products";
  static const String expense = "/expense";
  static const String customer = "/customer";
  static const String report = "/report";
  static const String management = "/management";
  static const String warehouse = "/warehouse";
  static const String notification = "/notification";
  static const String support = "/support";
  static const String addProduct = "/productList";
  static const String createPurchase = "/createPurchase";
  static const String createPurchaseReturn = "/createPurchaseReturn";
  static const String createSalesReturn = "/createSalesReturn";
  static const String category = "/category";
  static const String brand = "/brand";
  static const String unit = "/unit";
  static const String purchaseReports = "/purchaseReports";
  static const String paymentReports = "/paymentReports";
  static const String productsReports = "/productsReports";
  static const String stockReports = "/stockReports";
  static const String expenseReports = "/expenseReports";
  static const String userReports = "/userReports";
  static const String customerReports = "/customerReports";
  static const String warehouseReports = "/warehouseReports";
  static const String supplierReports = "/supplierReports";
  static const String discountReport = "/discountReport";
  static const String taxReport = "/taxReport";
  static const String profile = "/profile";
  static const String notificationContent = "/notificationContent";
  static const String expenseList = "/expenseList";
  static const String expenseCategory = "/expenseCategory";
  static const String addWarehouse = "/addWarehouse";
  static const String userRole = "/userRole";
  static const String addUser = "/addUser";
  static const String supplier = "/supplier";
  static const String biller = "/biller";
  static const String addCustomer = "/addCustomer";
  static const String createSupplier = "/createSupplier";
  static const String createBiller = "/createBiller";
  static const String purchaseReturn = "/purchaseReturn";
  static const String invoice = "/invoice";
  static const String purchaseInvoice = "/purchaseInvoice";
  static const String expenseInvoice = "/expenseInvoice";
  static const String addSaleInvoice = "/addSaleInvoice";
  static const String addPurchaseInvoice = "/addPurchaseInvoice";
  static const String addExpenseInvoice = "/addExpenseInvoice";
  static const String salesReturn = "/salesReturn";
  static const String splashScreen = "/splashScreen";
  static const String noPermission = "/noPermission";

  static final List<GetPage> pages = [
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: register, page: () => const RegisterScreen()),
    GetPage(name: findSupplier, page: () => const FindSupplier()),
    GetPage(name: dashboard, page: () => const DashboardMainScreen()),
    GetPage(name: analytics, page: () => const AnalyticsMainScreen()),
    GetPage(name: sales, page: () => const SalesMainScreen()),
    GetPage(name: posSales, page: () => const POSSalesMainScreen()),
    GetPage(name: purchase, page: () => const PurchaseMainScreen()),
    GetPage(name: products, page: () => const ProductsMainScreen()),
    GetPage(name: expense, page: () => const ExpenseMainScreen()),
    GetPage(name: customer, page: () => const CustomerMainScreen()),
    GetPage(name: report, page: () => const ReportMainScreen()),
    GetPage(name: management, page: () => const ManagementMainScreen()),
    GetPage(name: warehouse, page: () => const WarehouseMainScreen()),
    GetPage(name: addProduct, page: () => const AddProductMainScreen()),
    GetPage(name: createPurchase, page: () => const CreatePurchaseMainScreen()),
    GetPage(
        name: createPurchaseReturn,
        page: () => const CreatePurchaseReturnMainScreen()),
    GetPage(
        name: createSalesReturn,
        page: () => const CreateSalesReturnMainScreen()),
    GetPage(name: category, page: () => const CategoryMainScreen()),
    GetPage(name: brand, page: () => const BrandMainScreen()),
    GetPage(name: unit, page: () => const UnitManagementMainScreen()),
    GetPage(
        name: purchaseReports, page: () => const PurchaseReportsMainScreen()),
    GetPage(name: paymentReports, page: () => const PaymentReportsMainScreen()),
    GetPage(
        name: productsReports, page: () => const ProductsReportsMainScreen()),
    GetPage(name: stockReports, page: () => const StockReportsMainScreen()),
    GetPage(name: expenseReports, page: () => const ExpenseReportsMainScreen()),
    GetPage(name: userReports, page: () => const UserReportsMainScreen()),
    GetPage(
        name: customerReports, page: () => const CustomerReportsMainScreen()),
    GetPage(
        name: warehouseReports, page: () => const WarehouseReportsMainScreen()),
    GetPage(
        name: supplierReports, page: () => const SupplierReportsMainScreen()),
    GetPage(name: discountReport, page: () => const DiscountReportMainScreen()),
    GetPage(name: taxReport, page: () => const TaxReportMainScreen()),
    GetPage(name: profile, page: () => const ProfileMainScreen()),
    GetPage(name: expenseList, page: () => const ExpenseListMainScreen()),
    GetPage(
        name: expenseCategory, page: () => const ExpenseCategoryMainScreen()),
    GetPage(name: addWarehouse, page: () => const AddWarehouseSection()),
    GetPage(name: userRole, page: () => const UserRoleMainScreen()),
    GetPage(name: addUser, page: () => const AddUserMainScreen()),
    GetPage(name: supplier, page: () => const SupplierMainScreen()),
    GetPage(name: biller, page: () => const BillerMainScreen()),
    GetPage(name: addCustomer, page: () => const AddCustomerSection()),
    GetPage(name: createSupplier, page: () => const CreateSupplierSection()),
    GetPage(name: createBiller, page: () => const CreateBillerSection()),
    GetPage(name: purchaseReturn, page: () => const PurchaseReturnSection()),
    GetPage(name: salesReturn, page: () => const SalesReturnSection()),
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: noPermission, page: () => const NoPermissionPage()),
  ];
}
