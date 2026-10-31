import 'package:flutter/material.dart';
import '../models/material_item.dart';

class StudyMaterialScreen extends StatelessWidget {
  const StudyMaterialScreen({super.key});

  final List<MaterialItem> database = const [
    MaterialItem(category: 'Quantitative', title: 'Permutations & Combinations', content: 'Core Concepts:\n• Fundamental counting principal.\n• nPr = n! / (n-r)!\n• nCr = n! / (r!(n-r)!)'),
    MaterialItem(category: 'Logical Reasoning', title: 'Syllogisms & Logical Inferences', content: 'Rules:\n• A universal positive statement distributes the subject.\n• No valid conclusion can be drawn from two negative premises.'),
    MaterialItem(category: 'Verbal Ability', title: 'Reading Comprehension Strategies', content: 'Key Frameworks:\n• Skimming for tone context vs. scanning for dates and strict nouns.\n• Deduce implicit arguments via elimination.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Materials'), backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: database.length,
        itemBuilder: (context, index) {
          final item = database[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: ExpansionTile(
              leading: Chip(label: Text(item.category), backgroundColor: Colors.blue.shade50),
              title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(item.content, style: const TextStyle(fontSize: 14, height: 1.5)),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
