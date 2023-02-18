import 'package:flutter/material.dart';

class Profile {
  final String name;
  final List<DrawerItem> items;

  Profile({required this.name, required this.items});
}

class DrawerItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  DrawerItem({required this.icon, required this.title, required this.onTap});
}

final profiles = [
  Profile(
    name: "Administrador",
    items: [
      DrawerItem(
        icon: Icons.home,
        title: "Inicio",
        onTap: () {},
      ),
      DrawerItem(
        icon: Icons.settings,
        title: "Perfil",
        onTap: () {},
      ),
      DrawerItem(
        icon: Icons.people,
        title: "Lista de usuarios",
        onTap: () {},
      ),
      DrawerItem(
        icon: Icons.people,
        title: "Lista de conductores",
        onTap: () {},
      ),
    ],
  ),
  Profile(
    name: "Usuario",
    items: [
      DrawerItem(
        icon: Icons.home,
        title: "Inicio",
        onTap: () {},
      ),
      DrawerItem(
        icon: Icons.account_circle,
        title: "Perfil",
        onTap: () {},
      ),
      DrawerItem(
        icon: Icons.settings,
        title: "Historial",
        onTap: () {},
      ),
      DrawerItem(
        icon: Icons.report,
        title: "Reportes",
        onTap: () {},
      ),
    ],
  ),
  Profile(
    name: "Conductor",
    items: [
      DrawerItem(
        icon: Icons.home,
        title: "Inicio",
        onTap: () {},
      ),
      DrawerItem(
        icon: Icons.account_circle,
        title: "Perfil",
        onTap: () {},
      ),
      DrawerItem(
        icon: Icons.settings,
        title: "Historial",
        onTap: () {},
      ),
    ],
  ),
];
