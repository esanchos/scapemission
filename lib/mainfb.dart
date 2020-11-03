import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class FirestoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enigma da Nick',
      home: MyHomePage(),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  int currentItem = 0;
  List<ScapeCardModel> cards;

  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text('Black Pink Nick'),
      ),
      body: _buildBody2(),
    );
  }

  Future<List<ScapeCardModel>> _getCards() async {
/*    return (await FirebaseFirestore
        .instance
        .collection('scape')
        .snapshots()
        .first)
        .docs.map((e) => ScapeCardModel.fromMap(e));*/
    List<ScapeCardModel> result = [];
    var document = (await FirebaseFirestore.instance
        .collection('scape')
        .snapshots()
        .first);
    document.docs.forEach((element) {
      result.add(ScapeCardModel.fromMap(element));
    });
    return result;
  }

  Widget _buildBody2() {
    return FutureBuilder(
      future: _getCards(),
      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.done)
            ? _buildPage2(snapshot.data)
            : Container();
      },
    );
  }

  Widget _buildPage2(List<ScapeCardModel> cards) {
    if (cards == null) return Container();
    return ScapeScreenBody(cards: cards);
  }
}

// ignore: must_be_immutable
class ScapeScreenBody extends StatefulWidget {
  ScapeScreenBody({
    Key key,
    this.cards,
  })  : currentItem = Random().nextInt(cards.length),
        super(key: key);

  int currentItem;
  final List<ScapeCardModel> cards;
  bool _answerOk;

  @override
  _ScapeScreenBody createState() => _ScapeScreenBody();
}

class _ScapeScreenBody extends State<ScapeScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Center(
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
          Expanded(child: Container()),
          FlatButton(
            color: Colors.tealAccent,
            onPressed: () => setState(() {
              widget._answerOk = null;
              var currentOld = widget.currentItem;
              while (currentOld == widget.currentItem)
                widget.currentItem = Random().nextInt(widget.cards.length);
            }),
            child: Text(
              "Próximo",
              style: TextStyle(
                fontSize: 15,
                color: Colors.pinkAccent,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
