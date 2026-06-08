import 'package:flutter/material.dart';
import '../models/court.dart';
import '../theme.dart';

// ── Primary Button ──────────────────────────────────────────────────────────

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

// ── Tag Chip ─────────────────────────────────────────────────────────────────

class TagChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const TagChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? kGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: active
              ? [BoxShadow(color: kGreen.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))]
              : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : kSlate600,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

const kSlate600 = Color(0xFF475569);

// ── Network Image with fallback ──────────────────────────────────────────────

class CourtImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CourtImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget img = Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: kSlate200,
        child: const Icon(Icons.image_not_supported, color: kSlate400),
      ),
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          width: width,
          height: height,
          color: kSlate100,
          child: const Center(
            child: CircularProgressIndicator(color: kGreen, strokeWidth: 2),
          ),
        );
      },
    );
    if (borderRadius != null) {
      img = ClipRRect(borderRadius: borderRadius!, child: img);
    }
    return img;
  }
}

// ── Court Grid Card ──────────────────────────────────────────────────────────

class CourtGridCard extends StatelessWidget {
  final Court court;
  final bool bookmarked;
  final VoidCallback onToggleBookmark;
  final VoidCallback onTap;

  const CourtGridCard({
    super.key,
    required this.court,
    required this.bookmarked,
    required this.onToggleBookmark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CourtImage(
                  url: court.picture,
                  height: 110,
                  width: double.infinity,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onToggleBookmark,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        bookmarked ? Icons.bookmark : Icons.bookmark_border,
                        size: 16,
                        color: kGreen,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      court.tag,
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    court.name,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: kSlate800),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 10, color: kSlate400),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          court.location,
                          style: const TextStyle(fontSize: 10, color: kSlate400),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 11, color: kAmber500),
                          const SizedBox(width: 2),
                          Text(
                            '${court.rating}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kAmber500),
                          ),
                        ],
                      ),
                      Text(
                        '\Rp${court.pricePerHour.toInt()}/hr',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: kGreen),
                      ),
                    ],
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

// ── Court List Card ──────────────────────────────────────────────────────────

class CourtListCard extends StatelessWidget {
  final Court court;
  final bool bookmarked;
  final VoidCallback onToggleBookmark;
  final VoidCallback onTap;

  const CourtListCard({
    super.key,
    required this.court,
    required this.bookmarked,
    required this.onToggleBookmark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            CourtImage(
              url: court.picture,
              width: 72,
              height: 72,
              borderRadius: BorderRadius.circular(14),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: kGreenLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          court.tag,
                          style: const TextStyle(color: kGreenDark, fontSize: 9, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    court.name,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: kSlate800),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 11, color: kSlate400),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          court.location,
                          style: const TextStyle(fontSize: 11, color: kSlate400),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\Rp${court.pricePerHour.toInt()}/hr',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: kGreen),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onToggleBookmark,
              child: Icon(
                bookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: kGreen,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Facility Icon ─────────────────────────────────────────────────────────────

IconData facilityIcon(String name) {
  switch (name.toLowerCase()) {
    case 'wifi':
      return Icons.wifi;
    case 'parking':
      return Icons.local_parking;
    case 'showers':
      return Icons.shower;
    case 'cafe':
      return Icons.coffee;
    case 'rackets':
      return Icons.sports_tennis;
    case 'coach':
      return Icons.sports;
    case 'lockers':
      return Icons.lock;
    case 'shop':
      return Icons.shopping_bag;
    default:
      return Icons.check_circle_outline;
  }
}
