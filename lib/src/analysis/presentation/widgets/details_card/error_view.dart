import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';

class ErrorView extends StatelessWidget {
  final String errorMessage;
  const ErrorView({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${context.translate.error}: $errorMessage'),
          ElevatedButton(
            onPressed: () =>
                context.read<AnalysisListCubit>().loadAnalyses(refresh: true),
            child: Text(context.translate.retry),
          ),
        ],
      ),
    );
  }
}
