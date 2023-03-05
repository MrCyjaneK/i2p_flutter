import 'package:flutter/material.dart';
import 'package:i2p_flutter/i2p_flutter.dart';
import 'package:i2p_flutter/widgets/serviceslist.dart';
import 'package:i2p_flutter/widgets/statuswidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
              const I2PServicesList(),
              const I2pStatus(),
              SelectableText(binPath),
              const Divider(),
              _titleText("tunnels.conf"),
              futureCodeText(futureValue: i2pFlutterPlugin.readTunnelsConf()),
              const Divider(),
              _titleText("i2pd.conf"),
              futureCodeText(futureValue: i2pFlutterPlugin.readI2pdConf()),
              const Divider(),
              const Text(
                  "If you, as an advanced user want to run i2pd on your own - here goes your config. After configuring your own unsupported method of running i2pd make sure to press \"Don't run i2pd\" button."),
              SizedBox(
                width: double.maxFinite,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool("flutter_i2pd.dontrun", true);
                    await i2pFlutterPlugin.ensureDeath();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.stop),
                  label: const Text("Don't run i2pd when requested"),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool("flutter_i2pd.dontrun", false);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.start),
                  label: const Text("Run i2pd when requested"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Text _titleText(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 24),
    );
  }
}

class futureCodeText extends StatefulWidget {
  const futureCodeText({
    super.key,
    required this.futureValue,
  });

  final Future<String> futureValue;

  @override
  State<futureCodeText> createState() => _futureCodeTextState();
}

class _futureCodeTextState extends State<futureCodeText> {
  String text = "...";

  @override
  void initState() {
    widget.futureValue.then((val) {
      setState(() {
        text = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(fontFamily: "monospace"),
    );
  }
}
