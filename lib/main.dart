import 'package:flutter/material.dart';
import 'package:orderplus/data/design_config.dart';
import 'package:orderplus/ui/screen/add_item_screen.dart';
import 'package:orderplus/ui/screen/home_screen.dart';
import 'package:orderplus/ui/screen/income_screen.dart';
import 'package:orderplus/ui/screen/menu_screen.dart';
import 'package:orderplus/ui/screen/order_queue_screen.dart';
import 'package:orderplus/ui/screen/payment_screen.dart';
// import 'package:orderplus/ui/widget/acitvity_card.dart';
// import 'package:orderplus/ui/widget/header_row.dart';
// import 'package:orderplus/ui/widget/income_box.dart';
// import 'package:orderplus/ui/widget/infor_card.dart';
// import 'package:orderplus/ui/widget/order_pay_alert.dart';
// import 'package:orderplus/ui/widget/order_payment_card.dart';
// import 'package:orderplus/ui/widget/acitvity_card.dart';
// import 'package:orderplus/ui/widget/header_row.dart';
// import 'package:orderplus/ui/widget/order_queue_card.dart';
// import 'package:orderplus/ui/widget/order_tem.dart';
// import 'package:orderplus/ui/widget/product_card.dart';
// import 'package:orderplus/ui/widget/search_bar.dart';
// import 'package:orderplus/ui/widget/selection_bar.dart';
// import 'package:orderplus/ui/widget/order_tem.dart';
// import 'package:orderplus/ui/widget/product_card.dart';
// import 'package:orderplus/ui/widget/product_infor.dart';
// import 'package:orderplus/ui/widget/infor_card.dart';
// import 'package:orderplus/ui/widget/icon_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text("OrderPlus")),
        body: Center(
          // child: InfoCard(color: Colors.white,iconColor: const Color(0xFFF27F0D),title: "Total Order Today",value: "100",icon: Icons.insert_emoticon_outlined,)
          // child:  HeaderRow(leftIcon: Icons.chevron_left_outlined, title: "Main Menu", rightIcon: Icons.settings, onRightIconPressed: () => {},onLeftIconPressed: ()=>{},)
          // child:  ActivityCard(icon: Icons.currency_exchange_outlined,iconColor: const Color(0xFFF27F0D),color:Colors.white,title: "Order For user",value:"2 min Ago",height: 90,)
          // child: ProductCard(title: "Bay Cha Nom Rg",price: 3, imageAssetPath: 'burgur.png',onAddTap: () => print("Add to Card"),),
          // child: OrderItem(price: 100,title: "Baycha",quantity: 2,onAddNote: () => print("note"),onDecrement: () => print("DCR"),onIncrement: () => print("ICR"),),
          // child: ProductQueueCard(orderNumber: "121212",itemsSummary: "Baycha X2",timeAgo: "2 min ago",isNew: true,status: OrderStatus.inProgress,onActionTap: () => print("Mark"),),
          // child: OrderPayment(
          //   orderNumber: "#1024",
          //   price: 24.50,
          //   customerName: "John D.",
          //   itemCount: 3,
          //   isPaid: false,
          //   onToggleChanged: (value) {
          //     print("Switch value: $value");
          //   },
          // ),
          // child: CustomIconButton(
          //   icon: Icons.fastfood,
          //   color: const Color(0xFFF27F0D),
          //   iconColor: Colors.white,
          //   text: "Click Now",
          //   height: 60,
          //   onPressed: () {
          //     print("Button clicked!");
          //   },
          // ),
          // child: OrderPaymentAlert(
          //   orderNumber: "#58923",
          //   time: "10:42 AM",
          //   price: 24.50,
          //   onTap: () {
          //     print("Alert tapped");
          //   },
          // ),
          // child: IncomeMetricCard(
          //   title: "Profit",
          //   value: "\$843.15",
          //   percentage: "3.1%",
          //   isPositive: true,
          // ),
          // child: SearchBarComponent(
          //   hintText: "Search for a menu item...",
          //   onChanged: (value) {
          //     print("Searching for: $value");
          //   },
          // ),
          // child: SelectionBar(
          //   items: const ["Daily", "Weekly", "Monthly", "Yearly"],
          //   onItemSelected: (index) => print("Selected index: $index"),
          // ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: IncomeScreen(),
          ),
        ),
      ),
    );
  }
}
