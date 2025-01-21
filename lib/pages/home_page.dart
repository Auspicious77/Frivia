import 'package:flutter/material.dart';
import 'package:frivia/pages/game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  double currentDifficlultyLevel = 0;
  final List<String> _difficultyTexts = ["Easy", "Medium", "Hard"];
 

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Optional: Centers the children vertically
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                _appTitle(),
                _difficultySlider(),
                _gameButton(),
              ]),
        ),
      ),
    );
  }

  Widget _appTitle() {
    return Column(
      children: [
        const Text(
          'Frivia',
          style: TextStyle(
              fontSize: 50, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        Text(
          _difficultyTexts[currentDifficlultyLevel.toInt()],
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ],
    );
  }

  Widget _difficultySlider() {
    return Slider(
        min: 0,
        max: 2,
        label: "Difficulty",
        divisions: 2,
        onChanged: (value) {
          setState(() {
            currentDifficlultyLevel = value;
            // print(currentDifficlultyLevel);
          });
        },
        value: currentDifficlultyLevel);
  }

  Widget _gameButton() {
    return MaterialButton(
      onPressed: () {
        // Navigate to GamePage when button is pressed
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => GamePage(difficultyLevel: _difficultyTexts[currentDifficlultyLevel.toInt()].toLowerCase(),)),
        );
      },
      color: Colors.blue,
      minWidth: _deviceWidth! * 0.6,
      height: _deviceHeight! * 0.06,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(28.0), // Adjust the radius as needed
      ),
      child: const Text(
        "Start",
        style: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
      ),
    );
  }
}
