import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatelessWidget {
  const StartScreen(this.startQuiz, {super.key});

  final void Function() startQuiz;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to Quiz App!',
            style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Image.asset(
            "assets/images/quiz-logo.png",
            width: 300,
            color: Colors.amberAccent,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: startQuiz,
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 63, 6, 6),
            ),
            icon: const Icon(Icons.arrow_right_alt),
            label: const Text('Get Started'),
          ),
        ],
      ),
    );
  }
}
