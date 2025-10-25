import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_list_cubit/analysis_list_cubit.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/add_dialog/analysis_add_dialog.dart';
import 'package:larvixon_frontend/src/common/extensions/translate_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/custom_card.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomCard(
        constraints: const BoxConstraints(maxWidth: 400),
        title: Text(
          context.translate.noAnalysesFound,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        child: ElevatedButton(
          onPressed: () => LarvaVideoAddForm.showUploadLarvaVideoDialog(
            context,
            context.read<AnalysisListCubit>(),
          ),
          child: Text(context.translate.clickToUpload),
        ),
      ),
    );
  }
}
