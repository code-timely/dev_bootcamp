import 'package:dev_bootcamp/screens/imagepage.dart';
import 'package:dev_bootcamp/screens/riddlespage.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ImagePage(),
    const RiddlesPage()
    // FunnyScreen(),
    // ListScreen(),
    // LiveScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Image',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.show_chart),
          //   label: 'Live',
          // ),
        ],
      ),
    );
  }
}
