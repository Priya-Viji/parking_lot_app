import 'package:flutter/material.dart';
import 'package:parking_lot_app/screens/widgets/dashboard_card.dart';
import 'package:parking_lot_app/screens/widgets/summary.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/parking_provider.dart';
import 'history_page.dart';
import 'slots_page.dart';
import 'login_page.dart'; // Make sure this exists

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final parking = Provider.of<ParkingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _confirmLogout(context, auth),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            DashboardCard(
              icon: Icons.local_parking,
              title: "Parking Slots",
              color: Colors.deepPurple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SlotsPage()),
                );
              },
            ),
            DashboardCard(
              icon: Icons.history,
              title: "History",
              color: Colors.deepPurpleAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryPage()),
                );
              },
            ),
            DashboardCard(
              icon: Icons.analytics,
              title: "Summary",
              color: Colors.indigo,
              onTap: () => _showSummaryDialog(context, parking, auth),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // Logout Confirmation
  // ---------------------------------------------------------
  Future<void> _confirmLogout(BuildContext context, AuthProvider auth) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await auth.logout();

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  // ---------------------------------------------------------
  // Summary Dialog
  // ---------------------------------------------------------
  void _showSummaryDialog(
    BuildContext context,
    ParkingProvider parking,
    AuthProvider auth,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFf5f9ff),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: const Text(
            "Parking Summary",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Summary(
              icon: Icons.local_parking,
              color: Colors.blueAccent,
              label: "Total Slots",
              value: "20",
            ),
            const Divider(),
            FutureBuilder<int>(
              future: parking.getAvailableSlots(),
              builder: (_, snapshot) => Summary(
                icon: Icons.check_circle,
                color: Colors.green,
                label: "Available Slots",
                value: snapshot.hasData ? "${snapshot.data}" : "...",
              ),
            ),
            const Divider(),
            FutureBuilder<int>(
              future: parking.getActiveReservationCount(auth.user!.uid),
              builder: (_, snapshot) => Summary(
                icon: Icons.person,
                color: Colors.deepPurple,
                label: "Your Active Reservation",
                value: snapshot.hasData ? "${snapshot.data}" : "...",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Close",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



