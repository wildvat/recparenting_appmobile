import 'package:flutter/material.dart';

class DrawerMenuItem extends StatelessWidget {
  const DrawerMenuItem({required this.route, required this.title, super.key});

  final String route;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.home,
        color: Colors.white,
        size: 25,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}
