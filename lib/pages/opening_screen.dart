import 'package:flutter/material.dart';
import 'package:testing_pill_pal/pages/choice_page.dart';
import 'package:testing_pill_pal/pages/info_page.dart';

class OpeningScreen extends StatefulWidget {
  OpeningScreen({super.key});

  @override
  _OpeningScreenState createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController with a total duration of 4 seconds
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    // Define a TweenSequence for fade-in (1s) and fade-out (3s)
    _fadeAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0), // Fade-in
        weight: 1, // Represents 1 second of fade-in
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0), // Fade-out
        weight: 3, // Represents 3 seconds of fade-out
      ),
    ]).animate(_controller);

    // Start the animation and navigate to the next screen after it completes
    _controller.forward().then((_) {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ChoicePage()),
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              // const Color.fromARGB(47, 230, 236, 255),
              const Color.fromARGB(44, 192, 203, 251),
              Colors.grey.shade100, // End color
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("BEFORE", style: _textStyle),
                Text("WE", style: _textStyle),
                Text("START", style: _textStyle),
                Text("WE NEED", style: _textStyle),
                Text("SOME", style: _textStyle),
                Text("INFORMATION", style: _textStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Define text style with increased font size
  final TextStyle _textStyle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
}

// Placeholder for the next screen
class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("This is the next screen"),
      ),
    );
  }
}
