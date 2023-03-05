import 'package:flutter/material.dart';
import 'package:i2p_flutter/i2p_flutter.dart';

class I2pStatus extends StatefulWidget {
  const I2pStatus({Key? key}) : super(key: key);

  @override
  _I2pStatusState createState() => _I2pStatusState();
}

class _I2pStatusState extends State<I2pStatus> {
  String? status;

  void loadStatus() {
    i2pFlutterPlugin.getProcessInfo().then((value) {
      setState(() {
        status = value;
      });
    });
  }

  @override
  void initState() {
    loadStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        loadStatus();
      },
      onLongPress: (status != null)
          ? () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("I2Pd PID"),
                    content: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SelectableText(
                        status!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontFamily: "monospace"),
                      ),
                    ),
                  );
                },
              );
            }
          : null,
      child: Card(
        color: status == null ? Colors.red : null,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  status == null ? "I2pd is stopped" : "I2pd is running",
                ),
              ),
            ),
            if (status == null)
              IconButton(
                onPressed: () {
                  i2pFlutterPlugin.runI2pd();
                  setState(() {
                    status = "Starting...";
                  });
                },
                icon: const Icon(Icons.power),
              )
          ],
        ),
      ),
    );
  }
}
