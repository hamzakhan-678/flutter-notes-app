import 'package:flutter/foundation.dart';
import 'package:notes_application_mvvm/models/note_filter.dart';
import 'package:notes_application_mvvm/models/note_model.dart';
import 'package:notes_application_mvvm/services/note_service.dart';

class NoteViewModel extends ChangeNotifier {
  final NoteService _noteService = NoteService();

  List<NoteModel> _notes = [];
  List<NoteModel> get notes => _notes;

  List<NoteModel> _filtered = [];
  List<NoteModel> get filtered => _filtered;

  NoteFilter _selectedFilter = NoteFilter.all;
  NoteFilter get selectedFilter => _selectedFilter;

  int get getTotalNotesCount => _notes.length;
  int get pinnedNotesCount => _notes.where((n) => n.isPinned).length;

  bool isLoading = false;

  void applyFilter() {
    if (_selectedFilter == NoteFilter.all) {
      _filtered = _notes;
    } else if (_selectedFilter == NoteFilter.pinned) {
      _filtered = _notes.where((e) => e.isPinned).toList();
    }
  }

  void updateFilter(NoteFilter filter) {
    _selectedFilter = filter;
    applyFilter();
    notifyListeners();
  }

  Future<void> fetchNotes({bool showLocalSpinner = true}) async {
    if (showLocalSpinner == true) {
      isLoading = true;
      notifyListeners();
    }

    _notes = await _noteService.getNotes();
    applyFilter();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addNote(String title, String content) async {
    NoteModel note = NoteModel(
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );

    await _noteService.insertNote(note);
    await fetchNotes(showLocalSpinner: false);
  }

  Future<void> updateNote(NoteModel note) async {
    await _noteService.updateNote(note);
    await fetchNotes(showLocalSpinner: false);
  }

  Future<void> deleteNote(int id) async {
    await _noteService.deleteNote(id);
    await fetchNotes(showLocalSpinner: false);
  }

  void search(String query) {
    if (query.isEmpty) {
      _filtered = _notes;
    } else {
      _filtered = _notes
          .where(
            (e) =>
                e.title.toLowerCase().contains(query.toLowerCase()) ||
                e.content.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  Future<void> insertDummyData() async {
    if (_notes.isNotEmpty) return;

    final dummyNotes = [
      NoteModel(
        title: "Learn Flutter",
        content: "Understand Provider and MVVM",
        createdAt: DateTime.now(),
        isPinned: true,
      ),
      NoteModel(
        title: "Trading Plan Trading Plan Trading Plan",
        content:
            "Follow risk management strictly Follow risk management strictly Follow risk management strictly Follow risk management strictly",
        createdAt: DateTime.now(),
        isPinned: false,
      ),
      NoteModel(
        title: "Gym",
        content: "Workout at 7 PM",
        createdAt: DateTime.now(),
        isPinned: true,
      ),
      NoteModel(
        title: "Study",
        content: "Prepare for exam",
        createdAt: DateTime.now(),
        isPinned: false,
      ),
      NoteModel(
        title: "Learn Flutter",
        content: "Understand Provider and MVVM",
        createdAt: DateTime.now(),
        isPinned: true,
      ),
      NoteModel(
        title: "Trading Plan Trading Plan Trading Plan",
        content:
            "Follow risk management strictly Follow risk management strictly Follow risk management strictly Follow risk management strictly",
        createdAt: DateTime.now(),
        isPinned: false,
      ),
      NoteModel(
        title: "Gym",
        content: "Workout at 7 PM",
        createdAt: DateTime.now(),
        isPinned: true,
      ),
      NoteModel(
        title: "Study",
        content: "Prepare for exam",
        createdAt: DateTime.now(),
        isPinned: false,
      ),
    ];

    for (var note in dummyNotes) {
      await _noteService.insertNote(note);
    }

    await fetchNotes(showLocalSpinner: false);
  }
}
