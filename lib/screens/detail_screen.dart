import 'package:flutter/material.dart';
import '../models/court.dart';
import '../utils/currency_formatter.dart';
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
                  SizedBox(
                    height: 260,
                    child: Stack(
                      children: [
                        CourtImage(
                          url: court.picture,
                          width: double.infinity,
                          height: 260,
                        ),

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
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 18,
                                color: kSlate800,
                              ),
                            ),
                          ),
                        ),

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
                              ),
                              child: Icon(
                                bookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                size: 20,
                                color: kGreen,
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: kGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              court.tag,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                court.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: kSlate900,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: kAmber50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 14,
                                    color: kAmber500,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    court.rating.toStringAsFixed(1),
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

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: kSlate400,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                court.location,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: kSlate400,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: kSlate800,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          court.description.isEmpty
                              ? 'No description available.'
                              : court.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: kSlate500,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: kSlate800,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Container(
                          height: 130,
                          decoration: BoxDecoration(
                            color: kSlate50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.location_on,
                              size: 48,
                              color: kGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 14,
              bottom: MediaQuery.of(context).padding.bottom + 14,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: kSlate200, width: 1),
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 11,
                        color: kSlate400,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          CurrencyFormatter.rupiah(court.pricePerHour),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: kSlate900,
                          ),
                        ),
                        const Text(
                          '/jam',
                          style: TextStyle(
                            fontSize: 12,
                            color: kSlate400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const Spacer(),

                SizedBox(
                  width: 150,
                  child: PrimaryButton(
                    label: 'Book Now',
                    onPressed: onBook,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}