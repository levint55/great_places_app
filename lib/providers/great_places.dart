import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places_app/helpers/db_helper.dart';
import 'package:great_places_app/helpers/location_helper.dart';
import 'package:great_places_app/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addPlace(String title, File? image, PlaceLocation? placeLocation) {
    final address = LocationHelper.getPlaceAddress();
    final newLocation =
        PlaceLocation(latitude: 0, longitude: 0, address: address);

    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      location: newLocation,
      image: image,
    );

    _items.add(newPlace);
    notifyListeners();

    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image!.path,
      'loc_lat': newPlace.location!.latitude,
      'loc_lng': newPlace.location!.longitude,
      'address': newPlace.location!.address,
    });
  }

  Future fetchData() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map((e) => Place(
              id: e['id'],
              title: e['title'],
              image: File(e['image']),
              location: PlaceLocation(
                latitude: e['loc_lat'],
                longitude: e['loc_lng'],
                address: e['address'],
              ),
            ))
        .toList();
    notifyListeners();
  }
}
