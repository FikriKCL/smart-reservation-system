import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../services/reservation_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

String formatDate(String date) {
  final d = DateTime.parse(date);

  return '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';
}

String formatCompactRupiah(num amount) {
  if (amount >= 1000000) {
    return 'Rp ${(amount / 1000000).toStringAsFixed(1)}jt';
  }
  if (amount >= 1000) {
    return 'Rp ${(amount / 1000).toStringAsFixed(0)}rb';
  }
  return 'Rp ${amount.toInt()}';
}

class MyBookingsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const MyBookingsScreen({super.key, this.onBack});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Reservation>> _future;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _future = ReservationService.fetchReservations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = ReservationService.fetchReservations();
    });
  }

  Future<void> _cancel(Reservation r) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Batalkan Booking?',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Yakin ingin membatalkan booking lapangan ${r.court?.name ?? ''} tanggal ${r.reservationDate}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tidak', style: TextStyle(color: kSlate500)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Batalkan',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final ok = await ReservationService.cancelReservation(r.id);
      if (ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Booking berhasil dibatalkan.'),
            backgroundColor: kGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        _refresh();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSlate50,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              left: 20,
              right: 20,
              bottom: 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (widget.onBack != null)
                      GestureDetector(
                        onTap: widget.onBack,
                        child: Container(
                          width: 38,
                          height: 38,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: const BoxDecoration(
                            color: kSlate100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 16,
                            color: kSlate700,
                          ),
                        ),
                      ),
                    const Text(
                      'My Bookings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: kSlate800,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _refresh,
                      child: const Icon(
                        Icons.refresh,
                        color: kSlate400,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TabBar(
                  controller: _tabController,
                  labelColor: kGreen,
                  unselectedLabelColor: kSlate400,
                  indicatorColor: kGreen,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  dividerColor: kSlate200,
                  tabs: const [
                    Tab(text: 'Semua'),
                    Tab(text: 'Aktif'),
                    Tab(text: 'Selesai'),
                  ],
                ),
              ],
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────────────
          Expanded(
            child: FutureBuilder<List<Reservation>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: kGreen),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: kSlate400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${snapshot.error}',
                          style: const TextStyle(color: kSlate500),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _refresh,
                          child: const Text('Coba lagi'),
                        ),
                      ],
                    ),
                  );
                }

                final all = snapshot.data ?? [];

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _ReservationList(
                      reservations: all,
                      onCancel: _cancel,
                    ),
                    _ReservationList(
                      reservations: all
                          .where((r) =>
                              r.status == 'pending' || r.status == 'approved')
                          .toList(),
                      onCancel: _cancel,
                    ),
                    _ReservationList(
                      reservations:
                          all.where((r) => r.status == 'cancelled').toList(),
                      onCancel: null,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReservationList extends StatelessWidget {
  final List<Reservation> reservations;
  final void Function(Reservation)? onCancel;

  const _ReservationList({
    required this.reservations,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (reservations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today_outlined, size: 56, color: kSlate300),
            SizedBox(height: 16),
            Text(
              'Belum ada booking.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: kSlate500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: reservations.length,
      itemBuilder: (_, i) => _ReservationCard(
        reservation: reservations[i],
        onCancel: onCancel != null ? () => onCancel!(reservations[i]) : null,
      ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback? onCancel;

  const _ReservationCard({required this.reservation, this.onCancel});

  Color get _statusColor {
    switch (reservation.status) {
      case 'approved':
        return kGreen;
      case 'pending':
        return const Color(0xFFF59E0B);
      default:
        return kSlate400;
    }
  }

  Color get _statusBg {
    switch (reservation.status) {
      case 'approved':
        return kGreenLight;
      case 'pending':
        return const Color(0xFFFFFBEB);
      default:
        return kSlate100;
    }
  }

  String get _statusLabel {
    switch (reservation.status) {
      case 'approved':
        return 'Disetujui';
      case 'pending':
        return 'Menunggu';
      default:
        return 'Dibatalkan';
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = reservation;
    final court = r.court;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Court image
                CourtImage(
                  url: court?.picture ?? '',
                  width: 60,
                  height: 60,
                  borderRadius: BorderRadius.circular(14),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              court?.name ?? 'Lapangan #${r.courtId}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: kSlate800,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _statusBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _statusLabel,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: _statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (court?.location != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 11,
                              color: kSlate400,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                court!.location,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: kSlate400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(color: kSlate100, height: 1),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _info(
                    Icons.calendar_today_outlined,
                    formatDate(r.reservationDate),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _info(
                    Icons.access_time_outlined,
                    '${r.startTime} - ${r.endTime}',
                  ),
                ),
                Text(
                  formatCompactRupiah(r.totalPrice),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: kGreen,
                  ),
                ),
              ],
            ),
            if (onCancel != null && r.isPending) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFEF4444)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Batalkan Booking',
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _info(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 13, color: kSlate400),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 12,
              color: kSlate500,
            ),
          ),
        ),
      ],
    );
  }
}
