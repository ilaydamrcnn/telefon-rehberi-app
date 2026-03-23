import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class IletisimScreen extends StatefulWidget {
  @override
  _IletisimScreenState createState() => _IletisimScreenState();
}

class _IletisimScreenState extends State<IletisimScreen> {
  static const LatLng _center = LatLng(36.800354, 34.590925);

  late GoogleMapController mapController;

  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('yeni_sehir_belediyesi'),
      position: _center,
      infoWindow: InfoWindow(title: 'Yenişehir Belediyesi'),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Telefon araması yapılamıyor')));
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('E-posta gönderilemiyor')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color cardColor = Colors.blue.shade50;
    final borderRadius = BorderRadius.circular(12);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'İletişim',
          textAlign: TextAlign.center,
          style: TextStyle(color: const Color(0xFF003366), fontWeight: FontWeight.bold,fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: cardColor,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 25,
                ),
                markers: _markers,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(borderRadius: borderRadius),
                    margin: EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.blue.shade700),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Adres: Limonluk Mahallesi, Vali Hüseyin Aksoy Cd. No:3, 33120 Yenişehir/Mersin",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(borderRadius: borderRadius),
                    margin: EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: borderRadius,
                      onTap: () => _launchPhone('(0324) 327 33 00'),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(Icons.phone, color: Colors.teal.shade700),
                            SizedBox(width: 10),
                            Expanded(child: Text("Telefon: (0324) 327 33 00")),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(borderRadius: borderRadius),
                    margin: EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: borderRadius,
                      onTap: () => _launchPhone('444 33 54'),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(Icons.phone, color: Colors.teal.shade700),
                            SizedBox(width: 10),
                            Expanded(child: Text("Telefon: 444 33 54")),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(borderRadius: borderRadius),
                    margin: EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(Icons.print, color: Colors.grey.shade700),
                          SizedBox(width: 10),
                          Expanded(child: Text("Faks: (0324) 327 63 77")),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(borderRadius: borderRadius),
                    margin: EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: borderRadius,
                      onTap: () => _launchEmail('bilgi@yenisehir.bel.tr'),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(Icons.email, color: Colors.red.shade700),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text("Mail: bilgi@yenisehir.bel.tr"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(borderRadius: borderRadius),
                    margin: EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.mark_email_read,
                            color: Colors.deepPurple.shade700,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Kep: mersinyenisehirbelediyesi@hs01.kep.tr",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
