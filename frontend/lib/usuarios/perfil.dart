import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/userController.dart';

class Perfil extends StatelessWidget {
  const Perfil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: GetBuilder<PerfilController>(
        init: PerfilController(),
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nombre: ${controller.user?.name ?? ""}'),
                Text('Correo electrónico: ${controller.user?.email ?? ""}'),
                Text('Rol: ${controller.user?.role ?? ""}'),
              ],
            );
          }
        },
      ),
    );
  }
}

class PerfilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PerfilController>(() => PerfilController());
  }
}
