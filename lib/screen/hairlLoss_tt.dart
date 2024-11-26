import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:hairloss/model/diagnosis_page.dart';
class hairLoss extends StatefulWidget {
  @override
  _hairLossState createState() => _hairLossState();
}

class _hairLossState extends State<hairLoss> {
  File? _image;
  String diagnosisResult = '';
  String symptom1 = '';
  String symptom2 = '';
  String symptom3 = '';
  String symptom4 = '';
  String symptom5 = '';
  String symptom6 = '';

  Future<void> _getImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Flask 서버에서 진단 결과를 가져오는 함수
  Future<void> _uploadImage() async {
    String apiUrl = 'http://192.168.35.155:5000/upload'; // Flask 서버 주소로 변경
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var jsonResponse = await response.stream.bytesToString();
        var data = json.decode(jsonResponse); // json.decode를 사용하여 JSON 파싱

        setState(() {
          diagnosisResult = data['message']; // Flask 서버에서 전달한 진단 결과
          symptom1 = data['symptom1'];
          symptom2 = data['symptom2'];
          symptom3 = data['symptom3'];
          symptom4 = data['symptom4'];
          symptom5 = data['symptom5'];
          symptom6 = data['symptom6'];
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiagnosisPage(
              diagnosisResult,
              _image,
              symptom1,
              symptom2,
              symptom3,
              symptom4,
              symptom5,
              symptom6,
            ),
          ),
        );
      } else {
        setState(() {
          diagnosisResult = '서버 오류: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        diagnosisResult = '오류: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('이미지를 선택하세요.')
                : Image.file(_image!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImageFromGallery,
              child: Text('이미지 선택'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('이미지 업로드'),
            ),
          ],
        ),
      ),
    );
  }
}