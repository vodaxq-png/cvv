import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:audioplayers/audioplayers.dart';
import 'order_model.dart';

class RadarScreen extends StatefulWidget {
  const RadarScreen({super.key});

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> {
  final List<Order> _orders = [];
  final Random _random = Random();
  late Timer _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final LatLng _center = const LatLng(30.0444, 31.2357); // القاهرة

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 6), (_) => _addRandomOrder());
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _addRandomOrder() async {
    final double offsetLat = (_random.nextDouble() - 0.5) / 200;
    final double offsetLng = (_random.nextDouble() - 0.5) / 200;

    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: "طلب جديد",
      lat: _center.latitude + offsetLat,
      lng: _center.longitude + offsetLng,
    );

    setState(() => _orders.add(newOrder));
    await _audioPlayer.play(AssetSource('sounds/new_order_sound.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("📡 Smart Radar"),
        backgroundColor: Colors.teal,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _center,
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: _orders
                .map(
                  (o) => Marker(
                    point: LatLng(o.lat, o.lng),
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.location_on, color: Colors.red, size: 35),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
