import 'package:flutter/material.dart';

import 'profile.dart';
import 'user.dart';

class CustomDrawer extends StatelessWidget {
  final String profileName;
  final User user;

  const CustomDrawer(
      {super.key, required this.profileName, required this.user});

  @override
  Widget build(BuildContext context) {
    Profile? profile = profiles.firstWhere(
        (profile) => profile.name.toLowerCase() == profileName.toLowerCase());

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName:
                Text(user.name, style: const TextStyle(color: Colors.black)),
            accountEmail:
                Text(user.email, style: const TextStyle(color: Colors.black)),
            currentAccountPicture: const CircleAvatar(
                //backgroundImage: NetworkImage(""),
                ),
            decoration: const BoxDecoration(
                //image: DecorationImage(
                //image: NetworkImage(""),
                //fit: BoxFit.fill,
                //),
                ),
          ),
          ...profile.items
              .map((item) => ListTile(
                    leading: Icon(item.icon),
                    title: Text(item.title),
                    onTap: item.onTap,
                  ))
              .toList(),
        ],
      ),
    );
  }
}
