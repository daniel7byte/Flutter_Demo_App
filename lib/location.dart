import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class PageLocation extends StatefulWidget {
  @override
  _PageLocationState createState() => _PageLocationState();
}

class _PageLocationState extends State<PageLocation> {

  var mapController = new MapController();
  var point = new LatLng(18.0, 106.0);
  StreamSubscription<Map<String, double>> subscription;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('GEO MAPPING'),
      ),
      body: new FlutterMap(
        mapController: mapController,
        options: new MapOptions(
          center: point,
          zoom: 5.0,
        ),
        layers: <LayerOptions>[
          new TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          new MarkerLayerOptions(
            markers: <Marker>[
              new Marker(
                width: 80.0,
                height: 80.0,
                point: point,
                builder: (BuildContext context) {
                  return new Icon(
                    Icons.location_on,
                    color: Colors.red,
                  );
                })
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.info),
        onPressed: () {
          print("CLICK");
        },
        backgroundColor: Colors.blueGrey,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black54,
        child: Container(height: 50.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void initState() {
    super.initState();
    subscription = new Location().onLocationChanged().listen((location) {
      point = new LatLng(location['latitude'], location['longitude']);
      mapController.move(point, 10.0);
      setState(() {});
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
