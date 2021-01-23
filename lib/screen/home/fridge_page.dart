import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/authentication/authentication_state.dart';

/// Page to list items in the user's fridge.
class FridgePage extends StatelessWidget {
  /// Page to list items in the user's fridge.
  const FridgePage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        User user;

        if (state is UserAuthenticated) {
          print(state.user);
          user = state.user;
        } else {
          throw Error();
        }

        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection(user.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                  children: snapshot.data.docs
                      .map<Widget>((x) => Text(x.get('text').toString()))
                      .toList());
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}
