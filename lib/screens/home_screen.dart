import 'package:flutter/material.dart';
import '../models/court.dart';
import '../services/court_service.dart';
import '../services/api_client.dart';
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
  final List<String> _filterTags = ['All', 'Padel'];
  String _filter = 'All';
  String _query = '';
  final _ctrl = TextEditingController();

  late Future<List<Court>> _courtsFuture;
  late Future<List<Court>> _nearestCourtsFuture;
  String? _userName;

@override
void initState() {
  super.initState();

  _courtsFuture = CourtService.fetchCourts();
  _nearestCourtsFuture = CourtService.getNearestCourts();

  _loadUserName();
}

  Future<void> _loadUserName() async {
    final name = await ApiClient.getUserName();
    if (mounted) setState(() => _userName = name);
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
        final courts = snapshot.data ?? [];
        final filtered = _filterCourts(courts);
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        return CustomScrollView(
          slivers: [
            // ── Header ────────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: kGreen,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 20,
                  right: 20,
                  bottom: 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userName != null
                                  ? 'Halo, ${_userName!.split(' ').first} 👋'
                                  : 'Halo! 👋',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Cari lapangan padel favoritmu',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: widget.onOpenFilter,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.tune_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Search bar
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _ctrl,
                        onChanged: (v) => setState(() => _query = v),
                        style: const TextStyle(
                          fontSize: 14,
                          color: kSlate800,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Cari lapangan atau lokasi...',
                          hintStyle: const TextStyle(
                            color: kSlate400,
                            fontSize: 13,
                          ),
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: kSlate400,
                            size: 20,
                          ),
                          suffixIcon: _query.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _ctrl.clear();
                                    setState(() => _query = '');
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: kSlate400,
                                    size: 18,
                                  ),
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Body ──────────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(color: kSlate50),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    FutureBuilder<List<Court>>(
  future: _nearestCourtsFuture,
  builder: (context, snapshot) {
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const SizedBox();
    }

    final nearest = snapshot.data!;
    for (final court in nearest.take(5)) {
  print('NEAREST COURT: ${court.name}');
}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '📍 Lapangan Terdekat',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: nearest.length > 5 ? 5 : nearest.length,
            itemBuilder: (_, i) {
  final court = nearest[i];

  return Container(
    width: 180,
    margin: const EdgeInsets.only(right: 12),
    child: CourtGridCard(
      court: court,
      bookmarked: widget.bookmarks.contains(court.id),
      onToggleBookmark: () =>
          widget.onToggleBookmark(court.id),
      onTap: () =>
          widget.onOpenCourt(court),
    ),
  );
},
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  },
),

                    // Filter chips
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _filterTags.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 8),
                        itemBuilder: (_, i) => TagChip(
                          label: _filterTags[i],
                          active: _filter == _filterTags[i],
                          onTap: () =>
                              setState(() => _filter = _filterTags[i]),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: Center(
                          child: CircularProgressIndicator(color: kGreen),
                        ),
                      )
                    else if (snapshot.hasError)
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.wifi_off,
                                size: 48,
                                color: kSlate300,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Gagal memuat lapangan.',
                                style: TextStyle(color: kSlate500),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () => setState(() {
                                  _courtsFuture =
                                      CourtService.fetchCourts();
                                }),
                                child: const Text('Coba lagi'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      // Featured grid (top 4)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text(
                              'Rekomendasi (${filtered.length})',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: kSlate800,
                              ),
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.78,
                          ),
                          itemCount:
                              filtered.length > 4 ? 4 : filtered.length,
                          itemBuilder: (_, i) => CourtGridCard(
                            court: filtered[i],
                            bookmarked: widget.bookmarks
                                .contains(filtered[i].id),
                            onToggleBookmark: () =>
                                widget.onToggleBookmark(filtered[i].id),
                            onTap: () =>
                                widget.onOpenCourt(filtered[i]),
                          ),
                        ),
                      ),

                      // Full list
                      if (filtered.length > 4) ...[
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Text(
                            'Semua Lapangan',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: kSlate800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: filtered.skip(4).map((c) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: CourtListCard(
                                  court: c,
                                  bookmarked:
                                      widget.bookmarks.contains(c.id),
                                  onToggleBookmark: () =>
                                      widget.onToggleBookmark(c.id),
                                  onTap: () => widget.onOpenCourt(c),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],

                      if (filtered.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: kSlate300,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Lapangan tidak ditemukan.',
                                  style: TextStyle(
                                    color: kSlate400,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],

                    const SizedBox(height: 100),
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

