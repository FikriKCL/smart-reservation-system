import 'package:flutter/material.dart';
import '../models/court.dart';
import '../models/booking_info.dart';
import '../services/slot_service.dart';
import '../services/waiting_list_service.dart';
import '../services/api_client.dart';
import '../theme.dart';
import '../widgets/common.dart';

const _days = ['Mi', 'Se', 'Se', 'Ra', 'Ka', 'Ju', 'Sa'];
const _months = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
];

class DateScreen extends StatefulWidget {
  final Court court;
  final VoidCallback onBack;
  final void Function(BookingInfo info) onContinue;

  const DateScreen({
    super.key,
    required this.court,
    required this.onBack,
    required this.onContinue,
  });

  @override
  State<DateScreen> createState() => _DateScreenState();
}

class _DateScreenState extends State<DateScreen> {
  final _today = DateTime.now();

  late int _month;
  late int _year;
  late int _selectedDay;

  String? _selectedStartTime;
  String? _selectedEndTime;

  bool _loadingSlots = false;
  List<Map<String, dynamic>> _slots = [];

  @override
  void initState() {
    super.initState();
    _month = _today.month - 1;
    _year = _today.year;
    _selectedDay = _today.day;
    _loadSlots();
  }

  DateTime get _selectedDate => DateTime(_year, _month + 1, _selectedDay);

