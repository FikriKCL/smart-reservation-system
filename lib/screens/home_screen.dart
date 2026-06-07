import 'package:flutter/material.dart';
import '../models/court.dart';
import '../services/court_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

class HomeScreen extends StatefulWidget {
  final List<String> bookmarks;
  final void Function(String id) onToggleBookmark;
  final void Function(Court court) onOpenCourt;
  final VoidCallback onOpenFilter;

  const HomeScreen({
    super.key,
    required this.bookmarks,
    required this.onToggleBookmark,
    required this.onOpenCourt,
    required this.onOpenFilter,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> kFilterTags = [
  'All',
  'Padel',
];

  String _filter = 'All';
  String _query = '';
  final _ctrl = TextEditingController();

  late Future<List<Court>> _courtsFuture;

  @override
  void initState() {
    super.initState();
    _courtsFuture = CourtService.fetchCourts();
  }

  List<Court> _filterCourts(List<Court> courts) {
    return courts.where((c) {
      final matchTag = _filter == 'All' || c.tag == _filter;
      final q = _query.toLowerCase();

      final matchQ =
          c.name.toLowerCase().contains(q) ||
          c.location.toLowerCase().contains(q);

      return matchTag && matchQ;
    }).toList();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
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
        final filtered = _filterCourts(courts);

        return Column(
          children: [
            // bagian header kamu tetap sama

            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: kSlate50,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.only(top: 16, bottom: 100),
                  children: [
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: kFilterTags.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) => TagChip(
                          label: kFilterTags[i],
                          active: _filter == kFilterTags[i],
                          onTap: () {
                            setState(() {
                              _filter = kFilterTags[i];
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Recommended (${filtered.length})',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: kSlate800,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.78,
                        ),
                        itemCount: filtered.length > 4 ? 4 : filtered.length,
                        itemBuilder: (_, i) => CourtGridCard(
                          court: filtered[i],
                          bookmarked:
                              widget.bookmarks.contains(filtered[i].id),
                          onToggleBookmark: () {
                            widget.onToggleBookmark(filtered[i].id);
                          },
                          onTap: () {
                            widget.onOpenCourt(filtered[i]);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    if (filtered.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Text(
                            'No courts found.',
                            style: TextStyle(
                              color: kSlate400,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: filtered.map((c) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: CourtListCard(
                                court: c,
                                bookmarked: widget.bookmarks.contains(c.id),
                                onToggleBookmark: () {
                                  widget.onToggleBookmark(c.id);
                                },
                                onTap: () {
                                  widget.onOpenCourt(c);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}