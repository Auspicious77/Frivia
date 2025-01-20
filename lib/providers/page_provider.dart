import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class GamePageProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  final int _maxQuestions = 10;

  List? questions;
  int currentQuestion = 0;

  // Constructor
  BuildContext context;
  GamePageProvider({required this.context}) {
    _dio.options.baseUrl = "https://opentdb.com/api.php"; // Corrected URL
    getQuestionFromApi();

    print("GameProvider Initialized");
  }

  Future<void> getQuestionFromApi() async {
    try {
      // Make the API request
      var response = await _dio.get('', queryParameters: {
        "amount": _maxQuestions.toString(),
        "type": "boolean",
        "difficulty": "easy"
      });

      // Check the response format
      if (response.statusCode == 200) {
        // If Dio response data is already a Map, no need for jsonDecode
        var data = response.data;

        // If the response body is a string, decode it
        if (data is String) {
          data = jsonDecode(data);
        }

        questions = data["results"];
        notifyListeners();

        // Print the parsed JSON data
        print(data);
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      // Handle errors
      print("Error fetching questions: $e");
    }
  }

  String GetCurrentQuestionText() {
    //key that holds each questions

    return questions![currentQuestion]['question'];

  }

  void answerQuestions(String answer) async{
    bool isCorrect = questions![currentQuestion]["correct_answer"] == answer;

    currentQuestion++;

    print(isCorrect ? "correct" : "incorrect");
    notifyListeners();


  }
}
