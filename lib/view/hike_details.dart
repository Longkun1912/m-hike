import 'package:MHike/view/update_hike.dart';
import 'package:MHike/view/view_hikes.dart';
import 'package:MHike/view/view_observations.dart';
import 'package:flutter/material.dart';

import '../database_helper.dart';
import '../model/Hike.dart';
import '../model/observation.dart';

class HikeDetailsScreen extends StatefulWidget {
  final Hike hike;

  HikeDetailsScreen({required this.hike});

  @override
  _HikeDetailsScreenState createState() => _HikeDetailsScreenState();
}

class _HikeDetailsScreenState extends State<HikeDetailsScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  List<Observation> observations = []; // List to store observations

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hike Details"),
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text("ID: ${widget.hike.id.toString()}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text("Name: ${widget.hike.name}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text("Location: ${widget.hike.location}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text("Date: ${widget.hike.date}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text("Parking: ${widget.hike.parking}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text("Length: ${widget.hike.length}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text("Difficulty: ${widget.hike.difficulty}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text("Description: ${widget.hike.description}", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ViewObservations(hike: widget.hike),
                  ),
                );
              },
              child: Text("View observations"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UpdateHike(hike: widget.hike),
                  ),
                );
              },
              child: Text("Update"),
            ),
            ElevatedButton(
              onPressed: () {
                // Show a confirmation dialog and if confirmed, delete the hike
                _showDeleteConfirmationDialog(widget.hike.id!);
              },
              child: Text("Delete"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ViewHikesPage(),
                  ),
                );
              },
              child: Text("Back to hike list"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Set the index for the "View Hikes" tab
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
          if (index == 0) {
            // Navigate to the "Home" page
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            // Navigate to the "View Hikes" page
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ViewHikesPage(),
              ),
            );
          }
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(int hikeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete this hike?"),
          actions: <Widget>[
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                // Close the dialog and delete the hike
                Navigator.of(context).pop();
                databaseHelper.deleteHike(hikeId);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ViewHikesPage(),
                  ),
                );

                final snackBar = SnackBar(
                  content: Text('Hike removed successfully.'),
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
