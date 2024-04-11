import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ventrata_challenge/domain/profile/cubits/profile_state.dart';
import 'package:ventrata_challenge/domain/user/repositories/user_repository.dart';
import 'package:ventrata_challenge/shared/exceptions/app_exception.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.repository) : super(const ProfileState(status: ProfileStatus.initial));

  final UserRepository repository;
  Timer? _timer;

  Future<void> fetchUser() async {
    _fetchUserData(); // Call the logic immediately
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      _fetchUserData();
    });
  }

  Future<void> _fetchUserData() async {
    final tokenResult = await repository.getToken();
    tokenResult.fold(
      (token) async {
        final userResult = await repository.fetchUser(token: token);
        userResult.fold(
          (user) => emit(
            ProfileState(
              status: ProfileStatus.success,
              userModel: user,
            ),
          ),
          (exception) {
            if (exception.statusCode == StatusCode.unauthorized) {
              emit(const ProfileState(status: ProfileStatus.unauthorized));
            } else {
              emit(ProfileState(
                status: ProfileStatus.failure,
                exception: exception,
              ));
            }
          },
        );
      },
      (exception) => emit(
        ProfileState(
          status: ProfileStatus.failure,
          exception: exception,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
