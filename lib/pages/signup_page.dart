import 'dart:developer';
import 'dart:ffi';

import 'package:app_web_v1/services/firebase_auth.dart';
import 'package:app_web_v1/services/firestore.dart';
import 'package:app_web_v1/utilities/colors.dart';
import 'package:app_web_v1/utilities/routes.dart';
import 'package:app_web_v1/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  String email = '';
  String password = '';
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  bool isLoading = false;

  bool _obscurePassword = true;

  Future<void> signupUser() async {
    if (!_formKey.currentState!.validate()) {
      showSnackBar(context, 'Please fill in all fields correctly');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String res = await AuthMethod().signupUser(
        email: email.trim(),
        password: password.trim(),
      );

      if (res == "success") {
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        Provider.of<Firestore>(context, listen: false).initListeners();
        showSnackBar(context, 'Account created successfully');
      } else {
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, 'An unexpected error occurred: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            _buildHeader(context, 'Sign Up'),
            const SizedBox(height: 120),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Create an account to get started',
                style: TextStyle(fontSize: 16),
              ),
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
                      Image.asset('assets/images/google_logo.png', height: 30),
                      const SizedBox(width: 5),
                      Text(
                        'Continue with Google',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    bool isPassword, {
    TextEditingController? controller,
    FocusNode? focusNode,
    bool isConfirmPassword = false,
  }) {
    return TextFormField(
      controller:
          controller ??
          (isPassword
              ? isConfirmPassword
                  ? null
                  : passController
              : emailController),
      focusNode:
          focusNode ??
          (isPassword
              ? (isConfirmPassword
                  ? confirmPasswordFocusNode
                  : passwordFocusNode)
              : emailFocusNode),
      keyboardType:
          isPassword
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
      textInputAction:
          isPassword
              ? (isConfirmPassword
                  ? TextInputAction.done
                  : TextInputAction.next)
              : TextInputAction.next,
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

          if (isConfirmPassword && value != passController.text) {
            return 'Passwords do not match';
          }
        }
        return null;
      },
      onFieldSubmitted: (value) {
        if (!isPassword) {
          FocusScope.of(context).requestFocus(passwordFocusNode);
        } else {
          if (_formKey.currentState?.validate() ?? false) {
            if (isConfirmPassword) {
              FocusScope.of(context).unfocus();
            } else {
              FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
            }
          } else {
            showSnackBar(context, 'Please fill in all fields');
          }
        }
      },
      onChanged: (value) {
        setState(() {
          if (!isConfirmPassword) {
            if (isPassword) {
              password = value;
            } else {
              email = value;
            }
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
            isPassword && !isConfirmPassword
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

  Widget _buildLoginForm() {
    return Column(
      children: [
        _buildTextField('Email', false),
        const SizedBox(height: 20),
        _buildTextField('Password', true),
        const SizedBox(height: 20),
        _buildTextField('Confirm Password', true, isConfirmPassword: true),
        const SizedBox(height: 20),
        _buildActionButton('Sign Up', AppColor.brand500, () {
          // Handle sign up logic here
          showSnackBar(context, 'Sign Up button pressed');
        }),
      ],
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
