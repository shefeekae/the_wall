import 'package:flutter/material.dart';
import 'package:the_wall/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer(
      {super.key, required this.onProfileTap, required this.onSignOutTap});

  final void Function()? onProfileTap;
  final void Function()? onSignOutTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //header
              const DrawerHeader(
                  child: Icon(
                Icons.person,
                size: 65,
                color: Colors.white,
              )),
              //home list tile
              MyListTile(
                icon: Icons.home,
                text: "H O M E",
                onTap: () => Navigator.pop(context),
              ),
              //profile list tile
              MyListTile(
                icon: Icons.person,
                text: "P R O F I L E",
                onTap: onProfileTap,
              ),
            ],
          ),
          //log out list tile
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: MyListTile(
              icon: Icons.logout,
              text: "L O G O U T",
              onTap: onSignOutTap,
            ),
          ),
        ],
      ),
    );
  }
}
