import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    void onSignOut() {
      FirebaseAuth.instance.signOut();
    }

    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              padding: const EdgeInsets.all(20),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Menu',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}
