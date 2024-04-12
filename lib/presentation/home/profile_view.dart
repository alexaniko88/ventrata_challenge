import 'package:basic_flutter_helper/basic_flutter_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventrata_challenge/domain/login/cubits/login_cubit.dart';
import 'package:ventrata_challenge/domain/profile/cubits/profile_cubit.dart';
import 'package:ventrata_challenge/domain/profile/cubits/profile_state.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          printLog("PROFILE STATUS IS: ${state.status}");
          if (state.status == ProfileStatus.unauthorized) {
            context.read<LoginCubit>().logout();
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case ProfileStatus.initial:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ProfileStatus.success:
              final model = state.userModel;
              if (model != null) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.2,
                    vertical: MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          model.image != null
                              ? Image.network(
                                  model.image!,
                                  width: 100,
                                  height: 100,
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Username:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                model.username,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Email:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                model.email,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'First Name:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                model.firstName,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Last Name:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                model.lastName,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Gender:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                model.gender,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<LoginCubit>().logout();
                          },
                          child: const Text('Logout'),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text('User not found'),
                );
              }
            case ProfileStatus.failure:
              return Center(
                child: Text('Failed to fetch user: ${state.exception}'),
              );
            case ProfileStatus.unauthorized:
              return const Center(
                child: Text('Unauthorized'),
              );
          }
        },
      ),
    );
  }
}
