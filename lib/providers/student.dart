import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class Students with ChangeNotifier {
  final List<Student> _allStudent = [];

  List<Student> get allStudent => _allStudent;

  int get jumlahStudent => _allStudent.length;

  Student selectById(String id) {
    return _allStudent.firstWhere((element) => element.id == id);
  }

  Future<void> initialData() async {
    try {
      Uri url = Uri.parse("http://localhost/flutter/student.php/student");
      var hasilGetData = await http.get(url);

      if (hasilGetData.statusCode == 200) {
        List<Map<String, dynamic>> dataResponse =
            List.from(json.decode(hasilGetData.body) as List);

        for (int attribute = 0; attribute < dataResponse.length; attribute++) {
          _allStudent.add(
            Student(
              id: dataResponse[attribute]["id"],
              name: dataResponse[attribute]["name"],
              age: dataResponse[attribute]["age"],
              major: dataResponse[attribute]["major"],
            ),
          );
        }

        print("BERHASIL MASUKAN DATA LIST");
        notifyListeners();
      } else {
        // Handle error case
        print('Error fetching data: ${hasilGetData.statusCode}');
      }
    } catch (e) {
      // Handle other exceptions
      print('Error: $e');
    }
  }

  Future<void> editStudent(
    String id,
    String name,
    String age,
    String major,
    BuildContext context,
  ) async {
    try {
      Student selectPlayer = _allStudent.firstWhere((element) => element.id == id);
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
    } catch (e) {
      // Handle error case
      print('Error editing student: $e');
    }
  }

  void deletePlayer(String id, BuildContext context) {
    try {
      _allStudent.removeWhere((element) => element.id == id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Berhasil dihapus"),
          duration: Duration(milliseconds: 500),
        ),
      );
      notifyListeners();
    } catch (e) {
      // Handle error case
      print('Error deleting student: $e');
    }
  }

  Future<void> addStudent(
    String name,
    String age,
    String major,
    BuildContext context,
  ) async {
    try {
      Uri url = Uri.parse("http://localhost/flutter/student.php/student");
      var response = await http.post(
        url,
        body: {
          "name": name,
          "age": age,
          "major": major,
        },
      );

      if (response.statusCode == 200) {
        print("THEN FUNCTION");
        print(json.decode(response.body));
        _allStudent.add(
          Student(
            id: json.decode(response.body)["id"],
            name: name,
            age: age,
            major: major,
          ),
        );
        notifyListeners();
      } else {
        // Handle error case
        print('Error adding student: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other exceptions
      print('Error: $e');
    }
  }
}