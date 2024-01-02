import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/colors.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: MyColors.primary,
            ),
            child: Text(
              'Keep Document',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('Helpful Resources:'),
          ),
          ListTile(
            title: const Text('Aadhar Details'),
            onTap: () {
              launchUrl(Uri.parse('https://uidai.gov.in/'));
            },
          ),
          ListTile(
            title: const Text('Passport Details'),
            onTap: () {
              launchUrl(Uri.parse('https://www.passportindia.gov.in/'));
            },
          ),
          ListTile(
            title: const Text('Voter ID Details'),
            onTap: () {
              launchUrl(Uri.parse('https://www.nvsp.in/'));
            },
          ),
          ListTile(
            title: const Text('Driving License'),
            onTap: () {
              launchUrl(Uri.parse(
                  'https://parivahan.gov.in/parivahan/en/content/driving-licence-0'));
            },
          ),
          ListTile(
            title: const Text('Samagra ID Details'),
            onTap: () {
              launchUrl(Uri.parse('http://samagra.gov.in/'));
            },
          ),
          ListTile(
            title: const Text('PAN Details'),
            onTap: () {
              launchUrl(Uri.parse(
                  'https://www.onlineservices.nsdl.com/paam/endUserRegisterContact.html'));
            },
          ),
          ListTile(
            title: const Text('Ration Card Details'),
            onTap: () {
              launchUrl(Uri.parse(
                  'https://nfsa.gov.in/portal/ration_card_state_portals_aa'));
            },
          ),
        ],
      ),
    );
  }
}
