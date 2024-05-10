import 'package:MHike/view/view_hikes.dart';
import 'package:flutter/material.dart';

import 'database_helper.dart';

void main() {
  runApp(const HikeActivity());
}

class HikeActivity extends StatelessWidget {
  const HikeActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyBottomNavigationBar(),
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(), ViewHikesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("M-Hike"),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "View Hikes",
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ViewHikesPage(),
              ),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    // Get the screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/m_hike.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 350, // Adjust position from the bottom as needed
            left: 130, // Adjust position from the left as needed
            child: ElevatedButton(
              onPressed: () {
                _showDeleteConfirmationDialog(context);
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(200, 50)), // Set your preferred size
              ),
              child: Text("Reset database"),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to reset the database?"),
          actions: <Widget>[
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                // Close the dialog and clear the database
                Navigator.of(context).pop();
                databaseHelper.deleteAllData();

                final snackBar = SnackBar(
                  content: Text('Database reset successfully.'),
                  duration: Duration(seconds: 5),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                // Handle any further actions after deletion
              },
            ),
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}




