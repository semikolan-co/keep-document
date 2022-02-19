import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/colors.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
         DrawerHeader(
            child: Text(
              'Keep Document',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            decoration: BoxDecoration(
              color: MyColors.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Helpful Resources:'),
          ),
          ListTile(
            title: Text('Aadhar Details'),
            onTap: () {
              launch('https://uidai.gov.in/');
            },
          ),
          ListTile(
            title: Text('Passport Details'),
            onTap: () {
              launch('https://www.passportindia.gov.in/');
            },
          ),
          ListTile(
            title: Text('Voter ID Details'),
            onTap: () {
              launch('https://www.nvsp.in/');
            },
          ),
          ListTile(
            title: Text('Driving License'),
            onTap: () {
              launch(
                  'https://parivahan.gov.in/parivahan/en/content/driving-licence-0');
            },
          ),
          ListTile(
            title: Text('Samagra ID Details'),
            onTap: () {
              launch('http://samagra.gov.in/');
            },
          ),
          ListTile(
            title: Text('PAN Details'),
            onTap: () {
              launch(
                  'https://www.onlineservices.nsdl.com/paam/endUserRegisterContact.html');
            },
          ),
          ListTile(
            title: Text('Ration Card Details'),
            onTap: () {
              launch(
                  'https://nfsa.gov.in/portal/ration_card_state_portals_aa');
            },
          ),
        ],
      ),
    );
  }
}
