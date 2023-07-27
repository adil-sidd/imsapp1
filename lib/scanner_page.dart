import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:qr_scanner_ims/results_page.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    controller?.resumeCamera();
    EasyLoading.dismiss();
    return Container(
      margin: const EdgeInsets.all(0),
      child: Scaffold(
        appBar: const EmptyAppBar(),
        body: DoubleBackToCloseApp(
          snackBar: const SnackBar(
            content: Text('Tap back again to leave.'),
          ),
          child: _buildQrView(context),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await controller?.toggleFlash();
            setState(() {});
          },
          child: FutureBuilder(
            future: controller?.getFlashStatus(),
            builder: (context, snapshot) {
              Icon flash = snapshot.data.toString() == 'true'
                  ? const Icon(Icons.flashlight_on_sharp)
                  : const Icon(Icons.flashlight_off_sharp);
              return flash;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 350.0
        : 350.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.yellow,
          borderRadius: 10,
          borderLength: 50,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        result = scanData;
        EasyLoading.show(status: "Loading...");
        controller.pauseCamera();
        var flash = await controller.getFlashStatus();
        if (flash!){
          await controller.toggleFlash();
        }
        changeScreen(result!.code.toString());
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission Denied')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  changeScreen(String resultX) {

    var resultList = resultX.split("________");

    if (resultList.length != 2){
      showDialog(
          context: context,
          builder: (context) {
            EasyLoading.dismiss();
            return AlertDialog(
              title: const Text("Invalid QR Detected."),
              content: const Text(
                  "We are unable to process this QR. Kindly check for the authenticity of this QR first then retry."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    controller!.resumeCamera();
                  },
                  child: const Text('Scan Again'),
                ),
              ],
            );
          });
    }
    else {

      var collection = resultList[0];
      var documentID = resultList.last;

      try {
        FirebaseFirestore.instance
            .collection(collection)
            .doc(documentID)
            .get()
            .then((doc) {
          controller!.pauseCamera();
          if (doc.exists) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ResultsPage(result: resultX)));
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  EasyLoading.dismiss();
                  return AlertDialog(
                    title: const Text("Invalid QR Detected."),
                    content: const Text(
                        "We are unable to process this QR. Kindly check for the authenticity of this QR first then retry."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          controller!.resumeCamera();
                        },
                        child: const Text('Scan Again'),
                      ),
                    ],
                  );
                });
          }
        });
      } on Exception {
        showDialog(
            context: context,
            builder: (context) {
              EasyLoading.dismiss();
              return AlertDialog(
                title: const Text("Invalid QR Detected."),
                content: const Text(
                    "We are unable to process this QR. Kindly check for the authenticity of this QR first then retry."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      controller!.resumeCamera();
                    },
                    child: const Text('Scan Again'),
                  ),
                ],
              );
            });
      }

    }
  }
}

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EmptyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }

  @override
  Size get preferredSize => const Size(0.0, 0.0);
}

// floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
// floatingActionButton: Row(
// mainAxisAlignment: MainAxisAlignment.spaceAround,
// children: [
// Align(
// alignment: Alignment.bottomLeft,
// child: FloatingActionButton(
// onPressed: ()  {
// Navigator.push(context, MaterialPageRoute(builder: (context) => const ScannedItemsList()));
// },
// child: const Icon(Icons.list_alt_outlined),
// ),
// ),
// Align(
// alignment: Alignment.bottomRight,
// child: FloatingActionButton(
// onPressed: () async {
// await controller?.toggleFlash();
// setState(() {});
// },
// child: FutureBuilder(
// future: controller?.getFlashStatus(),
// builder: (context, snapshot) {
// Icon flash = snapshot.data.toString() == 'true'
// ? const Icon(Icons.flashlight_on_sharp)
//     : const Icon(Icons.flashlight_off_sharp);
// return flash;
// },
// ),
// ),
// ),
// ]
// )
