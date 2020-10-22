import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
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
      ];
}

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
            widget._answerOk != null ? Text(widget._answerOk ? "Acertouuuu" : "Errrrrou") : Text(""),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            widget._answerOk = null;
            if (widget.cards.length > 1) {
              int oldItem = widget.currentItem;
              while(oldItem == widget.currentItem) {
                widget.currentItem =
                    widget._random.nextInt(widget.cards.length);
              }
            }
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
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
          children: [
            BorderedBoxText(
              text: card.codeNumber,
              textColor: Colors.blue,
              backgroundColor: Colors.white,
              borderColor: Colors.grey,
              fontSize: 20,
            ),
            SizedBox(width: 20),
            Text(
              card.title,
              style: Theme.of(context).textTheme.headline4,
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
                color: Colors.blueGrey,
                child: Text(String.fromCharCode(i + 65)),
                onPressed: () => onTap(i),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                card.questions[i],
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          )
      ],
    );
  }
}

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
