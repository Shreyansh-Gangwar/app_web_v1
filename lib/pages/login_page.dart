import 'dart:developer';

import 'package:app_web_v1/pages/splash_screen.dart';
import 'package:app_web_v1/services/firebase_auth.dart';
import 'package:app_web_v1/services/firestore.dart';
import 'package:app_web_v1/utilities/colors.dart';
import 'package:app_web_v1/utilities/routes.dart';
import 'package:app_web_v1/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

String email = '';
String password = '';

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {});
    });
    passController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethod().loginUser(
      email: emailController.text,
      password: passController.text,
    );

    if (res == "success") {
      log('Email: $email, Password: $password, isLoading: $isLoading');
      if (mounted) {
        final firestoreProvider = Provider.of<Firestore>(
          context,
          listen: false,
        );
        await firestoreProvider.fetchUserData(); // Fetch user data after login
        firestoreProvider.initListeners(); // Initialize listeners
        setState(() {
          isLoading = false;
        });

        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    } else {
      setState(() {
        if (mounted) {
          showSnackBar(context, res);
        }
      });
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              _buildHeader(context, 'Login'),
              const SizedBox(height: 120),
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/logo/logo.png'),
                maxRadius: 55,
                minRadius: 50,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: Form(key: _formKey, child: _buildLoginForm()),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 15),
              _buildDivider(),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      // GOOGLE SIGN IN
                      isLoading = true;
                    });
                    await AuthMethod().signinwithGoogle(context);
                    Provider.of<Firestore>(
                      context,
                      listen: false,
                    ).initListeners();
                    setState(() {});
                    log('google sign in');
                    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google_logo.png',
                          height: 30,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Continue with Google',
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle forgot password action
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: AppColor.brand500),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 40),
        child: InkWell(
          onTap: () {
            setState(() {
              // REGISTERATION PAGE
            });
          },
          child: Container(
            height: 50,
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.brand500, width: 1),
            ),
            child: Text(
              'Create an account',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColor.brand500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // IconButton(
          //   icon: const Icon(Icons.arrow_back),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          // const SizedBox(width: 48), // Placeholder for alignment
        ],
      ),
    );
  }

  bool _obscurePassword = true; // Add this to your state class

  Widget _buildTextField(String label, bool isPassword) {
    return TextFormField(
      controller: isPassword ? passController : emailController,
      keyboardType:
          isPassword
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
      textInputAction: isPassword ? TextInputAction.done : TextInputAction.next,
      obscureText: isPassword ? _obscurePassword : false,
      readOnly: isLoading,
      enabled: !isLoading,
      textCapitalization: TextCapitalization.none,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label cannot be empty';
        }

        if (!isPassword) {
          final emailRegex = RegExp(
            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
          );
          if (!emailRegex.hasMatch(value.trim())) {
            return 'Please enter a valid email address';
          }
        } else {
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$');
          if (!passwordRegex.hasMatch(value)) {
            return 'Password must contain at least one letter and one number';
          }
        }

        return null;
      },
      onFieldSubmitted: (value) {
        if (isPassword) {
          if (_formKey.currentState?.validate() ?? false) {
            loginUser();
          }
        } else {
          FocusScope.of(context).nextFocus();
        }
      },
      onChanged: (value) {
        setState(() {
          if (isPassword) {
            password = value;
          } else {
            email = value;
          }
        });
      },

      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: AppColor.brand500),
        ),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
                : null,
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        _buildTextField('Email', false),
        const SizedBox(height: 20),
        _buildTextField('Password', true),
        const SizedBox(height: 20),
        isLoading
            ? const CircularProgressIndicator()
            : _buildActionButton('Login', AppColor.brand500, loginUser),
      ],
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            onPressed();
          } else {
            showSnackBar(context, 'Please fill in all fields');
          }
        },
        child: Text(label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "OR",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        ],
      ),
    );
  }
}
