import 'package:flutter/material.dart';
import '../models/court.dart';
import '../services/court_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

class BookmarkScreen extends StatefulWidget {
  final List<String> bookmarks;
  final void Function(String id) onToggleBookmark;
  final void Function(Court court) onOpenCourt;

  const BookmarkScreen({
    super.key,
    required this.bookmarks,
    required this.onToggleBookmark,
    required this.onOpenCourt,
  });

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  Court? _confirm;
  late Future<List<Court>> _courtsFuture;

  @override
  void initState() {
    super.initState();
    _courtsFuture = CourtService.fetchCourts();
  }

  List<Court> _getSavedCourts(List<Court> courts) {
    return courts.where((court) {
      return widget.bookmarks.contains(court.id);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Court>>(
      future: _courtsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final courts = snapshot.data ?? [];
        final saved = _getSavedCourts(courts);

        return Stack(
          children: [
            Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 20,
                    right: 20,
                    bottom: 16,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'My Bookmarks',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: kSlate800,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${saved.length} saved',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: kGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: saved.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.bookmark_border,
                                size: 64,
                                color: kSlate400,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No bookmarks yet',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: kSlate500,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Save your favorite courts to find them here.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kSlate400,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.78,
                          ),
                          itemCount: saved.length,
                          itemBuilder: (_, i) {
                            final court = saved[i];

                            return CourtGridCard(
                              court: court,
                              bookmarked: true,
                              onToggleBookmark: () {
                                setState(() {
                                  _confirm = court;
                                });
                              },
                              onTap: () {
                                widget.onOpenCourt(court);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),

            if (_confirm != null)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _confirm = null;
                  });
                },
                child: Container(
                  color: Colors.black.withOpacity(0.45),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 20,
                          bottom:
                              MediaQuery.of(context).padding.bottom + 24,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(28),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 48,
                              height: 6,
                              decoration: BoxDecoration(
                                color: kSlate200,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              'Remove from Bookmark?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: kSlate800,
                              ),
                            ),

                            const SizedBox(height: 16),

                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: kSlate50,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  CourtImage(
                                    url: _confirm!.picture,
                                    width: 56,
                                    height: 56,
                                    borderRadius: BorderRadius.circular(12),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _confirm!.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: kSlate800,
                                          ),
                                        ),

                                        const SizedBox(height: 2),

                                        Text(
                                          _confirm!.location,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: kSlate400,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          'Rp ${_confirm!.pricePerHour}/hr',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: kGreen,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 52,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          _confirm = null;
                                        });
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide.none,
                                        backgroundColor: kSlate100,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: kSlate700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: PrimaryButton(
                                    label: 'Yes, Remove',
                                    onPressed: () {
                                      widget.onToggleBookmark(_confirm!.id);

                                      setState(() {
                                        _confirm = null;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}