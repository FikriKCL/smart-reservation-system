import 'package:flutter/material.dart';
import '../models/court.dart';
import '../theme.dart';
import '../widgets/common.dart';

class DetailScreen extends StatelessWidget {
  final Court court;
  final bool bookmarked;
  final VoidCallback onToggleBookmark;
  final VoidCallback onBack;
  final VoidCallback onBook;

  const DetailScreen({
    super.key,
    required this.court,
    required this.bookmarked,
    required this.onToggleBookmark,
    required this.onBack,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hero image ─────────────────────────────────────────────
                  SizedBox(
                    height: 260,
                    child: Stack(
                      children: [
                        CourtImage(url: court.image, width: double.infinity, height: 260),
                        // Back button
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 12,
                          left: 16,
                          child: GestureDetector(
                            onTap: onBack,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
                              ),
                              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: kSlate800),
                            ),
                          ),
                        ),
                        // Bookmark button
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 12,
                          right: 16,
                          child: GestureDetector(
                            onTap: onToggleBookmark,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
                              ),
                              child: Icon(
                                bookmarked ? Icons.bookmark : Icons.bookmark_border,
                                size: 20,
                                color: kGreen,
                              ),
                            ),
                          ),
                        ),
                        // Tag badge
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: kGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              court.tag,
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name & rating
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                court.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: kSlate900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: kAmber50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, size: 14, color: kAmber500),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${court.rating}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                      color: kAmber500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: kSlate400),
                            const SizedBox(width: 4),
                            Text(
                              court.location,
                              style: const TextStyle(fontSize: 13, color: kSlate400),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Quick stats
                        Row(
                          children: [
                            _statBox('Surface', court.surface),
                            const SizedBox(width: 10),
                            _statBox('Court Size', court.size),
                            const SizedBox(width: 10),
                            _statBox('Players', '${court.players} players'),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kSlate800),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          court.description,
                          style: const TextStyle(fontSize: 13, color: kSlate500, height: 1.6),
                        ),
                        const SizedBox(height: 20),

                        // Facilities
                        const Text(
                          'Facilities',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kSlate800),
                        ),
                        const SizedBox(height: 12),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.85,
                          children: court.facilities
                              .map((f) => Column(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFECFDF5),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Icon(facilityIcon(f), color: kGreen, size: 22),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        f,
                                        style: const TextStyle(fontSize: 10, color: kSlate500, fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 20),

                        // Gallery
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Gallery',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kSlate800),
                            ),
                            const Text(
                              'See All',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kGreen),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 96,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: court.gallery.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemBuilder: (_, i) => CourtImage(
                              url: court.gallery[i],
                              width: 128,
                              height: 96,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Location placeholder
                        const Text(
                          'Location',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kSlate800),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 130,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE0F2F1), Color(0xFFD1FAE5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Icon(Icons.location_on, size: 48, color: kGreen),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Footer ──────────────────────────────────────────────────────────
          Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 14,
              bottom: MediaQuery.of(context).padding.bottom + 14,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: kSlate200, width: 1)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Price', style: TextStyle(fontSize: 11, color: kSlate400)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${court.price.toInt()}',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kSlate900),
                        ),
                        const Text(
                          '/hour',
                          style: TextStyle(fontSize: 12, color: kSlate400),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 160,
                  child: PrimaryButton(label: 'Book Now', onPressed: onBook),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kSlate50,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: kSlate400)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kSlate700),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
