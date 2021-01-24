import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/authentication/authentication_bloc.dart';
import 'bloc/authentication/authentication_event.dart';
import 'bloc/authentication/authentication_state.dart';
import 'bloc/bubble/bubble_bloc.dart';
import 'bloc/bubble/bubble_event.dart';
import 'bloc/feed/feed_bloc.dart';
import 'bloc/feed/feed_event.dart';
import 'bloc/foodlist/foodlist_bloc.dart';
import 'bloc/foodlist/foodlist_event.dart';
import 'repository/database/database_repository.dart';
import 'repository/database/firebase_database_repository.dart';
import 'screen/firebase_error_screen.dart';
import 'screen/home/home_screen.dart';
import 'screen/loading/loading_screen.dart';
import 'screen/login/login_screen.dart';
import 'service/bubble_join_service.dart';
import 'service/google_login_service.dart';
import 'service/offer_service.dart';
import 'service/qr_service.dart';
import 'theme/theme.dart';

/// Main app widget.
class FridgeSpaceApp extends StatelessWidget {
  /// Main app widget.
  FridgeSpaceApp();

  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fridge Space',
      theme: themeData,
      home: FutureBuilder(
        // Initialize firebase
        future: _firebaseApp,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return const FirebaseErrorScreen();
          }

          // Loading complete
          if (snapshot.connectionState == ConnectionState.done) {
            return const _PreAuthComponent();
          }

          // Future hasn't completed
          return const LoadingScreen();
        },
      ),
    );
  }
}

/// Main app view.
class _PreAuthComponent extends StatefulWidget {
  /// Const constructor.
  const _PreAuthComponent();

  @override
  _PreAuthComponentState createState() => _PreAuthComponentState();
}

class _PreAuthComponentState extends State<_PreAuthComponent> {
  AuthenticationBloc _authenticationBloc;

  GoogleLoginService _googleLoginService;
  QrService _qrService;

  @override
  void initState() {
    super.initState();

    _authenticationBloc = AuthenticationBloc()
      ..add(const AuthenticationAppStarted());

    _googleLoginService = GoogleLoginService();
    _qrService = QrService();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GoogleLoginService>.value(
          value: _googleLoginService,
        ),
        RepositoryProvider<QrService>.value(
          value: _qrService,
        ),
      ],
      child: BlocProvider<AuthenticationBloc>.value(
        value: _authenticationBloc,
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state is UserAuthenticated) {
            return _AppView(user: state.user);
          } else {
            return const LoginScreen();
          }
        }),
      ),
    );
  }
}

class _AppView extends StatefulWidget {
  final User user;

  const _AppView({@required this.user});

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  DatabaseRepository _databaseRepository;

  BubbleJoinService _bubbleJoinService;
  OfferService _offerService;

  FoodlistBloc _foodlistBloc;
  BubbleBloc _bubbleBloc;
  FeedBloc _feedBloc;

  @override
  void initState() {
    super.initState();

    _databaseRepository = FirebaseDatabaseRepository(user: widget.user);

    _bubbleJoinService =
        BubbleJoinService(databaseRepository: _databaseRepository);
    _offerService = OfferService(databaseRepository: _databaseRepository);

    _foodlistBloc = FoodlistBloc(databaseRepository: _databaseRepository)
      ..add(const LoadFoodlist());
    _bubbleBloc = BubbleBloc(databaseRepository: _databaseRepository)
      ..add(const LoadBubbles());
    _feedBloc = FeedBloc(offerService: _offerService)..add(const LoadFeed());
  }

  @override
  Widget build(BuildContext context) {
    /// Provide the logged in food list.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DatabaseRepository>.value(
          value: _databaseRepository,
        ),
        RepositoryProvider<BubbleJoinService>.value(
          value: _bubbleJoinService,
        ),
        RepositoryProvider<OfferService>.value(
          value: _offerService,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<FoodlistBloc>.value(
            value: _foodlistBloc,
          ),
          BlocProvider<BubbleBloc>.value(
            value: _bubbleBloc,
          ),
          BlocProvider<FeedBloc>.value(
            value: _feedBloc,
          ),
        ],
        child: Navigator(
          pages: [
            const MaterialPage<void>(child: HomeScreen()),
          ],
          onPopPage: (route, dynamic result) => route.didPop(result),
        ),
      ),
    );
  }
}
