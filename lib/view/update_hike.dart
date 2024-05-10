import 'package:MHike/model/Hike.dart';
import 'package:MHike/view/hike_details.dart';
import 'package:MHike/view/view_hikes.dart';
import 'package:MHike/database_helper.dart';
import 'package:flutter/material.dart';

class UpdateHike extends StatefulWidget{
  final Hike hike;

  UpdateHike({required this.hike});

  @override
  State<StatefulWidget> createState() => _UpdateHikePage();
}

class _UpdateHikePage extends State<UpdateHike>{
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  // Define a TextEditingController to handle the text input field
  TextEditingController _hikeNameController = TextEditingController();
  TextEditingController _hikeLocationController = TextEditingController();
  TextEditingController _hikeDateController = TextEditingController();
  TextEditingController _hikeLengthController = TextEditingController();
  TextEditingController _hikeDescriptionController = TextEditingController();

  String _parkingStatus = "Yes"; // Default parking status
  String _hikeDifficulty = "Easy";

  DateTime selectedDate = DateTime.now(); // Store selected date

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
        _hikeDateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize text controllers with last updated values
    _hikeNameController.text = widget.hike.name;
    _hikeLocationController.text = widget.hike.location;
    _hikeDateController.text = widget.hike.date;
    _parkingStatus = widget.hike.parking;
    _hikeLengthController.text = widget.hike.length;
    _hikeDifficulty = widget.hike.difficulty;
    _hikeDescriptionController.text = widget.hike.description;
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap "Yes" or "No"
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to update this hike?"),
          actions: <Widget>[
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _saveupdatedHikeData(); // Execute the save method
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

  void _saveupdatedHikeData() {
    String hikeName = _hikeNameController.text;
    String hikeLocation = _hikeLocationController.text;
    String hikeDate = _hikeDateController.text;
    String hikeLength = _hikeLengthController.text;
    String hikeDescription = _hikeDescriptionController.text;

    if (hikeName.isEmpty || hikeLocation.isEmpty || hikeLength.isEmpty) {
      final snackBar = SnackBar(
        content: Text('Please input the missing information.'),
        duration: Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    } else {
      Hike updatedHike = widget.hike.copyWith(
        name: hikeName,
        location: hikeLocation,
        date: hikeDate,
        parking: _parkingStatus,
        length: hikeLength,
        difficulty: _hikeDifficulty,
        description: hikeDescription,
      );

      databaseHelper.updateHike(updatedHike);

      final snackBar = SnackBar(
        content: Text('Hike updated successfully.'),
        duration: Duration(seconds: 5),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Hike"), // Title at the top of the page
      ),
      body: SingleChildScrollView (
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.93, // 93% of the screen width
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter the hike name: ",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _hikeNameController, // Connect the controller
                  decoration: InputDecoration(
                    hintText: _hikeNameController.text,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.93, // 93% of the screen width
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter the hike location: ",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _hikeLocationController, // Connect the controller
                  decoration: InputDecoration(
                    hintText: _hikeLocationController.text,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.93, // 93% of the screen width
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select hike date: ",
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
                      controller: _hikeDateController,
                      decoration: InputDecoration(
                        hintText: _hikeDateController.text,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.93, // 93% of the screen width
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select parking status: ",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Radio(
                    value: "Yes",
                    groupValue: _parkingStatus,
                    onChanged: (value) {
                      setState(() {
                        _parkingStatus = value!;
                      });
                    },
                  ),
                  Text("Yes"),
                  Radio(
                    value: "No",
                    groupValue: _parkingStatus,
                    onChanged: (value) {
                      setState(() {
                        _parkingStatus = value!;
                      });
                    },
                  ),
                  Text("No"),
                ],
              ),
              SizedBox(height: 10),
              FractionallySizedBox(
                widthFactor: 0.93, // 93% of the screen width
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter the hike length: ",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _hikeLengthController, // Connect the controller
                  decoration: InputDecoration(
                    hintText: _hikeLengthController.text,
                  ),
                ),
              ),
              SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.93, // 93% of the screen width
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select hike difficulty: ",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Radio(
                    value: "Easy",
                    groupValue: _hikeDifficulty,
                    onChanged: (value) {
                      setState(() {
                        _hikeDifficulty = value!;
                      });
                    },
                  ),
                  Text("Easy"),
                  Radio(
                    value: "Normal",
                    groupValue: _hikeDifficulty,
                    onChanged: (value) {
                      setState(() {
                        _hikeDifficulty = value!;
                      });
                    },
                  ),
                  Text("Normal"),
                  Radio(
                    value: "Hard",
                    groupValue: _hikeDifficulty,
                    onChanged: (value) {
                      setState(() {
                        _hikeDifficulty = value!;
                      });
                    },
                  ),
                  Text("Hard"),
                  Radio(
                    value: "Insane",
                    groupValue: _hikeDifficulty,
                    onChanged: (value) {
                      setState(() {
                        _hikeDifficulty = value!;
                      });
                    },
                  ),
                  Text("Insane"),
                ],
              ),
              SizedBox(height: 10),
              FractionallySizedBox(
                widthFactor: 0.93, // 93% of the screen width
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter the hike description: ",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _hikeDescriptionController, // Connect the controller
                  decoration: InputDecoration(
                    hintText: _hikeDescriptionController.text,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showConfirmationDialog(); // Show the confirmation dialog
                    },
                    child: Text("Save changes"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final updatedHike = await databaseHelper.viewHikeById(widget.hike.id!);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HikeDetailsScreen(hike: updatedHike!),
                        ),
                      ); // Show the confirmation dialog
                    },
                    child: Text("Back to hike details"),
                  ),
                ]),
              SizedBox(height: 10),
            ],
          ),
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
    _hikeNameController.dispose();
    _hikeLocationController.dispose();
    _hikeDateController.dispose();
    _hikeLengthController.dispose();
    _hikeDescriptionController.dispose();
    super.dispose();
  }
}