import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(DiceApp());
}

class DiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Extended Dice App",
      debugShowCheckedModeBanner: false,

      // 🌈 Theme
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),

      home: DiceScreen(),
    );
  }
}

class DiceScreen extends StatefulWidget {
  @override
  _DiceScreenState createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> {
  int diceNumber = 1;
  final TextEditingController _guessController = TextEditingController();
  String message = "";

  void rollDice() {
    setState(() {
      diceNumber = Random().nextInt(6) + 1;

      // Check guess if provided
      if (_guessController.text.isNotEmpty) {
        int? guess = int.tryParse(_guessController.text);
        if (guess != null && guess == diceNumber) {
          message = "🎉 Correct Guess! It's $diceNumber";
        } else {
          message = "❌ Wrong Guess! It's $diceNumber";
        }
      } else {
        message = "You rolled a $diceNumber";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 👆 Gesture Detection: tap background to close keyboard
      onTap: () => FocusScope.of(context).unfocus(),

      child: Scaffold(
        appBar: AppBar(
          title: Text("🎲 Dice Roller"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  diceNumber = 1;
                  message = "";
                  _guessController.clear();
                });
              },
            ),
          ],
        ),

        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // 📝 Input Field for Guess
              TextField(
                controller: _guessController,
                decoration: InputDecoration(
                  labelText: "Enter your guess (1-6)",
                  prefixIcon: Icon(Icons.numbers),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),

              // 🎲 Dice Image with Gesture
              GestureDetector(
                onTap: rollDice, // Tap the dice to roll
                child: Image.asset(
                  "assets/images/$diceNumber.png", // add dice images in assets
                  height: 150,
                ),
              ),
              SizedBox(height: 20),

              // 🚀 Button to Roll Dice
              ElevatedButton.icon(
                onPressed: rollDice,
                icon: Icon(Icons.casino),
                label: Text("Roll Dice"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
              SizedBox(height: 20),

              // 📢 Result / Guess Message
              Text(
                message,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Perfect! 🚀 Let’s extend the Dice App so that it covers all your required topics:
//
// Buttons → To roll the dice
//
// TextFields → User enters a guess (1–6)
//
// Gesture Detection → Tap the dice image to roll
//
// Styling & Themes → Colors, AppBar theme
//
// Custom Fonts → For title and score text
//
// Icons → Use refresh and send icons