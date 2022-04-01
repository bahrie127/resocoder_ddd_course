import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:dartz/dartz.dart';
import 'package:resocoder_ddd_course/domain/notes/i_note_repository.dart';
import 'package:resocoder_ddd_course/domain/notes/note_failure.dart';
import 'package:resocoder_ddd_course/domain/notes/note.dart';
import 'package:resocoder_ddd_course/infrastructure/core/firestore_helpers.dart';
import 'package:resocoder_ddd_course/infrastructure/notes/note_dtos.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  final FirebaseFirestore _firestore;

  NoteRepository(this._firestore);

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);
      userDoc.noteCollection.doc(noteDto.id).set(noteDto.toJson());
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message?.contains('permission-denied') ?? false) {
        return left(const NoteFailure.insufficientPermissions());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteId = note.id.getOrCrash();
      userDoc.noteCollection.doc(noteId).delete();
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message?.contains('permission-denied') ?? false) {
        return left(const NoteFailure.insufficientPermissions());
      } else if (e.message?.contains('not-found') ?? false) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);
      userDoc.noteCollection.doc(noteDto.id).update(noteDto.toJson());
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message?.contains('permission-denied') ?? false) {
        return left(const NoteFailure.insufficientPermissions());
      } else if (e.message?.contains('not-found') ?? false) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection<Map<String, dynamic>>.orderBy(
            'serverTimeStamp',
            descending: true)
        .snapshots()
        .map(
          (snapshot) => right(snapshot.docs
              .map((doc) => NoteDto.fromFirestore(doc).toDomain())
              .toImmutableList()),
        )
        .onErrorReturnWith((e) {
      if (e is PlatformException &&
          (e.message?.contains('permission-denied') ?? false)) {
        return left(const NoteFailure.insufficientPermissions());
      } else {
        return left(const NoteFailure.unexpected());
      }
    });
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchIncompeted() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection<Map<String, dynamic>>.orderBy(
            'serverTimeStamp',
            descending: true)
        .snapshots()
        .map((snapshot) => right(
            snapshot.docs.map((doc) => NoteDto.fromFirestore(doc).toDomain())))
        .map((notes) => right<NoteFailure, KtList<Note>>(notes
            .where((Note note) =>
                note.todos.getOrCrash().any((todoItem) => !todoItem.done))
            .toImmutableList()))
        .onErrorReturnWith((e) {
      if (e is PlatformException &&
          (e.message?.contains('permission-denied') ?? false)) {
        return left(const NoteFailure.insufficientPermissions());
      } else {
        return left(const NoteFailure.unexpected());
      }
    });
  }
}
