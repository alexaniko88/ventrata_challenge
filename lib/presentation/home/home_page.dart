import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventrata_challenge/domain/products/cubits/product_cubit.dart';
import 'package:ventrata_challenge/domain/profile/cubits/profile_cubit.dart';
import 'package:ventrata_challenge/presentation/home/products_view.dart';
import 'package:ventrata_challenge/presentation/home/profile_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        context.read<ProductCubit>().fetchProducts();
        context.read<ProfileCubit>().stopFetching();
      }
      if (_selectedIndex == 1) {
        context.read<ProfileCubit>().fetchUser();
        context.read<ProductCubit>().stopFetching();
      }
    });
  }

  @override
  void initState() {
    context.read<ProductCubit>().fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _selectedIndex == 0 ? const ProductsView() : const ProfileView(),
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
            label: 'Products',
            activeIcon: Icon(Icons.home),
            tooltip: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
            activeIcon: Icon(Icons.person),
            tooltip: 'Profile',
          ),
        ],
      ),
    );
  }
}
