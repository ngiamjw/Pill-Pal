import 'package:flutter/material.dart';
import 'package:testing_pill_pal/pages/home_page.dart';
import 'package:testing_pill_pal/pages/new_profile.dart';
import 'package:testing_pill_pal/pages/profile.dart';
import 'package:testing_pill_pal/pages/settings.dart';

class SliderPage extends StatefulWidget {
  int currentIndex;
  SliderPage({super.key, required this.currentIndex});

  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  // Create a PageController to control the PageView
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentIndex);
  }

  // List of pages to navigate
  final List<Widget> _pages = [
    SettingsPage(),
    HomePage(),
    // ProfilePage(),
    MedicationPage()
  ];

  @override
  void dispose() {
    // Dispose of the PageController when the widget is disposed
    _pageController.dispose();
    super.dispose();
  }

  // Called when the user swipes between pages
  void _onPageChanged(int index) {
    setState(() {
      widget.currentIndex = index;
    });
  }

  // Called when a bottom navigation item is tapped
  void _onItemTapped(int selectedIndex) {
    // Animate to the corresponding page
    _pageController.animateToPage(
      selectedIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The PageView allows swiping between pages
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: _onPageChanged,
      ),
      // The BottomNavigationBar lets you tap to change pages
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_outlined,
              color: widget.currentIndex == 0
                  ? Colors.blue
                  : Theme.of(context).colorScheme.secondary,
              size: 30,
            ),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: widget.currentIndex == 1
                  ? Colors.blue
                  : Theme.of(context).colorScheme.secondary,
              size: 30,
            ), // Highlight home
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: widget.currentIndex == 2
                  ? Colors.blue
                  : Theme.of(context).colorScheme.secondary,
              size: 30,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
