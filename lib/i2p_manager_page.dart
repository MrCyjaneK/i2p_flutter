import 'package:flutter/material.dart';
import 'package:i2p_flutter/i2p_flutter.dart';
import 'package:i2p_flutter/widgets/serviceslist.dart';
import 'package:i2p_flutter/widgets/statuswidget.dart';

class I2PManagerPage extends StatefulWidget {
  const I2PManagerPage({Key? key}) : super(key: key);

  @override
  State<I2PManagerPage> createState() => _I2PManagerPageState();
}

class _I2PManagerPageState extends State<I2PManagerPage> {
  String binPath = "...";
  void loadVars() async {
    i2pFlutterPlugin.getBinaryPath().then((value) {
      setState(() {
        binPath = value;
      });
    });
  }

  @override
  void initState() {
    loadVars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("I2P manager"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                width: double.maxFinite,
                child: Image.network(
                  "https://i2pd.website/images/favicon.png",
                ),
              ), // TODO: embed asset?
              const I2PServicesList(),
              const I2pStatus(),
              SelectableText(binPath),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {}),
    );
  }
}
