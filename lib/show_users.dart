// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:csfe3_p6_crud/update.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'create_user.dart';
import 'dashboard.dart';
import 'login.dart';

void main() => runApp(ShowUsers());

class ShowUsers extends StatelessWidget {
  late final Map<String, dynamic> _userData;

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color.fromARGB(255, 1, 17, 27)),
      // title: 'User List',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Friend List',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
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
                        builder: (context) => DashboardPage(_userData['name'])),
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
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 0, 0, 0),
            // border: Border.all(
            //   color: Colors.grey,
            //   width: 1,
            // ),
            // borderRadius: BorderRadius.circular(8),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5),
            //     spreadRadius: 2,
            //     blurRadius: 5,
            //     offset: Offset(0, 3),
            //   ),
            // ],
          ),
          padding: EdgeInsets.all(16),
          child: UserList(),
        ),
      ),
    );
  }
}

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<dynamic> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    final int userId;
  }

  Future<void> _fetchUsers() async {
    final response =
        await http.get(Uri.parse('http://zz.ncf.edu.ph/public/api/show_users'));
    final json = jsonDecode(response.body);
    setState(() {
      _users = json;
    });
  }

  Future<void> _editUser(int userId, String userName, String userEmail) async {
    await showDialog(
      context: context,
      builder: (context) => UpdateUserScreen(
          userId: userId, userName: userName, userEmail: userEmail),
    );
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (BuildContext context, int index) {
              final user = _users[index];
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      var styleFrom = ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 230, 188, 1),
                        onPrimary: Colors.white,
                      );
                      return AlertDialog(
                        title: Text(user['name'],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${user['id']}'),
                            const SizedBox(height: 5),
                            Text('Email: ${user['email']}'),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await _editUser(
                                  user['id'], user['name'], user['email']);
                            },
                            style: styleFrom,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(CupertinoIcons.pen),
                                SizedBox(
                                  width: 5,
                                  height: 30,
                                ),
                                Text('Update'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm'),
                                  content: const Text(
                                      'Do you want to delete your account?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm ?? false) {
                                final response = await http.delete(Uri.parse(
                                    'http://zz.ncf.edu.ph/public/api/delete?id=${user['id']}'));
                                if (response.statusCode == 200) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                          'Account deleted successfully.'),
                                      action: SnackBarAction(
                                        label: 'OK',
                                        onPressed: () {},
                                      ),
                                    ),
                                  );
                                  _fetchUsers();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                          'An error occurred while deleting the user.'),
                                      action: SnackBarAction(
                                        label: 'OK',
                                        onPressed: () {},
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 255, 17,
                                  0), // change the background color
                              onPrimary: Colors.white, // change the text color
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(CupertinoIcons.delete),
                                SizedBox(
                                  width: 5,
                                  height: 30,
                                ),
                                Text('Delete'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 52, 117, 236),
                              onPrimary: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.cancel),
                                SizedBox(
                                  width: 5,
                                  height: 30,
                                ),
                                Text('Cancel'),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 245, 241, 241),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  padding: const EdgeInsets.only(top: 10, left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 0.0, top: 0.0, bottom: 10.0),
                            width: 50,
                            child: const CircleAvatar(
                              backgroundImage: AssetImage('assets/profile.png'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                user['name'],
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
