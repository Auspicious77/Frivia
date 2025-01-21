import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:frivia/pages/home_page.dart';

class GamePageProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  final int _maxQuestions = 15;
  final String difficultyLevel;

  List? questions;
  int currentQuestion = 0;
  int currectCount = 0;
  

  // Constructor
  BuildContext context;
  GamePageProvider({required this.context, required this.difficultyLevel }) {
    _dio.options.baseUrl = "https://opentdb.com/api.php"; // Corrected URL
    getQuestionFromApi();

    print("GameProvider Initialized");
    print("difficulty::: $difficultyLevel");

  }

  Future<void> getQuestionFromApi() async {
    try {
      // Make the API request
      var response = await _dio.get('', queryParameters: {
        "amount": _maxQuestions.toString(),
        "type": "boolean",
        "difficulty": difficultyLevel
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

  void answerQuestions(String answer) async {
    bool isCorrect = questions![currentQuestion]["correct_answer"] == answer;
    // isCorrect? currectCount++ : currectCount+0;
    currectCount += isCorrect? 1 : 0;

    currentQuestion++;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isCorrect ? Colors.green : Colors.red,
          content: Column(
            mainAxisSize: MainAxisSize
                .min, // Ensures the dialog doesn't expand unnecessarily
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel_sharp,
                color: Colors.white,
                size: 50,
              ),
              const SizedBox(
                  height: 16), // Adds spacing between the icon and the text
              Text(
                isCorrect ? "Correct Answer!" : "Wrong Answer!",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );

    print(isCorrect ? "correct" : "incorrect");
    await Future.delayed(const Duration(seconds: 1));

    // close the dialog
    Navigator.pop(context);
    if (currentQuestion == _maxQuestions) {
      endGame();
    } else {
      notifyListeners();
    }
  }

Future<void> endGame() async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.blue,
        title: const Text(
          'Game Ended',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        content: Text("Score: $currectCount/$_maxQuestions"),
      );
    },
  );

  // Wait for 3 seconds
  await Future.delayed(const Duration(seconds: 3));
  Navigator.pop(context); // Close the dialog
  Navigator.pop(context); // Navigate back to the previous page
  
  // Navigate to the WelcomePage
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const HomePage()),
  );

  // Optional: Reset the current question index
  // currentQuestion = 0;
}

}
