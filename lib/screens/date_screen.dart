import 'package:flutter/material.dart';
import '../models/court.dart';
import '../theme.dart';
import '../widgets/common.dart';

const _days = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
const _months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
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
  late int _selected;
  late String _time;
  int _players = 2;

  @override
  void initState() {
    super.initState();
    _month = _today.month - 1; // 0-indexed
    _year = _today.year;
    _selected = _today.day;
    _time = kTimeSlots[2];
  }

  void _prevMonth() {
    setState(() {
      if (_month == 0) {
        _month = 11;
        _year--;
      } else {
        _month--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_month == 11) {
        _month = 0;
        _year++;
      } else {
        _month++;
      }
    });
  }

  List<int?> get _cells {
    final firstDay = DateTime(_year, _month + 1, 1).weekday % 7;
    final daysInMonth = DateTime(_year, _month + 2, 0).day;
    return [
      ...List<int?>.filled(firstDay, null),
      ...List.generate(daysInMonth, (i) => i + 1),
    ];
  }

  double get _total => widget.court.price * (_players >= 4 ? 2 : 1);

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
                    decoration: BoxDecoration(color: kSlate100, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_back_ios_new, size: 16, color: kSlate700),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Select Date & Time',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: kSlate800),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendar
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
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kSlate800),
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
                        // Day headers
                        Row(
                          children: _days
                              .map((d) => Expanded(
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
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 8),
                        // Calendar grid
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
                            final isSelected = day == _selected;
                            return GestureDetector(
                              onTap: () => setState(() => _selected = day),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected ? kGreen : Colors.transparent,
                                  shape: BoxShape.circle,
                                  boxShadow: isSelected
                                      ? [BoxShadow(color: kGreen.withOpacity(0.4), blurRadius: 8)]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    '$day',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected ? Colors.white : kSlate700,
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

                  // Time slots
                  const Text(
                    'Available Time',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kSlate800),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2.4,
                    ),
                    itemCount: kTimeSlots.length,
                    itemBuilder: (_, i) {
                      final t = kTimeSlots[i];
                      final active = _time == t;
                      return GestureDetector(
                        onTap: () => setState(() => _time = t),
                        child: Container(
                          decoration: BoxDecoration(
                            color: active ? kGreen : kSlate50,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: active
                                ? [BoxShadow(color: kGreen.withOpacity(0.3), blurRadius: 6)]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              t,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: active ? Colors.white : kSlate600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Players
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kSlate50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Players',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kSlate800),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'How many will play?',
                              style: TextStyle(fontSize: 12, color: kSlate400),
                            ),
                          ],
                        ),
                        const Spacer(),
                        _counterBtn(Icons.remove, () {
                          if (_players > 1) setState(() => _players--);
                        }, outlined: true),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '$_players',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kSlate800),
                          ),
                        ),
                        _counterBtn(Icons.add, () {
                          if (_players < 4) setState(() => _players++);
                        }, outlined: false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Footer
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
                      '\$${_total.toInt()}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kSlate900),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 160,
                  child: PrimaryButton(
                    label: 'Continue',
                    onPressed: () => widget.onContinue(BookingInfo(
                      date: _selected,
                      time: _time,
                      players: _players,
                      total: _total,
                      court: widget.court,
                    )),
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
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: kSlate500),
      ),
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback onTap, {required bool outlined}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: outlined ? Colors.white : kGreen,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6)],
        ),
        child: Icon(icon, size: 18, color: outlined ? kGreen : Colors.white),
      ),
    );
  }
}

const kSlate600 = Color(0xFF475569);
