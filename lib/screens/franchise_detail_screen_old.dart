import 'package:flutter/material.dart';
import '../models/court.dart';
import '../models/booking_info.dart';
import '../services/court_service.dart';
import '../widgets/common.dart';
import '../screens/detail_screen.dart';
import '../screens/date_screen.dart';
import '../screens/payment_methods_screen.dart';

class FranchiseDetailScreen extends StatefulWidget {
  final int locationId;
  final String locationName;

  const FranchiseDetailScreen({
    super.key,
    required this.locationId,
    required this.locationName,
  });

  @override
  State<FranchiseDetailScreen> createState() => _FranchiseDetailScreenState();
}

class _FranchiseDetailScreenState extends State<FranchiseDetailScreen> {
  late Future<List<Court>> _courtsFuture;

  @override
  void initState() {
    super.initState();
    _courtsFuture = CourtService.fetchCourtsByLocation(widget.locationId);
  }

  void _openCourt(BuildContext context, Court court) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(
          court: court,
          bookmarked: false,
          onToggleBookmark: () {},
          onBack: () => Navigator.pop(context),
          onBook: () => _openDateScreen(context, court),
        ),
      ),
    );
  }

  void _openDateScreen(BuildContext context, Court court) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DateScreen(
          court: court,
          onBack: () => Navigator.pop(context),
          onContinue: (info) => _openPaymentScreen(context, info),
        ),
      ),
    );
  }

  Future<void> _openPaymentScreen(BuildContext context, BookingInfo info) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentMethodsScreen(booking: info),
      ),
    );

    if (result != null && result['success'] == true && mounted) {
      // Kembali ke home setelah booking berhasil
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.locationName),
      ),
      body: FutureBuilder<List<Court>>(
        future: _courtsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Tidak ada court pada lokasi ini'),
            );
          }

          final courts = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: courts.length,
            itemBuilder: (_, i) {
              final court = courts[i];
              return CourtListCard(
                court: court,
                bookmarked: false,
                onToggleBookmark: () {},
                onTap: () => _openCourt(context, court),
              );
            },
          );
        },
      ),
    );
  }
}