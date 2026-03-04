import 'package:flutter/material.dart';
import 'package:parking_lot_app/screens/history_page.dart';
import 'package:parking_lot_app/screens/slots_page.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/parking_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final parkingProvider = Provider.of<ParkingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Confirm Logout"),
                  content: const Text("Are you sure you want to log out?"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
                await authProvider.logout();
                if (!context.mounted) return;
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dashboard Cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _DashboardCard(
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
                  _DashboardCard(
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
                  _DashboardCard(
                    icon: Icons.analytics,
                    title: "Summary",
                    color: Colors.indigo,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: const Color(
                            0xFFf5f9ff,
                          ), // soft background
                          titlePadding: const EdgeInsets.all(0),
                          title: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF2193b0),
                                  Color(0xFF6dd5ed),
                                ], // soft blue gradient
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
                              Row(
                                children: [
                                  const Icon(
                                    Icons.local_parking,
                                    color: Colors.blueAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Total Slots: ${parkingProvider.totalSlots}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const Divider(),
                              FutureBuilder<int>(
                                future: parkingProvider.getAvailableSlots(),
                                builder: (context, snapshot) {
                                  return Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Available Slots: ${snapshot.hasData ? snapshot.data : '...'}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const Divider(),
                              FutureBuilder<int>(
                                future: parkingProvider
                                    .getActiveReservationCount(
                                      authProvider.user!.uid,
                                    ),
                                builder: (context, snapshot) {
                                  return Row(
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        color: Colors.deepPurple,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Your Active Reservation: ${snapshot.hasData ? snapshot.data : '...'}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  );
                                },
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
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
