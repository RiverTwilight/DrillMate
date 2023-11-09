import 'package:flutter/material.dart';
import 'package:hgeology_app/pages/account/signup_page.dart';
import 'package:hgeology_app/provider/auth_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/provider/data_provider.dart';
import 'package:hgeology_app/utils/contact.dart';
import 'package:hgeology_app/widget/custom_constrained_box.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({required this.onLoginSuccess, super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final authManager = AuthProvider();

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await authManager.login(
            _emailController.text, _passwordController.text);

        DataProvider().loadData();

        widget.onLoginSuccess();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${t.loginPage.errorPrefix}$e")));
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    final authManager = AuthProvider();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth.accessToken,
      //   idToken: googleAuth.idToken,
      // );

      // await authManager.loginWithGoogle(credential);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to login with Google: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.loginPage.title),
        leading: const LeadingBackButton(),
      ),
      body: CustomConstrainedBox(
        child: Form(
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
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupPage(
                          onLoginSuccess: () {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          },
                        ),
                      ),
                    );
                  },
                  child: Text(t.loginPage.noAccount),
                ),
                TextButton(
                  onPressed: () {
                    support(context);
                  },
                  child: Text(t.loginPage.forget),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_isLoading) {
            _login();
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
