import 'package:flutter/material.dart';
import 'dart:math';

/// The main entry point for the application.
/// In Flutter, the `main` function is where your app starts.
void main() {
  // `runApp` takes the given Widget and makes it the root of the widget tree.
  // Here, `DiceApp` is our root widget.
  runApp(DiceApp());
}

/// The root widget of the Dice Application.
/// `DiceApp` is a `StatelessWidget` because its properties don't change over time.
/// All its state is contained in other widgets.
class DiceApp extends StatelessWidget {
  // The `build` method describes the part of the user interface represented by this widget.
  // Flutter calls this method when this widget is inserted into the tree.
  @override
  Widget build(BuildContext context) {
    // `MaterialApp` is a predefined class in Flutter.
    // It provides many functionalities like routing, theming, etc.
    // It's generally the root widget of a Material Design app.
    return MaterialApp(
      // `title` is a one-line description used by the device to identify the app.
      title: "Extended Dice App",
      // `debugShowCheckedModeBanner` removes the "debug" banner in the top-right corner when set to false.
      debugShowCheckedModeBanner: false,

      // `theme` defines the visual appearance of your application.
      // `ThemeData` allows you to customize colors, fonts, and more.
      theme: ThemeData(
        // `primarySwatch` defines a single color that Flutter uses to generate shades for the theme.
        // `Colors.deepPurple` is a predefined Material color.
        primarySwatch: Colors.deepPurple,


      ),

      // `home` is the widget that will be displayed first when the app starts.
      // Here, we are setting `DiceScreen` as our home screen.
      home: DiceScreen(),
    );
  }
}

/// A screen that displays a dice and allows the user to roll it.
class DiceScreen extends StatefulWidget {
  @override
  _DiceScreenState createState() => _DiceScreenState();
}

/// The state for the [DiceScreen] widget.
class _DiceScreenState extends State<DiceScreen> {
  /// The current number displayed on the dice.
  int diceNumber = 1;
  /// Controller for the guess input field.
  final TextEditingController _guessController = TextEditingController();
  /// Message to display to the user (e.g., result of a guess or roll).
  String message = "";
  
  /// The currently selected font for various text elements.
  String selectedFont = "Default";
  /// List of available font options for the user to select.
  final List<Map<String, String>> fontOptions = [
    {"name": "Default", "family": ""},
    {"name": "Roboto", "family": "Roboto"},
    {"name": "Open Sans", "family": "OpenSans"},
    {"name": "Lato", "family": "Lato"},
    {"name": "Montserrat", "family": "Montserrat"},
    {"name": "Arial", "family": "Arial"},
    {"name": "Times New Roman", "family": "Times New Roman"},
    {"name": "Courier New", "family": "Courier New"},
  ];

  /// Helper method to get the current font family string.
  /// Returns the font family string or null if the default font is selected.
  String? getCurrentFontFamily() {
    //The question mark ? after String in String? getCurrentFontFamily() means that this function can return either a String or null.
    final font = fontOptions.firstWhere((font) => font["name"] == selectedFont);
    return font["family"]!.isNotEmpty ? font["family"] : null;
  }

  /// Rolls the dice, updates the [diceNumber], and checks the user's guess.
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
          title: Text(
            "🎲 Dice Roller",
            style: TextStyle(
              fontFamily: getCurrentFontFamily(),
            ),
          ),
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

              // 🎨 Font Selection Dropdown
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: selectedFont,
                  isExpanded: true,
                  underline: SizedBox(),
                  items: fontOptions.map((font) {
                    return DropdownMenuItem<String>(
                      value: font["name"],
                      child: Text(
                        "Font: ${font['name']}",
                        style: TextStyle(
                          fontFamily: font["family"]!.isNotEmpty ? font["family"] : null,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFont = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),

              // 📝 Input Field for Guess
              TextField(
                controller: _guessController,
                style: TextStyle(
                  fontFamily: getCurrentFontFamily(),
                ),
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
                label: Text(
                  "Roll Dice",
                  style: TextStyle(
                    fontFamily: getCurrentFontFamily(),
                  ),
                ),
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
                  fontFamily: getCurrentFontFamily(),
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
