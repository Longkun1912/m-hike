import 'package:MHike/model/observation.dart';
import 'package:MHike/view/view_hikes.dart';
import 'package:MHike/view/view_observations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database_helper.dart';
import '../model/Hike.dart';

class AddObservation extends StatefulWidget{
  final Hike hike;

  AddObservation({required this.hike});

  @override
  State<StatefulWidget> createState() => _AddObservationPage();
}

class _AddObservationPage extends State<AddObservation>{
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  TextEditingController _observationTitleController = new TextEditingController();
  TextEditingController _observationCommentController = new TextEditingController();
  TextEditingController _observationDateController = new TextEditingController();
  TextEditingController _observationTimeController = new TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _observationDateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _observationTimeController.text = picked.format(context);
      });
    }
  }


  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap "Yes" or "No"
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to add this new observation?"),
          actions: <Widget>[
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _saveObservationData(); // Execute the save method
              },
            ),
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _saveObservationData() {
    int hike_id = widget.hike.id!;
    String observationTitle = _observationTitleController.text;
    String observationDate = _observationDateController.text;
    String observationTime = _observationTimeController.text;
    String observationComment = _observationCommentController.text;

    if (observationTitle.isEmpty || observationDate.isEmpty || observationTime.isEmpty) {
      final snackBar = SnackBar(
        content: Text('Please input the missing information.'),
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    else {
      print(
        'Title: $observationTitle; Date: $observationDate; Time: $observationTime; Comment: $observationComment; Hike ID: $hike_id'
      );

      String dateTime = observationDate + " at " + observationTime;

      Observation observation = Observation(title: observationTitle, time: dateTime, comment: observationComment, hikeId: hike_id);
      databaseHelper.insertObservation(observation);

      final snackBar = SnackBar(
        content: Text('Observation added successfully.'),
        duration: Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // Clear the input
      _observationTitleController.clear();
      _observationCommentController.clear();
      _observationTimeController.clear();
      _observationDateController.clear();
      selectedDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add observation"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.93, // 93% of the screen width
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter the observation title: ",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _observationTitleController, // Connect the controller
                  decoration: InputDecoration(
                    hintText: "Observation title",
                  ),
                ),
              ),
              SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.93,
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter the observation date: ",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: IgnorePointer(
                    child: TextField(
                      controller: _observationDateController,
                      decoration: InputDecoration(
                        hintText: "Observation date",
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.93,
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter the observation time: ",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: InkWell(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: IgnorePointer(
                    child: TextField(
                      controller: _observationTimeController,
                      decoration: InputDecoration(
                        hintText: "Observation time",
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.93,
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter the observation comment: ",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _observationCommentController, // Connect the controller
                  decoration: InputDecoration(
                    hintText: "Observation comment",
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust this to control button spacing
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showConfirmationDialog(); // Show the confirmation dialog
                    },
                    child: Text("Save"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ViewObservations(hike: widget.hike),
                        ),
                      ); // Show the confirmation dialog
                    },
                    child: Text("Back to observation list"),
                  ),
                ],
              )
            ]
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

  @override
  void dispose() {
    // Dispose the controller when not needed
    _observationTitleController.dispose();
    _observationDateController.dispose();
    _observationTimeController.dispose();
    _observationCommentController.dispose();
    super.dispose();
  }
}