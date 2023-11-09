import 'package:flutter/material.dart';
import 'package:hgeology_app/pages/account/login_page.dart';
import 'package:hgeology_app/provider/auth_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/provider/data_provider.dart';
import 'package:hgeology_app/gen/strings.g.dart';

class ForgetPasswordPage extends ConsumerStatefulWidget {
  final VoidCallback onLoginSuccess;

  const ForgetPasswordPage({required this.onLoginSuccess, super.key});

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends ConsumerState<ForgetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    final authManager = AuthProvider();

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await authManager.signup(
            _emailController.text, _passwordController.text);
        widget.onLoginSuccess();
      } catch (e) {
        // print("Signin Error $e");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${t.signupPage.errorPrefix}$e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.signupPage.title)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  icon: const Icon(Icons.mail),
                  labelText: t.general.email,
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return t.loginPage.emailValid;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  labelText: t.general.password,
                ),
                obscureText: true,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return t.loginPage.passwordValid;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  labelText: t.signupPage.passwordConfirm,
                ),
                obscureText: true,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return t.signupPage.passwordConfirmValid;
                  }
                  if (value != _passwordController.text) {
                    return t.signupPage.notMatch;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(
                        onLoginSuccess: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                      ),
                    ),
                  );
                },
                child: Text(t.signupPage.haveAccount),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_isLoading) {
            _signup();
          }
        },
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ))
            : const Icon(Icons.arrow_forward),
      ),
    );
  }
}
