
import 'package:flutter/material.dart';

class RestorableTabPage extends StatefulWidget {
  const RestorableTabPage({Key? key}) : super(key: key);

  @override
  State<RestorableTabPage> createState() => _RestorableTabPageState();
}

class _RestorableTabPageState extends State<RestorableTabPage> with RestorationMixin, TickerProviderStateMixin {
  final RestorableInt _currentTabIndex = RestorableInt(0);
  late TabController _tabController;

  @override
  String? get restorationId => 'restorable_tab_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_currentTabIndex, 'tab_index');

    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _currentTabIndex.value,
    );

    _tabController.addListener(() {
      _currentTabIndex.value = _tabController.index;
    });
  }

  @override
  void dispose() {
    _currentTabIndex.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restorable Tab Example'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tab 1'),
            Tab(text: 'Tab 2'),
            Tab(text: 'Tab 3'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: Text('Page 1')),
          Center(child: Text('Page 2')),
          Center(child: Text('Page 3')),
        ],
      ),
    );
  }
}
