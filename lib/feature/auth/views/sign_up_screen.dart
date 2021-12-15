import 'package:case_study/core/route/route_delegate.dart';
import 'package:case_study/feature/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);
  final routerDelegate = MyRouterDelegate();
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBuilder(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'Email',
                decoration: InputDecoration(
                  labelText: 'Enter your email address.',
                ),
                controller: _emailController,
                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                  FormBuilderValidators.email(context),
                ]),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 20,
              ),
              FormBuilderTextField(
                obscureText: true,
                name: 'Password',
                decoration: InputDecoration(
                  labelText: 'Enter your password.',
                ),
                controller: _passwordController,
                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 20,
              ),
              BlocConsumer<AuthenticationBloc, AuthState>(
                  listener: (context, state) {
                if (state is AuthFailureState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error.toString())));
                }

                if (state is SignInState) {
                  routerDelegate.pushAndRemoveUntilPage(name: '/home');
                }
              }, builder: (context, state) {
                if (state is AuthLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate())
                        context.read<AuthenticationBloc>().register(
                            email: _emailController.text,
                            password: _passwordController.text);
                    },
                    child: Text("Sign Up"));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
