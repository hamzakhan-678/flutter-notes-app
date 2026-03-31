import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_application_mvvm/core/utils/my_colors.dart';
import 'package:notes_application_mvvm/models/note_model.dart';
import 'package:notes_application_mvvm/viewmodels/note_view_model.dart';
import 'package:notes_application_mvvm/views/widgets/delete_dialog.dart';
import 'package:provider/provider.dart';

class AddOrEditScreen extends StatefulWidget {
  const AddOrEditScreen({super.key, this.note});

  final NoteModel? note;

  @override
  State<AddOrEditScreen> createState() => _AddOrEditScreenState();
}

class _AddOrEditScreenState extends State<AddOrEditScreen> {
  var titleController = TextEditingController();
  var contentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    // IMPORTANT: Clean up memory
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            (widget.note == null) ? 'Add Note' : 'Edit Note',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        centerTitle: true,

        // Back Button
        leading: Padding(
          padding: const EdgeInsets.all(15.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        actions: [
          // ONLY show trash icon if we are editing an existing note
          if (widget.note != null)
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
                size: 30,
              ),
              onPressed: () {
                showDeleteDialog(context, widget.note!, () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              },
            ),
          const SizedBox(width: 10),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextField(
                controller: titleController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                cursorColor:
                    MyColors.secondaryColor, // Your yellow/accent color
                decoration: InputDecoration(
                  hintText: "Note Title",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  border: InputBorder.none, // Clean, borderless look
                ),
              ),

              const SizedBox(height: 8),

              // Date/Status Row (Small touch of class)
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    (widget.note == null)
                        ? DateFormat('MMMM dd, yyyy').format(DateTime.now())
                        : DateFormat(
                            'MMMM dd, yyyy',
                          ).format(widget.note!.createdAt),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(
                color: Colors.white10,
                thickness: 1,
              ), // Subtle separator
              const SizedBox(height: 20),

              // Description/Content Field
              Expanded(
                child: TextField(
                  controller: contentController,
                  maxLines: null, // Makes it expand vertically as you type
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    height: 1.5, // Better line spacing for readability
                  ),
                  cursorColor: MyColors.secondaryColor,
                  decoration: InputDecoration(
                    hintText: "Description...",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // 1. Validation
          if (titleController.text.isEmpty || contentController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please fill in both fields')),
            );
            return;
          }

          if (widget.note == null) {
            context.read<NoteViewModel>().addNote(
              titleController.text,
              contentController.text,
            );
          } else {
            context.read<NoteViewModel>().updateNote(
              NoteModel(
                id: widget.note!.id,
                title: titleController.text,
                content: contentController.text,
                isPinned: widget.note!.isPinned,
                createdAt: widget.note!.createdAt,
              ),
            );
          }

          // 3. Go back to Home
          Navigator.pop(context);
        },
        label: Text(
          (widget.note) == null ? 'Save Note' : 'Update Note',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.check_rounded, color: Colors.black),
        backgroundColor: MyColors.secondaryColor, // Your yellow/accent color
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
