import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_application_mvvm/core/utils/my_colors.dart';
import 'package:notes_application_mvvm/models/note_model.dart';
import 'package:notes_application_mvvm/viewmodels/note_view_model.dart';
import 'package:provider/provider.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const NoteCard({super.key, required this.note, required this.onTap, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NoteViewModel>();

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: MyColors.noteCardBgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    vm.updateNote(
                      NoteModel(
                        title: note.title,
                        content: note.content,
                        createdAt: note.createdAt,
                        isPinned: !note.isPinned,
                        id: note.id,
                      ),
                    );
                  },
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: Color(0xFFeae2be),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: note.isPinned
                        ? Icon(Icons.push_pin, size: 20)
                        : Icon(Icons.push_pin_outlined, size: 18),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 2),

            Expanded(
              child: Text(
                note.content,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFFeae2be),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.watch_later_outlined, size: 18),
                  SizedBox(width: 6),
                  Text(
                    DateFormat('dd MMM yyyy').format(note.createdAt),
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
