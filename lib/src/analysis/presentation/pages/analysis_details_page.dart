import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/core/constants/page.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_bloc/analysis_bloc.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';
import 'package:larvixon_frontend/src/analysis/presentation/pages/analyses_page.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details/all_results_section.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details/best_match_result_section.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details/header_section.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details/invalid_id_view.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details/loading_view.dart';
import 'package:larvixon_frontend/src/analysis/presentation/widgets/details/meta_section.dart';
import 'package:larvixon_frontend/src/common/extensions/navigation_extensions.dart';
import 'package:larvixon_frontend/src/common/extensions/on_hover_extension.dart';
import 'package:larvixon_frontend/src/common/widgets/ui/custom_card.dart';
import 'package:larvixon_frontend/src/common/widgets/utils/slide_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnalysisDetailsPage extends StatelessWidget {
  static const String route = ':analysisId';
  static const String name = 'analysis-details';

  const AnalysisDetailsPage({super.key, required this.analysisId});

  final int? analysisId;

  @override
  Widget build(BuildContext context) {
    if (analysisId == null) return const InvalidIdView();
    final id = analysisId!;

    return SingleChildScrollView(
      child: Center(
        child: SafeArea(
          child: BlocProvider(
            key: ValueKey("analysis-$id"),
            create: (context) =>
                AnalysisBloc(repository: context.read<AnalysisRepository>())
                  ..add(FetchAnalysisDetails(analysisId: id)),
            child: _AnalysisDetailsContent(analysisId: id),
          ),
        ),
      ),
    );
  }
}

class _AnalysisDetailsContent extends StatefulWidget {
  final int analysisId;
  const _AnalysisDetailsContent({required this.analysisId});

  @override
  State<_AnalysisDetailsContent> createState() =>
      _AnalysisDetailsContentState();
}

class _AnalysisDetailsContentState extends State<_AnalysisDetailsContent> {
  bool _isFirstBuild = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnalysisBloc, AnalysisState>(
      listenWhen: (previous, current) =>
          previous.status != AnalysisStatus.deleted &&
          current.status == AnalysisStatus.deleted,
      listener: (context, state) {
        if (state.status == AnalysisStatus.deleted) {
          context.popOrGo(AnalysesOverviewPage.route);
        }
      },
      builder: (context, state) {
        if (state.isLoading) return const LoadingView();

        final analysis = state.analysis!;
        final animationConfig = _buildAnimationConfig();

        return ConstrainedBox(
          constraints: kDefaultPageWidthConstraitns,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeaderSection(analysis: analysis),
              if (analysis.hasImage)
                ImageSection(imageUrl: analysis.thumbnailUrl!),

              MetaSection(analysis: analysis),

              if (analysis.hasResults)
                SlideUpTransition(
                  delay: animationConfig.resultsDelay,
                  duration: animationConfig.mainDuration,
                  child: BestMatchResultSection(results: analysis.results!),
                ),
              if (analysis.hasManyResults)
                SlideUpTransition(
                  delay: animationConfig.manyResultsDelay,
                  duration: animationConfig.allResultsDuration,
                  child: AllResultsSection(results: analysis.results!),
                ),
            ],
          ),
        );
      },
    );
  }

  _AnimationConfig _buildAnimationConfig() {
    final config = _isFirstBuild
        ? const _AnimationConfig.zero()
        : const _AnimationConfig.standard();
    _isFirstBuild = false;
    return config;
  }
}

class ImageSection extends StatefulWidget {
  const ImageSection({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection>
    with TickerProviderStateMixin {
  ImageProvider? _imageProvider;
  bool _loadedSuccessfully = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadImage(widget.imageUrl);
  }

  void _loadImage(String url) {
    final provider = NetworkImage(url);

    final stream = provider.resolve(const ImageConfiguration());
    final listener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        if (mounted) {
          setState(() {
            _imageProvider = provider;
            _loadedSuccessfully = true;
            _loading = false;
          });
        }
      },
      onError: (_, __) {
        if (mounted) setState(() => _loadedSuccessfully = false);
      },
    );

    stream.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(16),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: Skeletonizer(
          enabled: _loading,
          child: !_loadedSuccessfully
              ? const SizedBox.shrink()
              : CustomCard(
                  background: InkWell(
                    onTap: () => _loading ? null : _showFullImage(context),
                    child: _imageProvider == null
                        ? Container(
                            color: Colors.grey[200],
                            width: double.infinity,
                            height: 300,
                          )
                        : Image(
                            image: _imageProvider!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 300,
                          ).withOnHoverEffect,
                  ),
                ),
        ).withOnHoverEffect,
      ),
    );
  }

  void _showFullImage(BuildContext context) {
    if (_imageProvider == null) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Analysis Image",
      transitionDuration: const Duration(milliseconds: 250),
      useRootNavigator: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Center(
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                maxScale: 4.0,
                child: Image(image: _imageProvider!),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimationConfig {
  final Duration mainDuration;
  final Duration allResultsDuration;
  final Duration resultsDelay;
  final Duration manyResultsDelay;

  const _AnimationConfig({
    required this.mainDuration,
    required this.allResultsDuration,
    required this.resultsDelay,
    required this.manyResultsDelay,
  });

  const _AnimationConfig.zero()
    : mainDuration = Duration.zero,
      allResultsDuration = Duration.zero,
      resultsDelay = Duration.zero,
      manyResultsDelay = Duration.zero;

  const _AnimationConfig.standard()
    : mainDuration = const Duration(milliseconds: 400),
      allResultsDuration = const Duration(milliseconds: 400),
      resultsDelay = const Duration(milliseconds: 200),
      manyResultsDelay = const Duration(milliseconds: 400);
}

extension on AnalysisState {
  bool get isLoading => status == AnalysisStatus.initial || analysis == null;
}

extension on Analysis {
  bool get hasResults => results?.isNotEmpty ?? false;
  bool get hasManyResults => (results?.length ?? 0) > 1;
  bool get hasImage => thumbnailUrl != null;
}
