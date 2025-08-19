import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/user_bloc.dart';

class AccountPage extends StatefulWidget {
  static final String route = '/account';
  const AccountPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AccountPageState();
  }
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),

      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state.status == UserStatus.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.status == UserStatus.error) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else {
            return Column(
              children: [Text(state.user?.toString() ?? 'No user data')],
            );
          }
        },
      ),
    );
  }
}
