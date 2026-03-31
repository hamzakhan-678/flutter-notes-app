import 'package:notes_application_mvvm/models/note_filter.dart';
import 'package:notes_application_mvvm/viewmodels/note_view_model.dart';
import 'package:notes_application_mvvm/views/screens/add_or_edit_screen.dart';
import 'package:notes_application_mvvm/views/widgets/delete_dialog.dart';
import 'package:notes_application_mvvm/views/widgets/note_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:notes_application_mvvm/core/utils/my_colors.dart';
import 'package:notes_application_mvvm/core/utils/screen_utils.dart';
import 'package:notes_application_mvvm/views/widgets/filter_chip_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    final vm = context.read<NoteViewModel>();

    Future.microtask(() async {
      await vm.fetchNotes();
      await vm.insertDummyData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NoteViewModel>();

    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 70,

        actions: [
          // Profile Avatar
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 28,
                backgroundColor: MyColors.secondaryColor,
                child: Icon(Icons.person, size: 40),
              ),
            ),
          ),
        ],

        // Menu Button
        leading: Padding(
          padding: const EdgeInsets.all(15.0),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu_sharp,
              color: Colors.white,
              size: 30,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),

                      // Header and Filter Chip Buttons
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Notes',
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                          SizedBox(height: screenHeight(context) * 0.01),

                          // Filter Chips Buttons
                          Row(
                            children: [
                              FilterChipItem(
                                label: 'All',
                                count: vm.getTotalNotesCount,
                                isSelected: vm.selectedFilter == NoteFilter.all,
                                onClicked: () {
                                  vm.updateFilter(NoteFilter.all);
                                },
                              ),
                              SizedBox(width: screenWidth(context) * 0.03),
                              FilterChipItem(
                                label: 'Pinned',
                                count: vm.pinnedNotesCount,
                                isSelected:
                                    vm.selectedFilter == NoteFilter.pinned,
                                onClicked: () {
                                  vm.updateFilter(NoteFilter.pinned);
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ), // End: Header and FilterChip Buttons
                    // Notes List
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 10,
                          right: 10,
                        ), // bottom space for the Glass Bar
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.75,
                            ),
                        itemCount: vm.filtered.length,
                        itemBuilder: (context, index) {
                          final note = vm.filtered[index];
                          return NoteCard(
                            note: note,
                            onLongPress: () {
                              showDeleteDialog(context, note, () {
                                Navigator.pop(context);
                              });
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddOrEditScreen(note: note),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 17),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddOrEditScreen()),
            );
          },
          backgroundColor: MyColors.secondaryColor,
          shape: CircleBorder(),
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: 35,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
