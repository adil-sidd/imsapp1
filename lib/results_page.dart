
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qr_scanner_ims/scanner_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ResultsPage extends StatefulWidget {
  final String result;
  const ResultsPage({Key? key, required this.result}) : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {

  @override
  Widget build(BuildContext context) {
    var resultList = widget.result.split("________");
    var collection = FirebaseFirestore.instance.collection(resultList[0]);
    var documentID = resultList[1];

    return WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ScannerPage()));
          return Future.value(false);
        },
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScannerPage()));
                },
              ),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text(
                'Scan Results',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            body: Container(
              margin: const EdgeInsets.all(0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/bg.png'),
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomRight)),
              child: Container(
                  padding: const EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Card(
                        elevation: 5,
                        color: Colors.white,
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: StreamBuilder(
                            stream: collection.doc(documentID).snapshots(),
                            builder: (_, snapshot) {
                              EasyLoading.dismiss();
                              if (snapshot.hasError) {
                                return Text('Error = ${snapshot.error}');
                              }
                              if (snapshot.hasData) {
                                var output = snapshot.data!.data();
                                // var value = output!['location'];
                                // var keys = output.keys;
                                // var values = output.values;
                                var finalResult = "";
                                output?.forEach((key, value) {
                                  if (finalResult.isEmpty) {
                                    finalResult =
                                    "${key.toString().toUpperCase()} - ${value.toString().toUpperCase()}";
                                  } else {
                                    finalResult =
                                    "$finalResult\n${key.toString().toUpperCase()} - ${value.toString().toUpperCase()}";
                                  }
                                });

                                // saveData(finalResult);
                                return Text(finalResult.toString().toUpperCase());
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        )),
                  )),
            )));
  }

// saveData(String finalResult) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//   var previousVal = await prefs.getInt('lastVal');
//   var dataAtPreviousVal = await prefs.getString(previousVal.toString());
//   var z = dataAtPreviousVal != finalResult;
//
//   if (dataAtPreviousVal != finalResult){
//     var currentVal = previousVal! + 1;
//     await prefs.setString(currentVal.toString(), finalResult);
//     await prefs.setInt("lastVal", currentVal);
//   }
// }
}
