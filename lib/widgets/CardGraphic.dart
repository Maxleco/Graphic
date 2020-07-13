import 'package:flutter/material.dart';

class CardGraphic extends StatelessWidget {
  final String text;
  final String url;
  final Function onTap;

  CardGraphic({
    @required this.text,
    this.url,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Card(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(this.url),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(left: 15),
                alignment: Alignment.center,
                child: Text(
                  this.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Courier New",
                    fontSize: 25,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
