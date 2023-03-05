import 'package:flutter/material.dart';
import 'package:i2p_flutter/i2p_flutter.dart';

class I2PServicesList extends StatefulWidget {
  const I2PServicesList({Key? key}) : super(key: key);

  @override
  I2P_ServicesListState createState() => I2P_ServicesListState();
}

class I2P_ServicesListState extends State<I2PServicesList> {
  Map<String, String> list = {};
  void loadServices() async {
    i2pFlutterPlugin.getTunnelsList().then((value) {
      setState(() {
        list = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.keys.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return SizedBox(
            child: OutlinedButton.icon(
              onPressed: () {
                loadServices();
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Refresh service list"),
            ),
          );
        }
        return Column(
          children: [
            SelectableText(
              "${list.keys.elementAt(index - 1)}:${list[list.keys.elementAt(index - 1)]}",
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
