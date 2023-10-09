import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mobiletest2/screen/student/home_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class scanScreenForStudent extends StatefulWidget {
  const scanScreenForStudent({Key? key}) : super(key: key);

  @override
  State<scanScreenForStudent> createState() => _scanScreenForStudentState();
}

class _scanScreenForStudentState extends State<scanScreenForStudent> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

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
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: onQRViewCamera,
            ),
          ),
          Expanded(
              child: Center(
            child: Column(children: [
              SizedBox(height: 16),
              (result != null)
                  ? Text('Data ${result!.code}')
                  : const Text('Scan a code'),
              SizedBox(height: 16), // ระยะห่างระหว่างข้อความและปุ่ม
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        // ตรงนี้คุณสามารถกำหนดหน้าที่คุณต้องการแสดงหรือนำไปยังหน้าอื่น
                        return const homeScreenForStudent();
                      },
                    ),
                  );
                },
                child: Text('กลับไปหน้าหลัก'),
              ),
            ]),
          ))
        ],
      ),
    );
  }

  void onQRViewCamera(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
