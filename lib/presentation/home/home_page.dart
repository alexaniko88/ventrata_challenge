import 'package:flutter/material.dart';
import 'package:ventrata_challenge/domain/login/entities/login_model.dart';
import 'package:ventrata_challenge/presentation/home/products_view.dart';
import 'package:ventrata_challenge/presentation/home/profile_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.token,
  });

  final String token;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        //TODO do on tapped
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _selectedIndex == 0 ? const ProductsView() : ProfileView(token: widget.token),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            activeIcon: Icon(Icons.home),
            tooltip: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Statistics',
            activeIcon: Icon(Icons.person),
            tooltip: 'Statistics',
          ),
        ],
      ),
    );
  }
}
