import 'package:flutter/material.dart';
import '../models/court.dart';
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
  String _filter = 'All';
  String _query = '';
  final _ctrl = TextEditingController();

  List<Court> get _filtered => kCourts.where((c) {
        final matchTag = _filter == 'All' || c.tag == _filter;
        final q = _query.toLowerCase();
        final matchQ = c.name.toLowerCase().contains(q) || c.location.toLowerCase().contains(q);
        return matchTag && matchQ;
      }).toList();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Column(
      children: [
        // ── Header ──────────────────────────────────────────────────────────
        Container(
          color: kGreen,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 12,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back 👋',
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: const [
                          Icon(Icons.location_on, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Rome, Italy',
                            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFBBF24),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: kSlate400, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _ctrl,
                              onChanged: (v) => setState(() => _query = v),
                              decoration: const InputDecoration(
                                hintText: 'Search padel courts...',
                                hintStyle: TextStyle(color: kSlate400, fontSize: 14),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: const TextStyle(fontSize: 14, color: kSlate800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: widget.onOpenFilter,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.tune, color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Scrollable content ───────────────────────────────────────────────
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: kSlate50,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: ListView(
                padding: const EdgeInsets.only(top: 16, bottom: 100),
                children: [
                  // Filter chips
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
                        onTap: () => setState(() => _filter = kFilterTags[i]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Recommended section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recommended (${filtered.length})',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kSlate800),
                        ),
                        Text(
                          'See All',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kGreen),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: filtered.length > 4 ? 4 : filtered.length,
                      itemBuilder: (_, i) => CourtGridCard(
                        court: filtered[i],
                        bookmarked: widget.bookmarks.contains(filtered[i].id),
                        onToggleBookmark: () => widget.onToggleBookmark(filtered[i].id),
                        onTap: () => widget.onOpenCourt(filtered[i]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Recently booked
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recently Booked',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kSlate800),
                        ),
                        Text(
                          'See All',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kGreen),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (filtered.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text('No courts found.', style: TextStyle(color: kSlate400, fontSize: 13)),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: filtered
                            .map((c) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: CourtListCard(
                                    court: c,
                                    bookmarked: widget.bookmarks.contains(c.id),
                                    onToggleBookmark: () => widget.onToggleBookmark(c.id),
                                    onTap: () => widget.onOpenCourt(c),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
