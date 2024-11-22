import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/student.dart';

class Students with ChangeNotifier {
  final List<Student> _allStudent = [];

  List<Student> get allStudent => _allStudent;

  int get jumlahStudent => _allStudent.length;

  Student selectById(String id) =>
      // ignore: unrelated_type_equality_checks
      _allStudent.firstWhere((element) => element.id == id);

  Future<void> addStudent(String name, String age, String major) {
    Uri url = Uri.parse("http://localhost/flutter/student.php");
    return http
        .post(
      url,
      body: json.encode(
        {
          "name": name,
          "age": age,
          "major": major,
        },
      ),
    )
        .then(
      (response) {
        print("THEN FUNCTION");
        print(json.decode(response.body));
        Student student = selectById(json.decode(response.body)["id"]);

        _allStudent.add(
          Student(
            id: json.decode(response.body)["id"],
            name: name,
            age: age,
            major: major,
          ),
        );

        notifyListeners();
      },
    );
  }

  void editStudent(
      String id, String name, String age, String major, BuildContext context) {
    Student selectPlayer =
        _allStudent.firstWhere((element) => element.id == id);
    selectPlayer.name = name;
    selectPlayer.age = age;
    selectPlayer.major = major;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Berhasil diubah"),
        duration: Duration(seconds: 2),
      ),
    );
    notifyListeners();
  }

  void deletePlayer(String id, BuildContext context) {
    _allStudent.removeWhere((element) => element.id == id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Berhasil dihapus"),
        duration: Duration(milliseconds: 500),
      ),
    );
    notifyListeners();
  }

  Future<void> initialData() async {
    Uri url = Uri.parse("http://localhost/flutter/student.php");

    var hasilGetData = await http.get(url);
    // var dataResponse = json.decode(hasilGetData.body) as Map<String, String>;
    // var dataResponse = hasilGetData.body as Map<int, dynamic>;
    List<Map<String, dynamic>> dataResponse =
        List.from(json.decode(hasilGetData.body) as List);
    //print(dataResponse);
    for (int attribute = 0; attribute < dataResponse.length; attribute++) {
      _allStudent.add(Student(
          id: dataResponse[attribute]["id"],
          name: dataResponse[attribute]["name"],
          age: dataResponse[attribute]["age"],
          major: dataResponse[attribute]["major"]));
    }

    print("BERHASIL MASUKAN DATA LIST");

    notifyListeners();
  }
}
