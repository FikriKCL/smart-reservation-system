import 'package:flutter/material.dart';
import '../models/court.dart';
import '../services/slot_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '/models/booking_info.dart';

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

  DateTime get _selectedDate {
    return DateTime(_year, _month + 1, _selectedDay);
  }

  String get _formattedDate {
    final date = _selectedDate;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  List<int?> get _cells {
    final firstDay = DateTime(_year, _month + 1, 1).weekday % 7;
    final daysInMonth = DateTime(_year, _month + 2, 0).day;

    return [
      ...List<int?>.filled(firstDay, null),
      ...List.generate(daysInMonth, (i) => i + 1),
    ];
  }

  int get _total {
    return widget.court.pricePerHour;
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

      setState(() {
        _slots = data;
      });
    } catch (e) {
      setState(() {
        _slots = [];
      });
    } finally {
      setState(() {
        _loadingSlots = false;
      });
    }
  }

  void _selectDay(int day) {
    setState(() {
      _selectedDay = day;
    });

    _loadSlots();
  }

  void _prevMonth() {
    setState(() {
      if (_month == 0) {
        _month = 11;
        _year--;
      } else {
        _month--;
      }

      _selectedDay = 1;
    });

    _loadSlots();
  }

  void _nextMonth() {
    setState(() {
      if (_month == 11) {
        _month = 0;
        _year++;
      } else {
        _month++;
      }

      _selectedDay = 1;
    });

    _loadSlots();
  }

  String _shortTime(String time) {
    return time.substring(0, 5);
  }

  @override
  Widget build(BuildContext context) {
    final cells = _cells;

    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
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
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: kSlate700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Select Date & Time',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: kSlate800,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          children: _days.map((day) {
                            return Expanded(
                              child: Center(
                                child: Text(
                                  day,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: kSlate400,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 8),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            childAspectRatio: 1,
                          ),
                          itemCount: cells.length,
                          itemBuilder: (_, i) {
                            final day = cells[i];

                            if (day == null) {
                              return const SizedBox();
                            }

                            final isSelected = day == _selectedDay;

                            return GestureDetector(
                              onTap: () => _selectDay(day),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? kGreen
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '$day',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
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

                  const Text(
                    'Available Time',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: kSlate800,
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (_loadingSlots)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_slots.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'No available slots.',
                          style: TextStyle(color: kSlate400),
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 2.4,
                      ),
                      itemCount: _slots.length,
                      itemBuilder: (_, i) {
                        final slot = _slots[i];

                        final start = slot['start_time'];
                        final end = slot['end_time'];
                        final available = slot['available'] == true;

                        final active = _selectedStartTime == start;

                        return GestureDetector(
                          onTap: available
                              ? () {
                                  setState(() {
                                    _selectedStartTime = start;
                                    _selectedEndTime = end;
                                  });
                                }
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              color: !available
                                  ? kSlate200
                                  : active
                                      ? kGreen
                                      : kSlate50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '${_shortTime(start)}-${_shortTime(end)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: !available
                                      ? kSlate400
                                      : active
                                          ? Colors.white
                                          : kSlate600,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 12),
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
                top: BorderSide(color: kSlate200),
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 11,
                        color: kSlate400,
                      ),
                    ),
                    Text(
                      'Rp $_total',
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
                  label: 'Continue',
                  onPressed: () {
                    if (_selectedStartTime == null) return;

                    widget.onContinue(
                      BookingInfo(
                        date: _selectedDay,
                        time: _selectedStartTime!,
                        players: 2,
                        total: _total.toDouble(),
                        court: widget.court,
                      ),
                    );
                  },
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
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: kSlate500,
        ),
      ),
    );
  }
}

const kSlate600 = Color(0xFF475569);