  String get _formattedDate {
    final d = _selectedDate;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  List<int?> get _cells {
    final firstDay = DateTime(_year, _month + 1, 1).weekday % 7;
    final daysInMonth = DateTime(_year, _month + 2, 0).day;
    return [
      ...List<int?>.filled(firstDay, null),
      ...List.generate(daysInMonth, (i) => i + 1),
    ];
  }

  Future<void> _loadSlots() async {
    setState(() {
      _loadingSlots = true;
      _selectedStartTime = null;
      _selectedEndTime = null;
    });
    try {
      final data = await SlotService.fetchAvailableSlots(
        courtId: widget.court.id,
        date: _formattedDate,
      );
      setState(() => _slots = data);
    } catch (_) {
      setState(() => _slots = []);
    } finally {
      setState(() => _loadingSlots = false);
    }
  }

  void _selectDay(int day) {
    setState(() => _selectedDay = day);
    _loadSlots();
  }

  void _prevMonth() {
    setState(() {
      if (_month == 0) { _month = 11; _year--; }
      else { _month--; }
      _selectedDay = 1;
    });
    _loadSlots();
  }

  void _nextMonth() {
    setState(() {
      if (_month == 11) { _month = 0; _year++; }
      else { _month++; }
      _selectedDay = 1;
    });
    _loadSlots();
  }

  String _shortTime(String t) => t.length >= 5 ? t.substring(0, 5) : t;

  // Lanjut ke payment screen (tidak buat reservasi dulu)
  void _proceedToPayment() {
    if (_selectedStartTime == null || _selectedEndTime == null) return;

    widget.onContinue(
      BookingInfo(
        date: _selectedDay,
        dateStr: _formattedDate,
        startTime: _shortTime(_selectedStartTime!),
        endTime: _shortTime(_selectedEndTime!),
        players: 2,
        total: widget.court.pricePerHour.toDouble(),
        court: widget.court,
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Suggest slot alternatif ketika slot terisi
  void _showConflictDialog(List<Map<String, dynamic>> suggestedSlots) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Slot Sudah Terisi 😔',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: kSlate900,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pilih slot lain atau masuk waiting list:',
              style: TextStyle(fontSize: 13, color: kSlate500),
            ),
            const SizedBox(height: 16),
            if (suggestedSlots.isNotEmpty) ...[
              const Text(
                'Slot Tersedia Lainnya:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kSlate700),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: suggestedSlots.map((s) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _selectedStartTime = s['start_time'];
                        _selectedEndTime = s['end_time'];
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: kGreenLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_shortTime(s['start_time'])}-${_shortTime(s['end_time'])}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: kGreenDark,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _joinWaitingList();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: kGreen),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  'Masuk Waiting List',
                  style: TextStyle(fontWeight: FontWeight.w700, color: kGreen),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _joinWaitingList() async {
    if (_selectedStartTime == null) return;

    final userId = await ApiClient.getUserId();
    if (userId == null) {
      _showError('Sesi berakhir, silakan login kembali.');
      return;
    }

    final result = await WaitingListService.joinWaitingList(
      courtId: int.parse(widget.court.id),
      reservationDate: _formattedDate,
      requestedTime: _shortTime(_selectedStartTime!),
    );

    if (!mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil masuk waiting list! Posisi: ${result['position']}'),
          backgroundColor: kGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      _showError(result['message'] ?? 'Gagal masuk waiting list.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cells = _cells;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 12,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.onBack,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: kSlate100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, size: 16, color: kSlate700),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pilih Tanggal & Waktu',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kSlate800),
                      ),
                      Text(
                        widget.court.name,
                        style: const TextStyle(fontSize: 12, color: kSlate400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Konten scroll
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kalender
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kSlate50,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_months[_month]} $_year',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: kSlate800,
                              ),
                            ),
                            Row(
                              children: [
                                _navBtn(Icons.chevron_left, _prevMonth),
                                const SizedBox(width: 8),
                                _navBtn(Icons.chevron_right, _nextMonth),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: _days.map((d) => Expanded(
                            child: Center(
                              child: Text(
                                d,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: kSlate400,
                                ),
                              ),
                            ),
                          )).toList(),
                        ),
                        const SizedBox(height: 8),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            childAspectRatio: 1,
                          ),
                          itemCount: cells.length,
                          itemBuilder: (_, i) {
                            final day = cells[i];
                            if (day == null) return const SizedBox();
                            final isSelected = day == _selectedDay;
                            final isPast = DateTime(_year, _month + 1, day)
                                .isBefore(DateTime(_today.year, _today.month, _today.day));

                            return GestureDetector(
                              onTap: isPast ? null : () => _selectDay(day),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected ? kGreen : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '$day',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isPast
                                          ? kSlate200
                                          : isSelected
                                              ? Colors.white
                                              : kSlate700,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Slot waktu
                  Row(
                    children: [
                      const Text(
                        'Slot Tersedia',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kSlate800,
                        ),
                      ),
                      const Spacer(),
                      if (_selectedStartTime != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: kGreenLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${_shortTime(_selectedStartTime!)}-${_shortTime(_selectedEndTime!)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: kGreenDark,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (_loadingSlots)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(color: kGreen),
                      ),
                    )
                  else if (_slots.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('Tidak ada slot tersedia.', style: TextStyle(color: kSlate400)),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 2.4,
                      ),
                      itemCount: _slots.length,
                      itemBuilder: (_, i) {
                        final slot = _slots[i];
                        final start = slot['start_time'] as String;
                        final end = slot['end_time'] as String;
                        final available = slot['available'] == true;
                        final active = _selectedStartTime == start;

                        return GestureDetector(
                          onTap: available
                              ? () => setState(() {
                                    _selectedStartTime = start;
                                    _selectedEndTime = end;
                                  })
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              color: !available ? kSlate100 : active ? kGreen : kSlate50,
                              borderRadius: BorderRadius.circular(12),
                              border: active
                                  ? null
                                  : Border.all(color: available ? kSlate200 : Colors.transparent),
                            ),
                            child: Center(
                              child: Text(
                                '${_shortTime(start)}-${_shortTime(end)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: !available ? kSlate300 : active ? Colors.white : kSlate600,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _legend(kGreen, 'Dipilih'),
                      const SizedBox(width: 16),
                      _legend(kSlate50, 'Tersedia'),
                      const SizedBox(width: 16),
                      _legend(kSlate100, 'Terisi'),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Bottom bar
          Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 14,
              bottom: MediaQuery.of(context).padding.bottom + 14,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: kSlate200)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 11, color: kSlate400)),
                    Text(
                      'Rp ${widget.court.pricePerHour}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: kSlate900,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 160,
                  child: PrimaryButton(
                    label: 'Pilih Pembayaran',
                    onPressed: _selectedStartTime == null ? () {} : _proceedToPayment,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: kSlate500),
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: kSlate200),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: kSlate500)),
      ],
    );
  }
}
