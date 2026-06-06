import 'package:flutter/material.dart';
import '../models/court.dart';
import '../theme.dart';
import '../widgets/common.dart';

class FilterScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onApply;

  const FilterScreen({super.key, required this.onBack, required this.onApply});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String _type = 'All';
  double _price = 50;
  double _rating = 4;
  List<String> _facilities = ['WiFi', 'Parking'];

  void _toggle(String f) {
    setState(() {
      if (_facilities.contains(f)) {
        _facilities = _facilities.where((x) => x != f).toList();
      } else {
        _facilities = [..._facilities, f];
      }
    });
  }

  void _reset() {
    setState(() {
      _type = 'All';
      _price = 50;
      _rating = 4;
      _facilities = [];
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    decoration: const BoxDecoration(color: kSlate100, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_back_ios_new, size: 16, color: kSlate700),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Filter',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: kSlate800),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _reset,
                  child: const Text(
                    'Reset',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kGreen),
                  ),
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
                  // Court type
                  const Text(
                    'Court Type',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kSlate800),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: kFilterTags.map((t) {
                      final active = _type == t;
                      return GestureDetector(
                        onTap: () => setState(() => _type = t),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: active ? kGreen : kSlate50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            t,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: active ? Colors.white : kSlate600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Price range
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Price Range / hour',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kSlate800),
                      ),
                      Text(
                        '\$${_price.toInt()}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: kGreen),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: kGreen,
                      inactiveTrackColor: kSlate200,
                      thumbColor: kGreen,
                      overlayColor: kGreen.withOpacity(0.15),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      min: 20,
                      max: 80,
                      value: _price,
                      onChanged: (v) => setState(() => _price = v),
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$20', style: TextStyle(fontSize: 11, color: kSlate400)),
                      Text('\$80', style: TextStyle(fontSize: 11, color: kSlate400)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Rating
                  const Text(
                    'Minimum Rating',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kSlate800),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [3.0, 3.5, 4.0, 4.5, 5.0].map((r) {
                      final active = _rating == r;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: GestureDetector(
                            onTap: () => setState(() => _rating = r),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              decoration: BoxDecoration(
                                color: active ? kGreen : kSlate50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '${r % 1 == 0 ? r.toInt() : r}+',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: active ? Colors.white : kSlate600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Facilities
                  const Text(
                    'Facilities',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kSlate800),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 3.2,
                    ),
                    itemCount: kFacilityOptions.length,
                    itemBuilder: (_, i) {
                      final f = kFacilityOptions[i];
                      final active = _facilities.contains(f);
                      return GestureDetector(
                        onTap: () => _toggle(f),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: active ? const Color(0xFFECFDF5) : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: active ? kGreen : kSlate200,
                              width: active ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(facilityIcon(f), size: 18, color: active ? kGreen : kSlate500),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  f,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: active ? kGreenDark : kSlate600,
                                  ),
                                ),
                              ),
                              if (active) const Icon(Icons.check, size: 16, color: kGreen),
                            ],
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
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        _reset();
                        widget.onBack();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: kSlate100,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(fontWeight: FontWeight.w700, color: kSlate700),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(label: 'Apply Filter', onPressed: widget.onApply),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const kSlate600 = Color(0xFF475569);
