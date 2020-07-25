import 'dart:convert';

import 'package:firstapp/talep.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Follow Talep Listesi'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var notes;

  List<talep> _notes = List<talep>();
  Future<List<talep>> fetchNotes() async {
    var url =
        "http://192.168.1.24:8080/ERPService/list/follow?in-yazilim_talep-ilgili_yazilimci_id=225&ne-yazilim_talep-durumu=06";
    var response = await http.get(url);

    notes = List<talep>();
    if (response.statusCode == 200) {
      String resp = Utf8Decoder().convert(response.bodyBytes);
      var notesJson = json.decode(resp);
      for (var noteJson in notesJson) {
        notes.add(talep.fromJson(noteJson));
      }
    }
    return notes;
  }

  @override
  void initState() {
    fetchNotes().then((value) {
      setState(() {
        _notes.addAll(value);
      });
    });
    super.initState();
  }

  bool sort = true;
  int column = 0;

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        _notes.sort((a, b) => a.id.compareTo(b.id));
      } else {
        _notes.sort((a, b) => b.id.compareTo(a.id));
      }
    }
    if (columnIndex == 2) {
      if (ascending) {
        _notes.sort((a, b) => a.durumu.compareTo(b.durumu));
      } else {
        _notes.sort((a, b) => b.durumu.compareTo(a.durumu));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var dataTable = DataTable(
      sortAscending: sort,
      sortColumnIndex: column,
      columns: <DataColumn>[
        DataColumn(
            label: Text("Talep No"),
            onSort: (columnIndex, ascending) {
              setState(() {
                sort = !sort;
                column = columnIndex;
              });
              onSortColum(columnIndex, ascending);
            }),
        DataColumn(label: Text("Konu")),
        DataColumn(
            label: Text("Durumu"),
            onSort: (columnIndex, ascending) {
              setState(() {
                sort = !sort;
                column = columnIndex;
              });
              onSortColum(columnIndex, ascending);
            }),
      ],
      rows: <DataRow>[
        for (var i = 0; i < _notes.length; i++)
          DataRow(cells: <DataCell>[
            DataCell(Text(_notes[i].id.toString())),
            DataCell(Text(_notes[i].konu.toString())),
            DataCell(Text(_notes[i].durumu.toString())),
          ])
      ],
    );
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: dataTable,
            )),
      ),
    );
  }
}
