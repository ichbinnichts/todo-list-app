import 'package:flutter/material.dart';
import 'package:todo_list_app/components/app_bar_component.dart';
import 'package:todo_list_app/components/form_text_field_component.dart';
import 'package:todo_list_app/components/main_button_component.dart';
import 'package:todo_list_app/controllers/access_controller.dart';
import 'package:todo_list_app/views/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _login(GlobalKey<FormState> _formKey) async {
    final NavigatorState navigator = Navigator.of(context);
    if (_formKey.currentState!.validate()) {
      bool logged = await AccessController.instance.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (logged) {
        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'ToDo App', leading: false),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1),
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ToDo App',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 18),
                    FormTextField(
                      labelText: 'Usuário',
                      hintText: 'Usuário de acesso',
                      textController: _usernameController,
                      textInputAction: TextInputAction.next,
                      inputValidator: (username) {
                        if (username == null || username.isEmpty) {
                          return 'Preencha o campo usuário';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    FormTextField(
                      labelText: 'Senha',
                      hintText: 'Senha do Usuário',
                      textController: _passwordController,
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      inputValidator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'Preencha o campo senha';
                        }

                        return null;
                      },
                      onFieldSubmitted: (_) async {
                        await _login(_formKey);
                      },
                    ),
                    const SizedBox(height: 18),
                    mainButton(
                      buttonText: 'Entrar',
                      horizontalPadding: 40,
                      verticalPadding: 15,
                      buttonFunction: () async {
                        await _login(_formKey);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
