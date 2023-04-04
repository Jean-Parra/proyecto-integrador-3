// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyecto_integrador_3/login_form.dart';
import 'package:proyecto_integrador_3/usuarios/historial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'administradores/historialviajes.dart';
import 'administradores/listaconductor.dart';
import 'administradores/listausuario.dart';
import 'conductores/historial.dart';
import 'usuarios/perfil.dart';

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
        onTap: () {
          Get.to(() => UserListScreen());
        },
      ),
      DrawerItem(
        icon: Icons.people,
        title: "Lista de conductores",
        onTap: () {
          Get.to(() => const ListConductoresScreen());
        },
      ),
      DrawerItem(
        icon: Icons.travel_explore,
        title: "Historial de viajes",
        onTap: () {
          Get.to(() => const HistorialAdministradorPage());
        },
      ),
      DrawerItem(
        icon: Icons.report,
        title: "Cerrar sesion",
        onTap: () {
          Get.to(() => const LoginPage());
        },
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
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? token = prefs.getString("token");
          if (token != null) {
            Get.to(() => const Perfil());
          } else {
            print('El usuario no ha iniciado sesión');
            // mostrar un mensaje de error o redirigir a la pantalla de inicio de sesión
          }
        },
      ),
      DrawerItem(
        icon: Icons.settings,
        title: "Historial",
        onTap: () {
          Get.to(() => const HistorialUsuarioPage());
        },
      ),
      DrawerItem(
        icon: Icons.report,
        title: "Cerrar sesion",
        onTap: () {
          Get.to(() => const LoginPage());
        },
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
        onTap: () {
          Get.to(() => HistorialConductorPage());
        },
      ),
      DrawerItem(
        icon: Icons.report,
        title: "Cerrar sesion",
        onTap: () {
          Get.to(() => const LoginPage());
        },
      ),
    ],
  ),
];
