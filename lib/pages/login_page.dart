import 'package:app_web_v1/utilities/colors.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static get context => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 125),
            CircleAvatar(
              backgroundImage: const AssetImage('assets/images/logo/logo.png'),
              maxRadius: 55,
              minRadius: 50,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: _buildLoginForm(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildLoginForm() {
  return Column(
    children: [
      _buildTextField('Email', false),
      SizedBox(height: 20),
      _buildTextField('Password', true),
      SizedBox(height: 20),
      SizedBox(
        width: double.maxFinite,
        child: _buildLoginButton('Login', AppColor.brand500),
      ),
    ],
  );
}

Widget _buildTextField(String label, bool isPassword) {
  return TextFormField(
    obscureText: isPassword,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(color: AppColor.brand500),
      ),
    ),
  );
}

Widget _buildLoginButton(String label, Color color) {
  return ElevatedButton(
    onPressed: () {
      // Handle login action
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    ),
    child: Text(label, style: TextStyle(fontSize: 18)),
  );
}
