import 'package:dbtc/blocs/auth/auth.dart';
import 'package:dbtc/blocs/signup/signup.dart';
import 'package:dbtc/localizations/app_localizations.dart';
import 'package:dbtc/repository/user_repository.dart';
import 'package:dbtc/widgets/full_width_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserRepository _userRepository = RepositoryProvider.of<UserRepository>(context);
    
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).translate('SIGNUP'))),
      body: Center(
        child: BlocProvider<SignupBloc>(
          builder: (context) => SignupBloc(userRepository: _userRepository),
          child: SignupForm(),
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignupBloc _registerBloc;

  bool get isPopulated =>
      _firstNameController.text.isNotEmpty
          && _lastNameController.text.isNotEmpty
          && _emailController.text.isNotEmpty
          && _passwordController.text.isNotEmpty;

  bool isSignupButtonEnabled(SignupState state) {
    return state.isFormValid && isPopulated;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<SignupBloc>(context);
    _firstNameController.addListener(_onFirstNameChanged);
    _lastNameController.addListener(_onLastNameChanged);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _registerBloc,
      listener: (BuildContext context, SignupState state) {
        if (state.isSuccess) {
          BlocProvider.of<AuthBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Signup Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder(
        bloc: _registerBloc,
        builder: (BuildContext context, SignupState state) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context).translate('FIRST_NAME')
                    ),
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) => !state.isFirstNameValid ? 'Invalid first name' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context).translate('LAST_NAME')
                    ),
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) => !state.isLastNameValid ? 'Invalid last name' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context).translate('EMAIL'),
                    ),
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) => !state.isEmailValid ? 'Invalid Email' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context).translate('PASSWORD'),
                    ),
                    obscureText: true,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) => !state.isPasswordValid ? 'Invalid Password' : null,
                  ),
                  SizedBox(height: 16),
                  FullWidthRaisedButton(
                    text: AppLocalizations.of(context).translate('SIGNUP'),
                    onPressed: isSignupButtonEnabled(state)
                          ? _onFormSubmitted
                          : null,
                    isLoading: state.isSubmitting,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFirstNameChanged() {
    _registerBloc.add(
      FirstNameChanged(firstName: _firstNameController.text),
    );
  }

  void _onLastNameChanged() {
    _registerBloc.add(
      LastNameChanged(lastName: _lastNameController.text),
    );
  }

  void _onEmailChanged() {
    _registerBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      Submitted(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}