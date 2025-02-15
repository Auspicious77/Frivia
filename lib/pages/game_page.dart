import 'package:flutter/material.dart';
import 'package:frivia/providers/page_provider.dart';
import 'package:provider/provider.dart';

class GamePage extends StatelessWidget {
  double? _deviceHeight, _deviceWidth;
   final String difficultyLevel;

  GamePageProvider? _pageProvider;

  GamePage({required this.difficultyLevel});

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

//Wrap all widget inside the Provider.
    return ChangeNotifierProvider(
      create: (context) => GamePageProvider(context: context, difficultyLevel: difficultyLevel),
      child: _buildUI(),
    );
  }

  // //Build UI widget
  Widget _buildUI() {
    return Builder(builder: (context) {
      //use the provider
      _pageProvider = context.watch<GamePageProvider>();
      if (_pageProvider!.questions != null) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
              child: _gameUI(),
            ),
          ),
        );
      }
      else {
        return const Center(child: CircularProgressIndicator(color: Colors.white,),);
      }
    });
  }


//   Widget _buildUI() {
//   return Builder(builder: (context) {
//     // Use the provider
//     _pageProvider = context.watch<GamePageProvider>();

//     if (_pageProvider!.questions != null) {
//       return 
//       Scaffold(
//         body: SafeArea(
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
//             child: _gameUI(),
//           ),
//         ),
//       );
//     } else {
//       // Display HomePage when questions are null
//       return const HomePage();
//     }
//   });
// }

  Widget _gameUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _questionText(),
        Column(
          children: [
            _trueButton(),
            SizedBox(
              height: _deviceHeight! * 0.01,
            ),
            _falseButton(),
          ],
        )
      ],
    );
  }

  Widget _questionText() {
    return Text(_pageProvider!.GetCurrentQuestionText(),
      style: const TextStyle(
          color: Colors.white, fontSize: 25, fontWeight: FontWeight.w400),
    );
  }

  Widget _trueButton() {
    return MaterialButton(
      onPressed: () {
        _pageProvider!.answerQuestions("True");
      },
      color: Colors.green,
      minWidth: _deviceWidth! * 0.80,
      height: _deviceHeight! * 0.10,
      child: const Text(
        "True",
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
      ),
    );
  }

  Widget _falseButton() {
    return MaterialButton(
         onPressed: () {
        _pageProvider!.answerQuestions("False");
      },
      color: Colors.red,
      minWidth: _deviceWidth! * 0.80,
      height: _deviceHeight! * 0.10,
      child: const Text(
        "False",
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
      ),
    );
  }
}
