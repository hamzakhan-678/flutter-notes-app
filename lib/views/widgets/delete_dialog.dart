import 'package:flutter/material.dart';
import 'package:notes_application_mvvm/core/utils/my_colors.dart';
import 'package:notes_application_mvvm/models/note_model.dart';
import 'package:notes_application_mvvm/viewmodels/note_view_model.dart';
import 'package:provider/provider.dart';

void showDeleteDialog(
  BuildContext context,
  NoteModel note,
  VoidCallback popLogic,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: MyColors.primaryColor,
      title: const Text("Delete Note?", style: TextStyle(color: Colors.white)),
      content: const Text(
        "This action cannot be undone.",
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel", style: TextStyle(color: Colors.white38)),
        ),
        TextButton(
          onPressed: () {
            context.read<NoteViewModel>().deleteNote(note.id!);
            popLogic();
          },
          child: const Text(
            "Delete",
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    ),
  );
}
