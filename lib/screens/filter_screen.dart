import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';

class FilterScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onApply;

  const FilterScreen({
    super.key,
    required this.onBack,
    required this.onApply,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final List<String> filterTags = [
    'All',
    'Padel',
  ];

  String _type = 'All';
  double _price = 200000;

  void _reset() {
    setState(() {
      _type = 'All';
      _price = 200000;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  'Filter',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: kSlate800,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _reset,
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: kGreen,
                    ),
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
                  const Text(
                    'Court Type',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: kSlate800,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    children: filterTags.map((tag) {
                      final active = _type == tag;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _type = tag;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: active ? kGreen : kSlate50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tag,
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

                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Max Price / Hour',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kSlate800,
                        ),
                      ),
                      Text(
                        'Rp ${_price.toInt()}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: kGreen,
                        ),
                      ),
                    ],
                  ),

                  Slider(
                    min: 50000,
                    max: 300000,
                    divisions: 5,
                    value: _price,
                    onChanged: (value) {
                      setState(() {
                        _price = value;
                      });
                    },
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
            child: PrimaryButton(
              label: 'Apply Filter',
              onPressed: widget.onApply,
            ),
          ),
        ],
      ),
    );
  }
}