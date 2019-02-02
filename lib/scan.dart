import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {

  var barcode = "";
  var respuesta = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: new AppBar(
        title: new Text('ESCANER CEDULA'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                splashColor: Colors.blueGrey,
                onPressed: scan,
                child: const Text('INICIAR ESCANEO')
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  splashColor: Colors.blueGrey,
                  onPressed: (){
                    barcodeSetter(this.barcode);
                  },
                  child: const Text('ENVIAR')
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(barcode, textAlign: TextAlign.left,),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(respuesta, textAlign: TextAlign.left,),
            ),
          ],
        ),
      )
    );
  }

  Future scan() async {
    try {
      String newBarcode = await BarcodeScanner.scan();
      setState(() => this.barcode = newBarcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  void barcodeSetter(myBarcode) async{

    setState(() => this.respuesta = 'SERVER: Loading...');

    var responseServer = "";

    var url = "https://daniel7byte-testing.herokuapp.com/index.php";
    await http.post(url, body: {"string": myBarcode}).then((response) {
      responseServer = "\nResponse status: ${response.statusCode}" + "\nResponse body: ${response.body}";
    });

    setState(() => this.respuesta = 'SERVER: ${responseServer.toString()}');
  }
}