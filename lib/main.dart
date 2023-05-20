import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/views/auth/login_view.dart';
import 'package:myproject/views/auth/register_view.dart';
import 'package:myproject/views/pages/donation_page.dart';
import 'package:myproject/views/auth/verify_email_view.dart';
import 'package:myproject/services/auth/bloc/auth_bloc.dart';
import 'package:myproject/services/auth/bloc/auth_event.dart';
import 'package:myproject/services/auth/bloc/auth_state.dart';
import 'package:myproject/helpers/loading/loading_screen.dart';
import 'package:myproject/views/auth/forgot_password_page.dart';
import 'package:myproject/views/shelters/add_shelter_view.dart';
import 'package:myproject/views/shelters/choose_action_view.dart';
import 'package:myproject/views/notes/create_update_note_view.dart';
import 'package:myproject/services/auth/firebase_auth_provider.dart';
import 'package:myproject/views/shelters/features/donations/item_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ItemModel>(
          create: (context) => ItemModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
        addShelterRoute:(context) => const AddShelterView(),
        makeDonationRoute:(context) => const DonationPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

@override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Loading...');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          // return const MapPage();
          return const ChooseActionView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            )
          );
        }
      }
    );
  }
}