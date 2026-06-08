import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_reservation/views/screens/splash_screen.dart';
import 'models/court.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/date_screen.dart';
import 'screens/bookmark_screen.dart';
import 'screens/filter_screen.dart';
import 'models/booking_info.dart';
import 'screens/other_screens.dart';
import 'screens/payment_methods_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const PadelApp());
}

class PadelApp extends StatelessWidget {
  const PadelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Padel Reservation',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const SplashScreen(),
    );
  }
}

enum AppScreen { home, bookmark, detail, date, filter, profile, success }

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppScreen _screen = AppScreen.home;
  int _activeTab = 0;
  List<String> _bookmarks = ['2', '4'];
  Court? _currentCourt;
  BookingInfo? _booking;

  void _toggleBookmark(String id) {
    setState(() {
      if (_bookmarks.contains(id)) {
        _bookmarks = _bookmarks.where((x) => x != id).toList();
      } else {
        _bookmarks = [..._bookmarks, id];
      }
    });
  }

  void _openCourt(Court court) {
    setState(() {
      _currentCourt = court;
      _screen = AppScreen.detail;
    });
  }

  void _goTab(int index) {
    setState(() {
      _activeTab = index;
      switch (index) {
        case 0:
          _screen = AppScreen.home;
        case 1:
          _screen = AppScreen.bookmark;
        case 2:
          _screen = _booking != null ? AppScreen.success : AppScreen.bookmark;
        case 3:
          _screen = AppScreen.profile;
      }
    });
  }

  bool get _showBottomNav =>
      _screen == AppScreen.home ||
      _screen == AppScreen.bookmark ||
      _screen == AppScreen.profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSlate50,
      body: _buildScreen(),
      bottomNavigationBar: _showBottomNav ? _buildBottomNav() : null,
    );
  }

  Widget _buildScreen() {
    switch (_screen) {
      case AppScreen.home:
        return HomeScreen(
          bookmarks: _bookmarks,
          onToggleBookmark: _toggleBookmark,
          onOpenCourt: _openCourt,
          onOpenFilter: () => setState(() => _screen = AppScreen.filter),
        );
      case AppScreen.bookmark:
        return BookmarkScreen(
          bookmarks: _bookmarks,
          onToggleBookmark: _toggleBookmark,
          onOpenCourt: _openCourt,
        );
      case AppScreen.detail:
        return DetailScreen(
          court: _currentCourt!,
          bookmarked: _bookmarks.contains(_currentCourt!.id),
          onToggleBookmark: () => _toggleBookmark(_currentCourt!.id),
          onBack: () => setState(() => _screen = AppScreen.home),
          onBook: () => setState(() => _screen = AppScreen.date),
        );
      case AppScreen.date:
        return DateScreen(
          court: _currentCourt!,
          onBack: () {
            setState(() {
              _screen = AppScreen.detail;
            });
          },
          onContinue: (booking) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentMethodsScreen(
                  booking: booking,
                ),
              ),
            );
          },
        );
      case AppScreen.filter:
        return FilterScreen(
          onBack: () => setState(() => _screen = AppScreen.home),
          onApply: () => setState(() => _screen = AppScreen.home),
        );
      case AppScreen.profile:
        return const ProfileScreen();
      case AppScreen.success:
        return SuccessScreen(
          booking: _booking!,
          onDone: () => setState(() {
            _screen = AppScreen.home;
            _activeTab = 0;
          }),
        );
    }
  }

  Widget _buildBottomNav() {
    const items = [
      (icon: Icons.home_outlined, filledIcon: Icons.home, label: 'Home'),
      (
        icon: Icons.bookmark_outline,
        filledIcon: Icons.bookmark,
        label: 'Saved'
      ),
      (
        icon: Icons.calendar_today_outlined,
        filledIcon: Icons.calendar_today,
        label: 'Bookings'
      ),
      (icon: Icons.person_outline, filledIcon: Icons.person, label: 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kSlate200, width: 1)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: List.generate(items.length, (i) {
              final active = _activeTab == i;
              final item = items[i];
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _goTab(i),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          active ? item.filledIcon : item.icon,
                          key: ValueKey(active),
                          color: active ? kGreen : kSlate400,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: active ? kGreen : kSlate400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
