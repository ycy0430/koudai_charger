// import 'package:flutter/material.dart';
// import 'package:koudai_charger/pages/Theme.dart';
// import 'package:koudai_charger/res/listData.dart';
// import 'package:koudai_charger/widgets/HomeNewsCell.dart';

// //分类页
// class WDefaultTab extends StatefulWidget {
//   WDefaultTab({Key key}) : super(key: key);

//   @override
//   _WDefaultTabState createState() => _WDefaultTabState();
// }

// class _WDefaultTabState extends State<WDefaultTab> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           title: Row(
//             children: [
//               Expanded(
//                 child: TabBar(
//                   isScrollable: true,
//                   indicatorColor: Colors.red, //选中下划线颜色
//                   labelColor: Colors.red, //选中字体颜色
//                   unselectedLabelColor: Colors.red[250], // 未选中字体颜色
//                   indicatorSize: TabBarIndicatorSize.label,
//                   tabs: [
//                     Tab(
//                       text: "Android",
//                     ),
//                     Tab(
//                       text: "IOS",
//                     ),
//                     Tab(
//                       text: "Flutter",
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // ListView(),
//             // ListView(),
//             // ListView(),

//             HomeNewsCell(
//                 "https://gank.io/api/v2/data/category/GanHuo/type/Android/page/1/count/10"),
//             HomeNewsCell(
//                 "https://gank.io/api/v2/data/category/GanHuo/type/iOS/page/1/count/10"),
//             HomeNewsCell(
//                 "https://gank.io/api/v2/data/category/GanHuo/type/Flutter/page/1/count/10"),
//           ],
//         ),
//       ),
//     );
//   }
// }
