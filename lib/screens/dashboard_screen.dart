import 'package:flutter/material.dart';
import 'study_material_screen.dart';
import 'mock_test_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_logout_screen.dart'; // ఈ లైన్ చాలా ముఖ్యం

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Prep Portal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 28),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileLogoutScreen()),
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.grey.shade50,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              color: Colors.tealAccent,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text('Welcome Back, Aspirant!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Target Score Track: 90% | Tier Status: Alpha', style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context, 
                    title: 'Study Materials', 
                    icon: Icons.menu_book, 
                    color: Colors.blue.shade600,
                    destination: const StudyMaterialScreen(),
                  ),
                  _buildMenuCard(
                    context, 
                    title: 'Mock Tests', 
                    icon: Icons.timer, 
                    color: Colors.orange.shade700,
                    destination: const MockTestScreen(),
                  ),
                  _buildMenuCard(
                    context, 
                    title: 'Leaderboards', 
                    icon: Icons.leaderboard, 
                    color: Colors.purple.shade600,
                    destination: const LeaderboardScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required String title, required IconData icon, required Color color, required Widget destination}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destination)),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 28, backgroundColor: color.withAlpha(38), child: Icon(icon, color: color, size: 28)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}