import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'mainfb.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
//  if (_kShouldTestAsyncErrorOnInit) {
//    await _testAsyncErrorOnInit();
//  }
  runApp(FirestoreApp());
}

//void main() {
//  runApp(MyApp());
//}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Enigma da Nick',
        cards: _getCards(),
      ),
    );
  }

  List<ScapeCardModel> _getCards() => [
        ScapeCardModel(
          codeNumber: "019",
          title: "_icole _avio _ariz",
          questions: [
            "P",
            "M",
            "N",
            "S",
          ],
          answer: 2,
        ),
        ScapeCardModel(
          codeNumber: "018",
          title: "X + X = 4\nX + Y = 3",
          questions: [
            "Y = 3",
            "Y = 0",
            "Y = 5",
            "Y = 1",
          ],
          answer: 3,
        ),
        ScapeCardModel(
          codeNumber: "020",
          title: "m+m=6\nm+n=5",
          questions: [
            "n=5",
            "n=6",
            "n=7",
            "n=2",
          ],
          answer: 3,
        ),
      ];
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
    this.title,
    this.cards,
  }) : super(key: key);

  final String title;
  final List<ScapeCardModel> cards;
  final _random = new Random();
  bool _answerOk;
  int currentItem = 0;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CardWidget(
                card: widget.cards[widget.currentItem],
                onTap: (item) {
                  setState(() {
                    if (widget.cards[widget.currentItem].answer == item) {
                      widget._answerOk = true;
                    } else {
                      widget._answerOk = false;
                    }
                  });
                },
              ),
            ),
            widget._answerOk != null
                ? Text(widget._answerOk ? "Acertouuuu" : "Errrrrou")
                : Text(""),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            widget._answerOk = null;
            if (widget.cards.length > 1) {
              int oldItem = widget.currentItem;
              while (oldItem == widget.currentItem) {
                widget.currentItem =
                    widget._random.nextInt(widget.cards.length);
              }
            }
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.color_lens,
          color: Colors.white,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ScapeCardModel {
  final String codeNumber;
  final String title;
  final List<String> questions;
  final int answer;

  ScapeCardModel({
    this.codeNumber,
    this.title,
    this.questions,
    this.answer,
  });

  ScapeCardModel.fromMap(QueryDocumentSnapshot map)
      : codeNumber = map.data()['codeNumber'],
        title = map['title'],
        questions = List<String>.from(map['questions'].map((x) => x.toString())),//map['questions'] as List<String>,
        answer = map['answer'];

  ScapeCardModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot);

  String toString() => "Record<$codeNumber:$title:$questions:$answer>";
}

class CardWidget extends StatelessWidget {
  final ScapeCardModel card;
  final Function(int) onTap;

  const CardWidget({
    Key key,
    this.card,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BorderedBoxText(
              text: card.codeNumber,
              textColor: Colors.purpleAccent,
              backgroundColor: Colors.cyanAccent,
              borderColor: Colors.purple,
              fontSize: 20,
            ),
            SizedBox(width: 20),
            Text(
              card.title.replaceAll("\\n", "\n"),
              style: TextStyle(
                fontSize: 32,
                color: Colors.greenAccent,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        for (var i = 0; i < card.questions.length; i++)
          Row(
            children: [
              FlatButton(
                color: Colors.pinkAccent,
                child: Text(
                    String.fromCharCode(i + 65),
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.tealAccent,
                  ),
                ),
                onPressed: () => onTap(i),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                card.questions[i],
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                ),
              ),
            ],
          )
      ],
    );
  }
}

// ignore: non_constant_identifier_names
Widget BorderedBoxText({
  String text,
  Color textColor,
  Color backgroundColor,
  Color borderColor,
  double fontSize = 15,
  double padding = 10,
  double borderRadius = 4,
}) =>
    ((text != null) && (text.isNotEmpty))
        ? Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: textColor,
                  ),
                ),
              ),
            ),
          )
        : Container();
