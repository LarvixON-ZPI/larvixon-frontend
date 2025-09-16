import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:larvixon_frontend/src/analysis/domain/larva_video_repository.dart';

part 'larva_video_list_state.dart';

class LarvaVideoListCubit extends Cubit<LarvaVideoListState> {
  final LarvaVideoRepository _repository;
  int page = 0;
  bool hasMore = true;
  LarvaVideoListCubit(this._repository) : super(LarvaVideoListState());

  void fetchVideoList({bool more = false}) async {
    emit(state.copyWith(status: LarvaVideoListStatus.loading));
    try {
      final videos = await _repository.fetchVideoIds();
      print("Video matches state: ${state.videoIds == videos}");
      print("Fetched videos: $videos");
      emit(
        state.copyWith(status: LarvaVideoListStatus.success, videoIds: videos),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LarvaVideoListStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
