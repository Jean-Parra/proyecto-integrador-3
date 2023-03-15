import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyecto_integrador_3/login_form.dart';
import 'package:proyecto_integrador_3/user.dart';
import 'package:proyecto_integrador_3/usuarios/historial.dart';

import 'administradores/listaconductor.dart';
import 'administradores/listausuario.dart';
import 'controllers/userController.dart';
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
          Get.to(() => ListConductoresScreen());
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
          final UserController userController = Get.find<UserController>();
          userController.setCurrentUser(
              userController.loggedInUserId); // actualiza el usuario actual
          try {
            final UserActual userActual = UserActual();
            final User user =
                await userActual.getUsuarioActual(userController.currentUserId);
            print(user); // Imprime el usuario actual en la consola
            Get.to(
                () => PerfilUsuarioPage(userId: userController.currentUserId));
          } catch (e) {
            print('Error al cargar el usuario actual: $e');
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
        onTap: () {},
      ),
    ],
  ),
];
