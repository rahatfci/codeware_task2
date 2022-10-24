import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController inputField = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<List>? seatLayout;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Seat Layout",
      home: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text("Seat Layout")),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        cursorHeight: 30,
                        decoration: const InputDecoration(
                            hintText: 'Enter your json',
                            border: OutlineInputBorder()),
                        maxLines: 12,
                        minLines: 6,
                        controller: inputField,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Json can't be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                seatLayout = findSeatLayout(
                                    json.decode(inputField.text));
                              });
                            }
                          },
                          child: const Text("Find corresponding seat layout")),
                      const SizedBox(
                        height: 20,
                      ),
                      seatLayout == null || seatLayout!.isEmpty
                          ? const SizedBox.shrink()
                          : Table(
                              border: TableBorder.all(
                                  color: Colors.grey.shade500,
                                  style: BorderStyle.solid,
                                  width: 1),
                              children: seatLayout!
                                  .map((e) => TableRow(children: [
                                        buildSeat(e[0]),
                                        buildSeat(e[1]),
                                        buildSeat(e[2]),
                                        buildSeat(e[3]),
                                        buildSeat(e[4]),
                                      ]))
                                  .toList(),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSeat(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Center(
          child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      )),
    );
  }

  List<List> findSeatLayout(List jsonData) {
    List<List> seatLayout = List.generate(
        jsonData.length, (i) => List.filled(5, null, growable: false),
        growable: false);
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] is List) {
        for (int j = 0; j < jsonData[i].length; j++) {
          switch (jsonData[i][j]['t']) {
            case 'do':
              seatLayout[i][j] = "Door";
              break;
            case 'dr':
              seatLayout[i][j] = "Driver";
              break;
            case 'b':
              seatLayout[i][j] = "";
              break;
            case 'c':
              seatLayout[i][j] = "";
              break;
            case 's':
              seatLayout[i][j] = jsonData[i][j]['n'];
              break;
          }
        }
      } else {
        for (int j = 0; j < jsonData[i].length + 1; j++) {
          if (j == 2) {
            seatLayout[i][2] = "";
            continue;
          }

          switch (jsonData[i]['$j']['t']) {
            case 'do':
              seatLayout[i][j] = "Door";
              break;
            case 'dr':
              seatLayout[i][j] = "Driver";
              break;
            case 'b':
              seatLayout[i][j] = "";
              break;
            case 'c':
              seatLayout[i][j] = "";
              break;
            case 's':
              seatLayout[i][j] = jsonData[i]['$j']['n'];
              break;
          }
        }
      }
    }
    return seatLayout;
  }
}
