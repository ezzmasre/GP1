import 'package:flutter/material.dart';
import 'package:wibsite/home_page/workout.dart/Patientspages/Depressions.dart';
import 'package:wibsite/home_page/workout.dart/Patientspages/patientDesk.dart';
import 'package:wibsite/home_page/workout.dart/Patientspages/patentHeadache.dart';
import 'package:wibsite/home_page/workout.dart/Patientspages/patentKneePain.dart';
import 'package:wibsite/home_page/workout.dart/Patientspages/patentObesity.dart'; // Uncommented
import 'package:wibsite/home_page/workout.dart/Patientspages/patentOsteoporosis.dart';
import 'package:wibsite/home_page/workout.dart/Patientspages/patentPressure.dart';
import 'package:wibsite/home_page/workout.dart/Patientspages/patentStress.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 8, vsync: this); // Match the tab count
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                isScrollable: true,
                controller: _tabController,
                labelColor: Colors.green,
                onTap: (index) {
                  if (index >= 0 && index < _tabController.length) {
                    _tabController.animateTo(index);
                  }
                },
                tabs: [
                  Tab(
                      icon: Icon(Icons.sentiment_dissatisfied),
                      text: 'Depressions'),
                  Tab(icon: Icon(Icons.event_seat), text: 'Desk'),
                  Tab(icon: Icon(Icons.headphones), text: 'Headache'),
                  Tab(icon: Icon(Icons.directions_walk), text: 'Knee Pain'),
                  Tab(
                      icon: Icon(Icons.fastfood),
                      text: 'Obesity'), // Ensure corresponding widget exists
                  Tab(icon: Icon(Icons.elderly), text: 'Osteoporosis'),
                  Tab(icon: Icon(Icons.speed), text: 'Pressure'),
                  Tab(icon: Icon(Icons.self_improvement), text: 'Stress'),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: TabBarView(
              controller: _tabController,
              children: [
                const PatientsPage_Depressions(),
                const Patientdesk(),
                const Patentheadache(),
                const Patentkneepain(),
                const Patentobesity(), // Ensure the widget exists
                const Patentosteoporosis(),
                const Patentpressure(),
                const Patentstress(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

// Example individual patient page widget

