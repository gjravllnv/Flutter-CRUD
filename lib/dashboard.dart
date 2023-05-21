import 'package:csfe3_p6_crud/show_users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'create_user.dart';
import 'login.dart';

class DashboardPage extends StatelessWidget {
  final Map<String, dynamic> _userData;

  DashboardPage(this._userData);

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text(""),
              accountEmail: Text(""),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/mainp.jpg"),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                CupertinoIcons.person_alt,
                size: 30.0,
              ),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DashboardPage(_userData)),
                );
              },
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: const Icon(
                CupertinoIcons.person_3_fill,
                size: 30.0,
              ),
              title: const Text('Friends'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShowUsers()),
                );
              },
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: const Icon(
                CupertinoIcons.person_add_solid,
                size: 30.0,
              ),
              title: const Text('Add Friend'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateUsers()),
                );
              },
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: const Icon(
                Icons.logout_outlined,
                size: 30.0,
              ),
              title: Text('Log out'),
              onTap: () {
                _logout(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 240, 232, 228),
          borderRadius: BorderRadius.all(Radius.circular(0.0)
          ),
        ),
          child: Column(children: [
            const SizedBox(
              height: 130,
            ),
            const CircleAvatar(
              backgroundImage: AssetImage("assets/mainp.jpg"),
              radius: 82,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                alignment: Alignment.center,
                child: Text(
                  'Welcome, ${_userData['name']}',
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),
                )),
            const SizedBox(
              height: 5,
            ),
          ]),
      ),
    );
  }
}
