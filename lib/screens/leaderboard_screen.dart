import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  final List<Map<String, dynamic>> ranks = const [
    {'rank': 1, 'name': 'Aravind Sharma', 'score': 98, 'tier': 'Gold'},
    {'rank': 2, 'name': 'Priya Patel', 'score': 95, 'tier': 'Gold'},
    {'rank': 3, 'name': 'Rahul Verma', 'score': 92, 'tier': 'Gold'},
    {'rank': 4, 'name': 'Sneha Reddy', 'score': 88, 'tier': 'Silver'},
    {'rank': 5, 'name': 'Amit Mishra', 'score': 85, 'tier': 'Silver'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Global Leaderboard'), backgroundColor: Colors.purple.shade600, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ranks.length,
        itemBuilder: (context, index) {
          final row = ranks[index];
          final bool topThree = row['rank'] <= 3;
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: topThree ? Colors.amber : Colors.purple.shade50,
                child: Text('#${row['rank']}', style: TextStyle(color: topThree ? Colors.black : Colors.purple, fontWeight: FontWeight.bold)),
              ),
              title: Text(row['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Tier Track Rank: ${row['tier']}'),
              trailing: Text('${row['score']}%', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple)),
            ),
          );
        },
      ),
    );
  }
}
