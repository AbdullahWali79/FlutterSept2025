

import 'package:flutter/material.dart';

void main() => runApp(ProfileApp());

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String name = 'Muhammad Abdullah';
  final String email = 'abdullahwale@gmail.com';
  final String phone = '+923046983794';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile App'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('images/abdullah.png'),
              ),
              SizedBox(height: 16),
              Text(
                name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
              ),
              SizedBox(height: 8),
              Text(
                email,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                phone,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}















// import 'package:flutter/material.dart';
//
// void main() => runApp(ProfileApp());
//
// class ProfileApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ProfilePage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   final String name = 'Muhammad Abdullah';
//   final String email = 'abdullahwale@gmail.com';
//   final String phone = '+923046983794';
//
//   int selectedTheme = 0; // 0: default, 1: gradient, 2: color scheme
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile App'),
//       ),
//       body: Container(
//         decoration: _getBackgroundDecoration(),
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               // Row Widget - 3 Gradient Buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _buildGradientButton(
//                     'Default',
//                     [Colors.blue, Colors.purple],
//                     0,
//                   ),
//                   _buildGradientButton(
//                     'Gradient',
//                     [Colors.orange, Colors.red],
//                     1,
//                   ),
//                   _buildGradientButton(
//                     'Color Scheme',
//                     [Colors.green, Colors.teal],
//                     2,
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//
//               // Stack Widget - Simple example
//               Stack(
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundImage: AssetImage('images/abdullah.png'),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       width: 20,
//                       height: 20,
//                       color: Colors.green,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//
//               // Column Widget - Simple example
//               Column(
//                 children: [
//                   Text(
//                     name,
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     email,
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   Text(
//                     phone,
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//
//               // ListView Widget - Simple example
//               Container(
//                 height: 150,
//                 child: ListView(
//                   children: [
//                     Text('Flutter Development'),
//                     Text('Mobile App Development'),
//                     Text('Web Development'),
//                     Text('Database Management'),
//                     Text('UI/UX Design'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGradientButton(String text, List<Color> colors, int themeIndex) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedTheme = themeIndex;
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: colors,
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   BoxDecoration _getBackgroundDecoration() {
//     switch (selectedTheme) {
//       case 1: // Gradient theme
//         return BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.purple, Colors.blue, Colors.teal],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         );
//       case 2: // Color scheme theme
//         return BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.orange, Colors.pink, Colors.red],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         );
//       default: // Default theme
//         return BoxDecoration(
//           color: Colors.white,
//         );
//     }
//   }
// }