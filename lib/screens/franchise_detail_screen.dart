import '../models/court.dart';
import '../services/court_service.dart';
import '../widgets/common.dart';
import 'package:flutter/material.dart';
import '../screens/detail_screen.dart';


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
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  if (snapshot.hasError) {
    return Center(
      child: Text(
        'Error: ${snapshot.error}',
      ),
    );
  }

  if (!snapshot.hasData || snapshot.data!.isEmpty) {
    return const Center(
      child: Text(
        'Tidak ada court pada lokasi ini',
      ),
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
        onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => DetailScreen(
        court: court,
        bookmarked: false,
        onToggleBookmark: () {},
        onBack: () => Navigator.pop(context),
        onBook: () {},
      ),
    ),
  );
},
      );
    },
  );
}
      ),
    );
  }
}