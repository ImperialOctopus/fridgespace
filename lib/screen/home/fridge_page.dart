import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodcoin/model/food_item.dart';
import 'package:foodcoin/repository/database/firebase_database_repository.dart';
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
        FirebaseDatabaseRepository db;

        if (state is UserAuthenticated) {
          print(state.user);
          db = FirebaseDatabaseRepository(user: state.user);
        } else {
          throw Error();
        }

        return FutureBuilder<Iterable<FoodItem>>(
          future: db.getFoodItems(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                  children: snapshot.data
                      .map<Widget>(
                        (x) => ListTile(
                          title: Text(x.name),
                        ),
                      )
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
