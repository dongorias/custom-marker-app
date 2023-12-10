import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:screenshot/screenshot.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom marker',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LatLng target = const LatLng(6.412003153534969, 2.3347697407007217);
  Set<Marker> markers = {};

  List<Users> users = [
    Users(
        position: const LatLng(6.412554804820918, 2.3344536578954074),
        name: 'Rose',
        image: 'https://randomuser.me/api/portraits/women/86.jpg'
        ),
    Users(
        position: const LatLng(6.406919115795665, 2.3287979634707323),
        name: 'Jassabelle',
        image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcA3AmOb_BMAsPra4XquXuWFMNAi7grJL0ug&usqp=CAU'
        ),
    Users(
        position: const LatLng(6.412936584477634, 2.341074023854719),
        name: 'Olivia',
        image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSuIavvjuQFB38Se2ZNa0GkZ1Gol3C5OwioHA&usqp=CAU'
        )
  ];

  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(6.412003153534969, 2.3347697407007217),
    zoom: 15,
  );

  ///Generates a custom [BitmapDescriptor] from a [CustomMarker] widget.
  Future<BitmapDescriptor> customMarkerIcon({
    required String image,
    required String name,
  }) async {
    final Uint8List result = await ScreenshotController().captureFromWidget(
      CustomMarker(
        image: image,
        name: name,
      ),
      context: context,
      targetSize: const Size(200, 150),
      pixelRatio: 3.0
    );
    return BitmapDescriptor.fromBytes(result);
  }

  ///Adds custom markers to the map using user information.
  Future<void> addMarker() async {
    for (var element in users) {
      markers.add(Marker(
        markerId: MarkerId(
            '${element.position.latitude}-${element.position.longitude}'),
        icon: await customMarkerIcon(name: element.name, image: element.image),
        position: element.position,
      ));
    }
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      addMarker();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGoogle,
        markers: markers,
       // markers: markers,
      ),
    );
  }
}

///Custom widget representing a marker on the map.
class CustomMarker extends StatelessWidget {
  const CustomMarker({super.key, required this.name, required this.image});

  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color(0xffFEC83A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            name,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.all(5), // Border width
          decoration: const BoxDecoration(
              color: Color(0xffFEC83A), shape: BoxShape.circle),
          child: ClipOval(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(18), // Image radius
              child: Image.network(image, fit: BoxFit.cover),
              // child:  Image.asset(image, fit: BoxFit.cover),
            ),
          ),
        )
      ],
    );
  }
}

/// Data model representing a user on the map.
class Users {
  Users({required this.position, required this.name, required this.image});

  LatLng position;
  String name;
  String image;
}
