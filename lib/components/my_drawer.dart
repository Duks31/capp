import "package:capp/auth/auth_service.dart";
import "package:flutter/material.dart";
import "package:capp/pages/settings.dart";

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    //auth service
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
                      //logo
          DrawerHeader(
            child: Center(child: Icon(Icons.message, size: 40, color: Theme.of(context).colorScheme.primary,)),
          ),

          // home list
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              title: Text("HOME"),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.pop(context); // pop the sidebar
              },
            ),
          ),

          // setting list tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              title: Text("SETTINGS"),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(),),);
              },
            ),
          ),
          ],),

          //logout
            Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: ListTile(
              title: Text("LOG OUT"),
              leading: Icon(Icons.logout),
              onTap: logout,
            ),
          )
        ],
      ),
    );
  }
}
