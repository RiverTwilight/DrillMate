import 'package:flutter/material.dart';
import 'package:hgeology_app/provider.dart';
import 'package:hgeology_app/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/widget/custom_constrained_box.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:hgeology_app/widget/settings_section.dart';
import 'package:hgeology_app/gen/strings.g.dart';

class AccountSettingsPage extends ConsumerStatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends ConsumerState<AccountSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    setState(() {
      _isLoading = true;
    });

    final authManager = AuthProvider();

    if (_formKey.currentState!.validate()) {
      try {
        await authManager.updatePassword(
          _oldPasswordController.text,
          _passwordController.text,
        );

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Update successfully")));
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to reset: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDataManager = ref.read(userDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.accountDetailPage.title),
        leading: const LeadingBackButton(),
      ),
      body: CustomConstrainedBox(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SettingsSection(
                  title: t.accountDetailPage.info.title,
                  children: [
                    TextFormField(
                      enabled: false,
                      initialValue: userDataManager.userInfo['email'],
                      decoration: const InputDecoration(
                        icon: Icon(Icons.mail),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    )
                  ],
                ),
                SettingsSection(
                  title: t.general.password,
                  children: [
                    TextFormField(
                      controller: _oldPasswordController,
                      decoration: InputDecoration(
                        labelText: t.accountDetailPage.password.oldPwd,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
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
                        labelText: t.accountDetailPage.password.newPwd,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureText,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextButton.icon(
                      onPressed: _updatePassword,
                      icon: const Icon(Icons.check),
                      label: Text(t.general.confirm),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
