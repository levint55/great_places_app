import 'package:flutter/material.dart';
import 'package:great_places_app/providers/great_places.dart';
import 'package:great_places_app/screens/add_place_screen.dart';
import 'package:great_places_app/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false).fetchData(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatPlaces>(
                child: const Center(
                  child: Text('Got No Places Yet'),
                ),
                builder: (context, value, child) => value.items.isEmpty
                    ? child!
                    : ListView.builder(
                        itemCount: value.items.length,
                        itemBuilder: (_, i) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: FileImage(value.items[i].image!),
                          ),
                          title: Text(value.items[i].title),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              PlaceDetailScreen.routeName,
                              arguments: value.items[i].id,
                            );
                          },
                          subtitle: Text(value.items[i].location!.address),
                        ),
                      ),
              ),
      ),
    );
  }
}
