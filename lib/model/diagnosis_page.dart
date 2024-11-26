import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DiagnosisPage extends StatelessWidget {
  final String diagnosisResult;
  final File? image;
  final String symptom1, symptom2, symptom3, symptom4, symptom5, symptom6; // 변수 타입을 다시 String으로 변경
  DiagnosisPage(this.diagnosisResult, this.image, this.symptom1, this.symptom2, this.symptom3, this.symptom4, this.symptom5, this.symptom6);

  String mapSeverity(int severity) {
    switch (severity) {
      case 0:
        return '양호';
      case 1:
        return '경증';
      case 2:
        return '중등도';
      case 3:
        return '중증';
      default:
        return '알 수 없음';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('두피 진단'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // 이미지를 원하는 위치에 배치하기 위해 Container 사용
          Container(
            alignment: Alignment.topCenter,
            child: image != null
                ? Image.file(
              image!,
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.7, // 이미지 높이 조절
              fit: BoxFit.cover,
            )
                : Text('이미지가 없습니다.'),
          ),
          SizedBox(
            height: 20, // 텍스트와 이미지 간격 조절
          ),
          Center(
            child: Text(
              '진단 결과: $diagnosisResult',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
          SizedBox(
            height: 20, // 텍스트와 증상 간격 조절
          ),
          // 증상 출력
          Padding(
            padding: const EdgeInsets.only(left: 10.0), // Add 10% left padding
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('1. 미세각질: ${mapSeverity(int.parse(symptom1))}', style: TextStyle(fontSize: 24)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0), // Add 10% left padding
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('2. 피지과다: ${mapSeverity(int.parse(symptom2))}', style: TextStyle(fontSize: 24)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0), // Add 10% left padding
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('3. 모낭사이홍반: ${mapSeverity(int.parse(symptom3))}', style: TextStyle(fontSize: 24)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0), // Add 10% left padding
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('4. 모낭홍반농포: ${mapSeverity(int.parse(symptom4))}', style: TextStyle(fontSize: 24)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0), // Add 10% left padding
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('5. 비듬: ${mapSeverity(int.parse(symptom5))}', style: TextStyle(fontSize: 24)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0), // Add 10% left padding
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('6. 탈모: ${mapSeverity(int.parse(symptom6))}', style: TextStyle(fontSize: 24)),
            ),
          ),
        ],
      ),
    );
  }
}