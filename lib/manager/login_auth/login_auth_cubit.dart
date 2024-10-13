import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_with_github_twitter_apple/core/models/user_model.dart';
import 'package:login_with_github_twitter_apple/core/utils/constants.dart';
import 'package:twitter_login/twitter_login.dart';

part 'login_auth_state.dart';

class LoginAuthCubit extends Cubit<LoginAuthState> {
  LoginAuthCubit() : super(LoginAuthInitial());

  UserModel? user;
  Future<void> loginWithTwitter() async {
    emit(LoginAuthLoading());
    try {
      final twitterLogin = TwitterLogin(
          apiKey: Constants.twitterApiKey,
          apiSecretKey: Constants.twitterSecretKey,
          redirectURI: 'socialauth://');

      final authResult = await twitterLogin.loginV2();
      if (authResult.status == TwitterLoginStatus.loggedIn) {
        final credentail = TwitterAuthProvider.credential(
            accessToken: authResult.authToken!,
            secret: authResult.authTokenSecret!);
        final data =
            await FirebaseAuth.instance.signInWithCredential(credentail);
        user = UserModel(
            name: data.user!.displayName,
            image: data.user!.photoURL,
            auth: 'Twitter');

        log('userName: ${data.user?.displayName}');
        log('userID: ${data.user?.uid}');
        log('userImage: ${data.user?.photoURL}');
        emit(LoginWithTwitter());
      }
    } catch (e) {
      emit(LoginAuthFailure(errorMessage: e.toString()));
      log('error from login in with twitter $e');
    }
  }

  @override
  void onChange(Change<LoginAuthState> change) {
    log('change $change');
    super.onChange(change);
  }
}

