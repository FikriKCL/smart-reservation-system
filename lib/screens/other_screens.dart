import 'package:flutter/material.dart';
import '../models/booking_info.dart';
import '../models/user.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../services/profile_service.dart';
import '../services/auth_service.dart';

// ── Success Screen ─────────────────────────────────────────────────────────────

class SuccessScreen extends StatelessWidget {
  final BookingInfo booking;
  final VoidCallback onDone;
  final VoidCallback onViewBookings;

  const SuccessScreen({
    super.key,
    required this.booking,
    required this.onDone,
    required this.onViewBookings,
  });

  @override
  Widget build(BuildContext context) {
    final b = booking;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            children: [
              const Spacer(),

              // Ikon sukses animasi
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (_, v, child) => Transform.scale(scale: v, child: child),
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD1FAE5),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: kGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: kGreen.withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 36),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Booking Berhasil!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: kSlate900),
              ),
              const SizedBox(height: 8),
              const Text(
                'Lapangan padel kamu sudah dipesan.\nSiap untuk bermain! 🎾',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: kSlate400, height: 1.5),
              ),
              const SizedBox(height: 28),

              // Kartu ringkasan booking
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
                          url: b.court.picture,
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: kSlate800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                b.court.location,
                                style: const TextStyle(fontSize: 12, color: kSlate400),
                              ),
                            ],
                          ),
                        ),
                        if (b.reservationId != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: kGreenLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '#${b.reservationId}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: kGreenDark,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: kSlate200, height: 1),
                    const SizedBox(height: 16),
                    _row('Tanggal', b.dateStr),
                    const SizedBox(height: 10),
                    _row('Waktu', '${b.startTime} – ${b.endTime}'),
                    const SizedBox(height: 10),
                    _row('Status', 'Pending', statusChip: true),
                    const SizedBox(height: 10),
                    _row('Total', 'Rp ${b.total.toInt()}', highlight: true),
                  ],
                ),
              ),

              const Spacer(),

              PrimaryButton(
                label: 'Lihat Booking Saya',
                onPressed: onViewBookings,
                width: double.infinity,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: onDone,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide.none,
                    backgroundColor: kSlate100,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: const Text(
                    'Kembali ke Home',
                    style: TextStyle(fontWeight: FontWeight.w700, color: kSlate700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool highlight = false, bool statusChip = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: kSlate400)),
        if (statusChip)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Pending',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFF59E0B)),
            ),
          )
        else
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

// ── Profile Screen ─────────────────────────────────────────────────────────────

class ProfileScreen extends StatefulWidget {
  final VoidCallback onMyBookings;
  final VoidCallback onLogout;

  const ProfileScreen({super.key, required this.onMyBookings, required this.onLogout});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() { _loading = true; _error = null; });
    try {
      final user = await ProfileService.fetchProfile();
      setState(() => _user = user);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: kSlate500)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService.logout();
      widget.onLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kGreen)),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: kSlate400),
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: kSlate500)),
              const SizedBox(height: 16),
              TextButton(onPressed: _loadProfile, child: const Text('Coba lagi')),
            ],
          ),
        ),
      );
    }

    final user = _user!;

    return Scaffold(
      backgroundColor: kSlate50,
      body: Column(
        children: [
          // Header hijau
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
                  child: Center(
                    child: Text(
                      user.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.name,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 13),
                ),
                if (user.phone != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    user.phone!,
                    style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 12),
                  ),
                ],
              ],
            ),
          ),

          // Konten (pakai Expanded + SingleChildScrollView agar tidak overflow)
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: kSlate50,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                // Geser ke atas agar menimpa header
                transform: Matrix4.translationValues(0, -24, 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      // Stat cards
                      Row(
                        children: [
                          _statCard('${user.reservationCount}', 'Bookings'),
                          const SizedBox(width: 12),
                          _statCard('${user.waitingListCount}', 'Waiting'),
                          const SizedBox(width: 12),
                          _statCard('4.9', 'Rating'),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Menu
                      _menuItem(Icons.calendar_today_outlined, 'My Bookings', onTap: widget.onMyBookings),
                      _menuItem(Icons.credit_card_outlined, 'Metode Pembayaran'),
                      _menuItem(Icons.notifications_none_outlined, 'Notifikasi'),
                      _menuItem(Icons.help_outline, 'Pusat Bantuan'),
                      _menuItem(Icons.settings_outlined, 'Pengaturan'),
                      _menuItem(
                        Icons.logout,
                        'Log Out',
                        color: const Color(0xFFEF4444),
                        onTap: _handleLogout,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String n, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
          ],
        ),
        child: Column(
          children: [
            Text(
              n,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kGreen),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: kSlate400)),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    IconData icon,
    String title, {
    Color? color,
    VoidCallback? onTap,
  }) {
    final labelColor = color ?? kSlate700;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap ?? () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color != null ? color.withOpacity(0.1) : kSlate100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: labelColor),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: labelColor),
                ),
                const Spacer(),
                Icon(Icons.chevron_right, color: kSlate300, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
