import 'package:MHike/database_helper.dart';
import 'package:MHike/view/add_observation.dart';
import 'package:MHike/view/hike_details.dart';
import 'package:MHike/view/observation_details.dart';
import 'package:MHike/view/view_hikes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/Hike.dart';
import '../model/observation.dart';

class ViewObservations extends StatefulWidget {
  final Hike hike;

  ViewObservations({required this.hike});

  @override
  State<StatefulWidget> createState() => _ViewObservationsPage();
}

class _ViewObservationsPage extends State<ViewObservations> {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  List<Observation> observations = []; // Replace this with your actual list of observations

  @override
  void initState() {
    super.initState();
    loadObservations();
  }

  Future<void> loadObservations() async {
    List<Observation> loadedObservations = await databaseHelper.getObservationsByHike(widget.hike.id!);
    setState(() {
      observations = loadedObservations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Observations for hike ID: ${widget.hike.id.toString()}"),
      ),
      body: Padding (
          padding: EdgeInsets.symmetric(horizontal: 15), // Set left and right margins to 5
          child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Title", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,)),
                Text("Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Text("Action", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: observations.length,
                itemBuilder: (context, index) {
                  final observation = observations[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 120, // Set the desired width for the Text widget
                        child: Text(
                          observation.title,
                          overflow: TextOverflow.ellipsis, // Handle text overflow if the text is too long
                        ),
                      ),
                      Container(
                        width: 180, // Set the desired width for the ElevatedButton
                        child: Text(
                          observation.time,
                          overflow: TextOverflow.ellipsis, // Handle text overflow if the text is too long
                        ),
                      ),
                      Container(
                        width: 80, // Set the desired width for the ElevatedButton
                        child: ElevatedButton(
                          onPressed: () async {
                            // Ensure hike.id is not null
                            if (observation.id != null) {
                              Observation? selectedObservation = await databaseHelper.viewObservationById(observation.id!);
                              if (selectedObservation != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ObservationDetailsScreen(
                                      hike: widget.hike,
                                      observation: selectedObservation,
                                    ),
                                  ),
                                );
                              } else {
                                // Handle the case when the hike with the given ID is not found
                              }
                            }
                          },
                          child: Text("View"),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddObservation(hike: widget.hike),
                  ),
                );
              },
              child: Text("Add new observation"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HikeDetailsScreen(hike: widget.hike),
                  ),
                );
              },
              child: Text("Back to hike details"),
            ),
          ]
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
}
