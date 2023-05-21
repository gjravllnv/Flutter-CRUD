import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateUserScreen extends StatefulWidget {
  final int userId;
  final String userName;
  final String userEmail;

  const UpdateUserScreen({
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final response = await http.get(
      Uri.parse(
        'http://zz.ncf.edu.ph/public/api/show_user?id=${widget.userId}',
      ),
    );
    final json = jsonDecode(response.body);
    setState(() {
      _nameController.text = json['name'];
      _emailController.text = json['email'];
      _passwordController.text = json['password'];
    });
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.put(
        Uri.parse('http://zz.ncf.edu.ph/public/api/update?id=${widget.userId}'),
        body: {
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      final data = jsonDecode(response.body);
      if (data['success']) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${widget.userName}'),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  // labelText: 'Name:',
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
                cursorColor: Colors.black,
              ),
              const SizedBox(height: 25),
              Text('Email: ${widget.userEmail}'),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  // labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Colors.grey),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
                cursorColor: Colors.black,
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Colors.grey),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  _updateUser();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You successfully updated your account!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 32, 138, 36),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
