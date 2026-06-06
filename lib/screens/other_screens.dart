import 'package:flutter/material.dart';
import '../models/court.dart';
import '../theme.dart';
import '../widgets/common.dart';

// ── Success / Booking Confirmed ───────────────────────────────────────────────

class SuccessScreen extends StatelessWidget {
  final BookingInfo booking;
  final VoidCallback onDone;

  const SuccessScreen({super.key, required this.booking, required this.onDone});

  @override
  Widget build(BuildContext context) {
    final b = booking;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 32,
          left: 28,
          right: 28,
          bottom: MediaQuery.of(context).padding.bottom + 24,
        ),
        child: Column(
          children: [
            const Spacer(),
            // Check circle
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: kGreen,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: kGreen.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 4))],
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 36),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Booking Confirmed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: kSlate900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your padel court is reserved.\nGet ready to play! 🎾',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: kSlate400, height: 1.5),
            ),
            const SizedBox(height: 28),

            // Booking summary card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kSlate50,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CourtImage(
                        url: b.court.image,
                        width: 56,
                        height: 56,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              b.court.name,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kSlate800),
                            ),
                            const SizedBox(height: 2),
                            Text(b.court.location, style: const TextStyle(fontSize: 12, color: kSlate400)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: kSlate200, height: 1),
                  const SizedBox(height: 16),
                  _row('Date', 'Day ${b.date}'),
                  const SizedBox(height: 10),
                  _row('Time', b.time),
                  const SizedBox(height: 10),
                  _row('Players', '${b.players}'),
                  const SizedBox(height: 10),
                  _row('Total Paid', '\$${b.total.toInt()}', highlight: true),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(label: 'Back to Home', onPressed: onDone, width: double.infinity),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: kSlate400)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
            color: highlight ? kGreen : kSlate700,
          ),
        ),
      ],
    );
  }
}

// ── Profile Screen ────────────────────────────────────────────────────────────

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          color: kGreen,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            right: 20,
            bottom: 40,
          ),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'BC',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Bessie Cooper',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'bessie.cooper@email.com',
                style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 13),
              ),
            ],
          ),
        ),

        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: kSlate50,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Stats
                    Row(
                      children: [
                        _statCard('12', 'Bookings'),
                        const SizedBox(width: 12),
                        _statCard('4', 'Saved'),
                        const SizedBox(width: 12),
                        _statCard('4.9', 'Rating'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Menu items
                    ...['My Bookings', 'Payment Methods', 'Notifications', 'Help Center', 'Settings', 'Log Out']
                        .map((m) => _menuItem(m)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statCard(String n, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Column(
          children: [
            Text(n, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kGreen)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: kSlate400)),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kSlate700),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right, color: kSlate400, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
