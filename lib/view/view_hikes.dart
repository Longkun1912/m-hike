import 'package:MHike/database_helper.dart';
import 'package:flutter/material.dart';

import '../model/Hike.dart';
import 'add_hike.dart';
import 'hike_details.dart';

class ViewHikesPage extends StatefulWidget {
  ViewHikesPage({super.key});

  @override
  _ViewHikesPageState createState() => _ViewHikesPageState();
}

class _ViewHikesPageState extends State<ViewHikesPage> {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Hikes"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (text) {
                setState(() {
                  searchQuery = text;
                });
              },
              decoration: InputDecoration(
                hintText: "Search by name",
              ),
            ),
          ),
          SizedBox(height: 10),
          FutureBuilder<List<Hike>>(
            future: databaseHelper.searchHikesByName(searchQuery),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final hikes = snapshot.data;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Hike Name"),
                        Text("Hike Difficulty"),
                        Text("Action"),
                      ],
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: hikes?.length,
                      itemBuilder: (context, index) {
                        final hike = hikes?[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 150, // Set the width as needed
                              child: Text(hike!.name),
                            ),
                            Container(
                              width: 100, // Set the width as needed
                              child: Text(hike!.difficulty),
                            ),
                            Container(
                              width: 100, // Set the width as needed
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Ensure hike.id is not null
                                  if (hike.id != null) {
                                    Hike? selectedHike = await databaseHelper.viewHikeById(hike.id!);
                                    if (selectedHike != null) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => HikeDetailsScreen(
                                            hike: selectedHike,
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
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddHike(),
            ),
          );
        },
        child: Text("Add new hike"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
      ),
    );
  }
}
