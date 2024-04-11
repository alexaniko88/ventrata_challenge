import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ventrata_challenge/domain/login/cubits/login_cubit.dart';
import 'package:ventrata_challenge/domain/login/cubits/login_state.dart';
import 'package:ventrata_challenge/shared/navigation/navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _usernameController, _passwordController;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _usernameController = TextEditingController(text: 'atuny0');
    _passwordController = TextEditingController(text: '9uQFF1Lh');
    context.read<LoginCubit>().tryAutoLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return Stack(
            children: [
              Visibility(
                visible: state.status == LoginStatus.loading,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              Opacity(
                opacity: state.status == LoginStatus.loading ? 0.5 : 1.0,
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery
                            .of(context)
                            .size
                            .width * 0.2,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          BlocConsumer<LoginCubit, LoginState>(
                            listener: (context, state) {
                              switch (state.status) {
                                case LoginStatus.success:
                                  context.goNamed(RoutePath.home.value);
                                  break;
                                case LoginStatus.failure:
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Login failed: ${state.exception}'),
                                    ),
                                  );
                                  break;
                                default:
                                  break;
                              }
                            },
                            builder: (context, state) {
                              final isDisable = switch (state.status) {
                                LoginStatus.failure || LoginStatus.loading => true,
                                _ => false,
                              };
                              return IgnorePointer(
                                ignoring: isDisable,
                                child: Opacity(
                                  opacity: isDisable ? 0.5 : 1.0,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 30.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState?.validate() ?? false) {
                                            context.read<LoginCubit>().login(
                                              username: _usernameController.text,
                                              password: _passwordController.text,
                                            );
                                          }
                                        },
                                        child: const Text('Login'),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
