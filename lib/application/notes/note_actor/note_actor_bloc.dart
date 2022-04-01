import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:resocoder_ddd_course/domain/notes/i_note_repository.dart';
import 'package:resocoder_ddd_course/domain/notes/note.dart';
import 'package:resocoder_ddd_course/domain/notes/note_failure.dart';

part 'note_actor_event.dart';
part 'note_actor_state.dart';
part 'note_actor_bloc.freezed.dart';

@injectable
class NoteActorBloc extends Bloc<NoteActorEvent, NoteActorState> {
  final INoteRepository _noteRepository;

  NoteActorBloc(this._noteRepository) : super(const _Initial()) {
    on<NoteActorEvent>((event, emit) async {
      emit(const NoteActorState.actionInProgresss());
      final possibleFailure = await _noteRepository.delete(event.note);
      emit(
        possibleFailure.fold(
          (f) => NoteActorState.deleteFailure(f),
          (r) => const NoteActorState.deleteSuccess(),
        ),
      );
    });
  }
}