import 'package:MHike/database_helper.dart';
import 'package:MHike/view/update_observation.dart';
import 'package:MHike/view/view_hikes.dart';
import 'package:MHike/view/view_observations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/Hike.dart';
import '../model/observation.dart';

class ObservationDetailsScreen extends StatefulWidget{
  final Hike hike;
  final Observation observation;

  ObservationDetailsScreen({required this.hike, required this.observation});

  @override
  State<StatefulWidget> createState() => _ObservationDetailsScreenState();
}

class _ObservationDetailsScreenState extends State<ObservationDetailsScreen>{
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Observation Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text("ID: ${widget.observation.id.toString()}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text("Hike ID: ${widget.observation.hikeId.toString()}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text("Title: ${widget.observation.title}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text("Time: ${widget.observation.time}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text("Comment: ${widget.observation.comment}", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
      floatingActionButton:
      Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UpdateObservation(hike: widget.hike, observation: widget.observation),
                      ),
                    );
                  },
                  child: Text("Update"),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Show a confirmation dialog and if confirmed, delete the hike
                      _showDeleteConfirmationDialog(widget.observation.id!, widget.hike);
                    },
                    child: Text("Delete"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ViewObservations(hike: widget.hike),
                        ),
                      );
                    },
                    child: Text("Back to observation list"),
                  ),
                ),
              ],
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

  void _showDeleteConfirmationDialog(int observationId, Hike hike) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete this observation?"),
          actions: <Widget>[
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                // Close the dialog and delete the hike
                Navigator.of(context).pop();
                databaseHelper.deleteObservation(observationId);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ViewObservations(hike: hike),
                  ),
                );

                final snackBar = SnackBar(
                  content: Text('Observation removed successfully.'),
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