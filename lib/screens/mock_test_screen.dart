import 'dart:math';
import 'package:flutter/material.dart';
import '../models/question.dart';
import 'analysis_screen.dart';

class MockTestScreen extends StatefulWidget {
  const MockTestScreen({super.key});

  @override
  State<MockTestScreen> createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen> {
  static final Set<String> _usedQuestionTexts = {};

  int currentIndex = 0;
  int score = 0;
  int? selectedAnswer;
  String? selectedSubject;
  final List<int> userCache = [];
  late List<Map<String, dynamic>> dynamicTestSuite;

  final List<Map<String, dynamic>> absoluteQuestionBank = const [
    {
      'subject': 'Quantitative Aptitude', 
      'text': 'If log₂x + log₄x = 3, solve for the value of x.', 
      'options': ['2', '4', '8', '16'], 
      'correctIndex': 1, 
      'explanation': 'Change base to 4: 2log₄x + log₄x = 3 => 3log₄x = 3 => log₄x = 1 => x = 4.'
    },
    {
      'subject': 'Quantitative Aptitude', 
      'text': 'A sum of money doubles itself at compound interest in 15 years. In how many years will it become eight times itself?', 
      'options': ['30 years', '45 years', '50 years', '60 years'], 
      'correctIndex': 1, 
      'explanation': 'If it becomes 2 times in 15 years, it becomes 2³ (8 times) in 15 * 3 = 45 years.'
    },
    {
      'subject': 'Quantitative Aptitude', 
      'text': 'Two trains 140m and 160m long are running at 60 km/hr and 40 km/hr respectively in opposite directions. Time taken to cross each other is:', 
      'options': ['9 seconds', '10.8 seconds', '12 seconds', '15 seconds'], 
      'correctIndex': 1, 
      'explanation': 'Relative speed = 60 + 40 = 100 km/hr = 100 * 5/18 = 250/9 m/s. Total distance = 140 + 160 = 300m. Time = 300 / (250/9) = 10.8 seconds.'
    },
    {
      'subject': 'Quantitative Aptitude', 
      'text': 'Find the unit digit in the product (2467)¹⁵³ × (341)⁷².', 
      'options': ['1', '3', '7', '9'], 
      'correctIndex': 2, 
      'explanation': 'Unit digit of 341⁷² is 1. Cyclicity of 7 is 4. 153 divided by 4 leaves remainder 1. 7¹ = 7. 7 × 1 = 7.'
    },
    {
      'subject': 'Quantitative Aptitude', 
      'text': 'A pipe can fill a cistern in 8 hours and another pipe can empty it in 16 hours. If both open together, the cistern fills in:', 
      'options': ['10 hours', '12 hours', '14 hours', '16 hours'], 
      'correctIndex': 3, 
      'explanation': 'Net work per hour = 1/8 - 1/16 = 1/16. Hence, it requires 16 hours to fill fully.'
    },
    {
      'subject': 'Logical Reasoning', 
      'text': 'Identify the odd element out of the structural arrangement sequencing group.', 
      'options': ['343', '512', '729', '1000'], 
      'correctIndex': 2, 
      'explanation': '729 is both a perfect cube (9³) and a perfect square (27²), while others are only perfect cubes.'
    },
    {
      'subject': 'Logical Reasoning', 
      'text': 'If CLOCK is coded as KCOLC, how will STEPS be written in that coding format pattern?', 
      'options': ['SPETS', 'SPSET', 'STPES', 'SEPTS'], 
      'correctIndex': 0, 
      'explanation': 'The structural letters are exactly reversed in sequencing orientation.'
    },
    {
      'subject': 'Logical Reasoning', 
      'text': 'Pointing to a photograph, a man said, "I have no brother or sister but that man\'s father is my father\'s son." Whose photograph was it?', 
      'options': ['His own', 'His son\'s', 'His father\'s', 'His nephew\'s'], 
      'correctIndex': 1, 
      'explanation': '"My father\'s son" with no siblings means himself. So, the man\'s father is himself, making the photograph his son\'s.'
    },
    {
      'subject': 'Logical Reasoning', 
      'text': 'Look at the series: 7, 10, 8, 11, 9, 12, ... What number should come next?', 
      'options': ['7', '10', '12', '13'], 
      'correctIndex': 1, 
      'explanation': 'Alternating patterns: (+3, -2, +3, -2...). 12 - 2 = 10.'
    },
    {
      'subject': 'Logical Reasoning', 
      'text': 'In a row of trees, one tree is 7th from either end of the row. How many trees are there in the row?', 
      'options': ['11', '13', '14', '15'], 
      'correctIndex': 1, 
      'explanation': 'Rank from left + Rank from right - 1 = 7 + 7 - 1 = 13 trees.'
    },
    {
      'subject': 'Verbal Ability', 
      'text': 'Choose the word closest in semantic definition path to "Pragmatic".', 
      'options': ['Idealistic', 'Practical', 'Theoretical', 'Irrational'], 
      'correctIndex': 1, 
      'explanation': 'Pragmatic means handling things sensibly and realistically based on practical conditions.'
    },
    {
      'subject': 'Verbal Ability', 
      'text': 'Select the word that is most opposite in meaning to "Frugal".', 
      'options': ['Economical', 'Extravagant', 'Miserly', 'Splendid'], 
      'correctIndex': 1, 
      'explanation': 'Frugal means sparing or economical regarding money; its exact opposite is extravagant.'
    },
    {
      'subject': 'Verbal Ability', 
      'text': 'Identify the correctly spelled word out of the following option vectors.', 
      'options': ['Comittee', 'Committee', 'Commitee', 'Comitee'], 
      'correctIndex': 1, 
      'explanation': 'The correct lexical assembly spelling is "Committee" (double m, double t, double e).'
    },
    {
      'subject': 'Verbal Ability', 
      'text': 'Find the synonym of the word: "Transient"', 
      'options': ['Permanent', 'Temporary', 'Endless', 'Significant'], 
      'correctIndex': 1, 
      'explanation': 'Transient means lasting only for a short time; temporary.'
    },
    {
      'subject': 'Verbal Ability', 
      'text': 'What is the meaning of the idiom: "To burn the midnight oil"', 
      'options': ['To waste resources', 'To work late into the night', 'To light up a dark room', 'To wake up early'], 
      'correctIndex': 1, 
      'explanation': 'This historical idiom refers to studying or working late into the night by the light of an oil lamp.'
    },
    {
      'subject': 'Quantitative Aptitude',
      'text': 'The average of five numbers is 18. What is their sum?',
      'options': ['80', '90', '95', '100'],
      'correctIndex': 1,
      'explanation': 'Sum = average * number of values = 18 * 5 = 90.'
    },
    {
      'subject': 'Quantitative Aptitude',
      'text': 'A shopkeeper buys an article for Rs. 80 and sells it for Rs. 100. What is the profit percentage?',
      'options': ['20%', '25%', '30%', '40%'],
      'correctIndex': 1,
      'explanation': 'Profit = 100 - 80 = Rs. 20. Profit percentage = 20 / 80 * 100 = 25%.'
    },
    {
      'subject': 'Quantitative Aptitude',
      'text': 'If 3x + 5 = 20, what is the value of x?',
      'options': ['3', '5', '6', '15'],
      'correctIndex': 1,
      'explanation': '3x = 20 - 5 = 15, so x = 5.'
    },
    {
      'subject': 'Quantitative Aptitude',
      'text': 'A car travels 240 km in 4 hours. What is its average speed?',
      'options': ['50 km/hr', '60 km/hr', '80 km/hr', '96 km/hr'],
      'correctIndex': 1,
      'explanation': 'Average speed = distance / time = 240 / 4 = 60 km/hr.'
    },
    {
      'subject': 'Quantitative Aptitude',
      'text': 'What is the simple interest on Rs. 1,000 at 10% per year for 2 years?',
      'options': ['Rs. 100', 'Rs. 200', 'Rs. 300', 'Rs. 400'],
      'correctIndex': 1,
      'explanation': 'Simple interest = principal * rate * time / 100 = 1000 * 10 * 2 / 100 = Rs. 200.'
    },
    {
      'subject': 'Logical Reasoning',
      'text': 'Complete the series: 2, 6, 12, 20, 30, ...',
      'options': ['40', '42', '44', '46'],
      'correctIndex': 1,
      'explanation': 'The differences are 4, 6, 8, 10, so the next difference is 12 and the next term is 42.'
    },
    {
      'subject': 'Logical Reasoning',
      'text': 'Which number does not belong: 2, 4, 8, 12, 16?',
      'options': ['2', '4', '12', '16'],
      'correctIndex': 2,
      'explanation': 'All numbers except 12 are powers of 2 multiples based on consecutive powers; 12 breaks that pattern.'
    },
    {
      'subject': 'Logical Reasoning',
      'text': 'All roses are flowers. Some flowers fade quickly. Which statement is certain?',
      'options': ['All roses fade quickly', 'Some roses fade quickly', 'No roses fade quickly', 'Some roses are flowers'],
      'correctIndex': 3,
      'explanation': 'Since all roses are flowers, it is certain that some roses are flowers.'
    },
    {
      'subject': 'Logical Reasoning',
      'text': 'If A is taller than B and B is taller than C, who is shortest?',
      'options': ['A', 'B', 'C', 'Cannot determine'],
      'correctIndex': 2,
      'explanation': 'The height order is A > B > C, so C is shortest.'
    },
    {
      'subject': 'Logical Reasoning',
      'text': 'Which pair is most different? Tiger : Stripes :: Dog : ?',
      'options': ['Bark', 'Pet', 'Animal', 'Paws'],
      'correctIndex': 0,
      'explanation': 'Stripes identify a common tiger feature, while bark identifies a common dog action.'
    },
    {
      'subject': 'Verbal Ability',
      'text': 'Choose the synonym of "Diligent".',
      'options': ['Careless', 'Hardworking', 'Slow', 'Lazy'],
      'correctIndex': 1,
      'explanation': 'Diligent means careful and hardworking.'
    },
    {
      'subject': 'Verbal Ability',
      'text': 'Choose the antonym of "Ancient".',
      'options': ['Old', 'Historic', 'Modern', 'Traditional'],
      'correctIndex': 2,
      'explanation': 'Ancient refers to something very old, while modern refers to the present or recent time.'
    },
    {
      'subject': 'Verbal Ability',
      'text': 'Select the correctly spelled word.',
      'options': ['Necessary', 'Neccessary', 'Necesary', 'Necessery'],
      'correctIndex': 0,
      'explanation': 'The correct spelling is "Necessary".'
    },
    {
      'subject': 'Verbal Ability',
      'text': 'Choose the word that best completes the sentence: She spoke very ___ during the interview.',
      'options': ['confidently', 'confident', 'confidence', 'confiding'],
      'correctIndex': 0,
      'explanation': '"Confidently" is the adverb needed to describe how she spoke.'
    },
    {
      'subject': 'Verbal Ability',
      'text': 'What is the meaning of the idiom "Once in a blue moon"?',
      'options': ['Very often', 'Every night', 'Very rarely', 'During winter'],
      'correctIndex': 2,
      'explanation': 'The idiom "once in a blue moon" means very rarely.'
    },
    {
      'subject': 'Quantitative Aptitude',
      'text': 'What is 15 percent of 200?',
      'options': ['20', '30', '35', '40'],
      'correctIndex': 1,
      'explanation': '15 percent of 200 is 200 * 15 / 100 = 30.'
    },
    {
      'subject': 'Quantitative Aptitude',
      'text': 'The ratio of two numbers is 3:4 and their sum is 35. What is the larger number?',
      'options': ['15', '20', '21', '28'],
      'correctIndex': 1,
      'explanation': 'Divide 35 into 7 parts; each part is 5 and the larger number is 4 * 5 = 20.'
    },
    {
      'subject': 'Quantitative Aptitude',
      'text': 'A number when increased by 20 percent becomes 60. What was the number?',
      'options': ['48', '50', '52', '54'],
      'correctIndex': 1,
      'explanation': '1.2 times the number is 60, so the number is 60 / 1.2 = 50.'
    },
    {
      'subject': 'Quantitative Aptitude',
      'text': 'Find the HCF of 18 and 24.',
      'options': ['3', '6', '9', '12'],
      'correctIndex': 1,
      'explanation': 'The largest number that divides both 18 and 24 is 6.'
    },
    {
      'subject': 'Quantitative Aptitude',
      'text': 'How many seconds are there in 2 hours?',
      'options': ['3600', '7200', '10800', '12000'],
      'correctIndex': 1,
      'explanation': '2 hours contain 2 * 60 * 60 = 7200 seconds.'
    },
    {
      'subject': 'Quantitative Aptitude',
      'text': 'The perimeter of a square is 36 cm. What is its area?',
      'options': ['81 sq cm', '64 sq cm', '72 sq cm', '100 sq cm'],
      'correctIndex': 0,
      'explanation': 'Each side is 36 / 4 = 9 cm, so the area is 9 * 9 = 81 sq cm.'
    },
    {
      'subject': 'Quantitative Aptitude',
      'text': 'What is the next number: 3, 6, 12, 24, ...?',
      'options': ['36', '48', '72', '96'],
      'correctIndex': 1,
      'explanation': 'Each number is multiplied by 2, so the next number is 24 * 2 = 48.'
    },
    {
      'subject': 'Quantitative Aptitude',
      'text': 'If 7 pencils cost Rs. 35, how much do 12 pencils cost?',
      'options': ['Rs. 50', 'Rs. 60', 'Rs. 70', 'Rs. 84'],
      'correctIndex': 1,
      'explanation': 'One pencil costs Rs. 5; 12 pencils cost 12 * 5 = Rs. 60.'
    },
    {
      'subject': 'Quantitative Aptitude',
      'text': 'Simplify: 12 * 5 - 20.',
      'options': ['40', '50', '60', '80'],
      'correctIndex': 0,
      'explanation': '12 * 5 = 60, and 60 - 20 = 40.'
    },
    {
      'subject': 'Quantitative Aptitude',
      'text': 'A triangle has angles 40 degrees and 60 degrees. What is the third angle?',
      'options': ['80 degrees', '70 degrees', '90 degrees', '100 degrees'],
      'correctIndex': 0,
      'explanation': 'The sum of angles in a triangle is 180 degrees, so the third angle is 180 - 40 - 60 = 80 degrees.'
    },
    {
      'subject': 'Logical Reasoning',
      'text': 'Find the next term: 1, 4, 9, 16, ...',
      'options': ['20', '25', '24', '36'],
      'correctIndex': 1,
      'explanation': 'These are the squares of 1, 2, 3, 4; the next is 5 squared, or 25.'
    },
    {
      'subject': 'Logical Reasoning',
      'text': 'Which letter comes next: A, C, E, G, ...?',
      'options': ['H', 'I', 'J', 'K'],
      'correctIndex': 1,
      'explanation': 'The letters increase by two positions each time, so G is followed by I.'
    },
    {
      'subject': 'Logical Reasoning',
      'text': 'If APPLE is coded as 50 using its letter positions, what code represents CAT?',
      'options': ['24', '25', '26', '27'],
      'correctIndex': 0,
      'explanation': 'Letter position values are C=3, A=1 and T=20, giving a sum of 24.'
    },
    {
      'subject': 'Logical Reasoning',
      'text': 'Monday is 3 days before Thursday. What day is 2 days after Friday?',
      'options': ['Saturday', 'Sunday', 'Monday', 'Tuesday'],
      'correctIndex': 1,
      'explanation': 'Two days after Friday is Sunday.'
    },
    {
      'subject': 'Logical Reasoning',
      'text': 'In a family of four, each person has exactly one brother and one sister. How many sons and daughters are there?',
      'options': ['2 sons, 2 daughters', '1 son, 3 daughters', '3 sons, 1 daughter', 'Cannot determine'],
      'correctIndex': 0,
      'explanation': 'Two brothers and two sisters satisfy each person having one sibling of each gender.'
    },
    {
      'subject': 'Logical Reasoning',
      'text': 'Find the odd one out: Circle, Square, Triangle, Cube.',
      'options': ['Circle', 'Square', 'Triangle', 'Cube'],
      'correctIndex': 3,
      'explanation': 'Circle, square and triangle are two-dimensional shapes; cube is three-dimensional.'
    },
    {
      'subject': 'Logical Reasoning',
      'text': 'Complete: 3, 8, 15, 24, ...',
      'options': ['33', '35', '36', '39'],
      'correctIndex': 1,
      'explanation': 'The differences are 5, 7, 9, so the next difference is 11 and the result is 35.'
    },
    {
      'subject': 'Logical Reasoning',
      'text': 'All doctors are educated. Raj is a doctor. Which conclusion follows?',
      'options': ['Raj is educated', 'Raj is a surgeon', 'Raj is rich', 'All educated people are doctors'],
      'correctIndex': 0,
      'explanation': 'Because Raj belongs to the class of doctors and all doctors are educated, Raj is educated.'
    },
    {
      'subject': 'Logical Reasoning',
      'text': 'What comes next in 5, 10, 20, 40, ...?',
      'options': ['60', '70', '80', '100'],
      'correctIndex': 2,
      'explanation': 'Each term is twice the preceding term, so the next is 80.'
    },
    {
      'subject': 'Logical Reasoning',
      'text': 'Book is to reading as fork is to ...',
      'options': ['Cooking', 'Eating', 'Drawing', 'Writing'],
      'correctIndex': 1,
      'explanation': 'A book is used for reading and a fork is used for eating.'
    },
    {
      'subject': 'Verbal Ability',
      'text': 'Choose the synonym of "Brave".',
      'options': ['Fearful', 'Timid', 'Courageous', 'Weak'],
      'correctIndex': 2,
      'explanation': 'Brave means courageous.'
    },
    {
      'subject': 'Verbal Ability',
      'text': 'Choose the antonym of "Victory".',
      'options': ['Success', 'Win', 'Defeat', 'Prize'],
      'correctIndex': 2,
      'explanation': 'Defeat is the opposite of victory.'
    },
    {
      'subject': 'Verbal Ability',
      'text': 'Select the correctly spelled word.',
      'options': ['Accomodate', 'Acommodate', 'Accommodate', 'Accommadate'],
      'correctIndex': 2,
      'explanation': 'The correct spelling is "Accommodate".'
    },
    {
      'subject': 'Verbal Ability',
      'text': 'Choose the correct form: The team ___ playing well.',
      'options': ['is', 'are', 'be', 'were'],
      'correctIndex': 0,
      'explanation': 'A team is treated as a singular collective noun here, so "is" is correct.'
    },
    {
      'subject': 'Verbal Ability',
      'text': 'Choose the meaning of "benevolent".',
      'options': ['Kind', 'Angry', 'Greedy', 'Careless'],
      'correctIndex': 0,
      'explanation': 'Benevolent means kind, generous and willing to help others.'
    },
    {
      'subject': 'Verbal Ability',
      'text': 'Choose the synonym of "Rapid".',
      'options': ['Slow', 'Quick', 'Weak', 'Calm'],
      'correctIndex': 1,
      'explanation': 'Rapid means happening quickly.'
    },
    {
      'subject': 'Verbal Ability',
      'text': 'Choose the opposite of "Expand".',
      'options': ['Grow', 'Increase', 'Contract', 'Extend'],
      'correctIndex': 2,
      'explanation': 'Contract means reduce or decrease, the opposite of expand.'
    },
    {
      'subject': 'Verbal Ability',
      'text': 'Complete the sentence: The sun ___ in the east.',
      'options': ['rise', 'rises', 'rising', 'risen'],
      'correctIndex': 1,
      'explanation': 'With the singular subject "sun", the present tense verb is "rises".'
    },
    {
      'subject': 'Verbal Ability',
      'text': 'What is the plural of "child"?',
      'options': ['Childs', 'Children', 'Childrens', 'Childes'],
      'correctIndex': 1,
      'explanation': 'The irregular plural form of "child" is "children".'
    },
    {
      'subject': 'Verbal Ability',
      'text': 'Choose the correct meaning of "obsolete".',
      'options': ['Modern', 'Outdated', 'Useful', 'Expensive'],
      'correctIndex': 1,
      'explanation': 'Obsolete means no longer in use or outdated.'
    }
  ];

  @override
  void initState() {
    super.initState();
  }

  void _initializeRandomizedTest() {
    var availableQuestions = absoluteQuestionBank
        .where((question) => question['subject'] == selectedSubject)
        .where((question) => !_usedQuestionTexts.contains(question['text'] as String))
        .toList();

    if (availableQuestions.length < 20) {
      _usedQuestionTexts.clear();
      availableQuestions = List<Map<String, dynamic>>.from(absoluteQuestionBank);
    }

    availableQuestions.shuffle(Random());
    dynamicTestSuite = availableQuestions.take(20).toList();
    _usedQuestionTexts.addAll(
      dynamicTestSuite.map((question) => question['text'] as String),
    );
    currentIndex = 0;
    score = 0;
    selectedAnswer = null;
    userCache.clear();
  }

  void _startSubjectTest(String subject) {
    setState(() {
      selectedSubject = subject;
      _initializeRandomizedTest();
    });
  }

  Widget _buildSubjectSelection() {
    final subjects = [
      (
        'Quantitative Aptitude',
        Icons.calculate,
        Colors.blue.shade700,
      ),
      (
        'Logical Reasoning',
        Icons.psychology,
        Colors.orange.shade800,
      ),
      (
        'Verbal Ability',
        Icons.menu_book,
        Colors.purple.shade700,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Mock Test'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Select a subject',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Each mock test contains 20 questions.'),
          const SizedBox(height: 20),
          for (final subject in subjects)
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: subject.$3.withAlpha(38),
                  child: Icon(subject.$2, color: subject.$3),
                ),
                title: Text(
                  subject.$1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('20 questions'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _startSubjectTest(subject.$1),
              ),
            ),
        ],
      ),
    );
  }

  void advanceQuestion() {
    if (selectedAnswer == null) return;
    userCache.add(selectedAnswer!);
    if (selectedAnswer == dynamicTestSuite[currentIndex]['correctIndex']) score++;

    if (currentIndex < dynamicTestSuite.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswer = null;
      });
    } else {
      final List<Question> compatibleModelList = dynamicTestSuite.map((item) {
        return Question(
          text: '[${item['subject']}] ${item['text']}',
          options: List<String>.from(item['options']),
          correctIndex: item['correctIndex'] as int,
          explanation: item['explanation'] as String,
        );
      }).toList();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AnalysisScreen(
            score: score, 
            total: dynamicTestSuite.length, 
            questions: compatibleModelList, 
            userAnswers: userCache,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedSubject == null) {
      return _buildSubjectSelection();
    }

    final q = dynamicTestSuite[currentIndex];
    
    Color subjectBadgeColor = Colors.teal;
    if (q['subject'] == 'Quantitative Aptitude') subjectBadgeColor = Colors.blue.shade700;
    if (q['subject'] == 'Logical Reasoning') subjectBadgeColor = Colors.orange.shade800;
    if (q['subject'] == 'Verbal Ability') subjectBadgeColor = Colors.purple.shade700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Mock Test'), 
        backgroundColor: Colors.orange.shade700, 
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (currentIndex + 1) / dynamicTestSuite.length, 
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    q['subject'] as String, 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  backgroundColor: subjectBadgeColor,
                ),
                Text(
                  'Question ${currentIndex + 1} of ${dynamicTestSuite.length}', 
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              q['text'] as String, 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...List.generate((q['options'] as List).length, (idx) {
              return Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: selectedAnswer == idx ? Colors.orange : Colors.transparent, 
                    width: 2,
                  ), 
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RadioGroup<int>(
                  groupValue: selectedAnswer,
                  onChanged: (int? v) {
                    setState(() {
                      selectedAnswer = v;
                    });
                  },
                  child: RadioListTile<int>(
                    title: Text(q['options'][idx] as String),
                    value: idx,
                  ),
                ),
              );
            }),
            const Spacer(),
            FilledButton(
              onPressed: advanceQuestion,
              child: Text(
                currentIndex == dynamicTestSuite.length - 1
                    ? 'Submit Test'
                    : 'Next Question',
              ),
            ),
          ],
        ),
      ),
    );
  }
}