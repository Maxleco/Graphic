import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graphic/Widgets/CardGraphic.dart';
import 'package:graphic/main.dart';
import 'package:graphic/util/GraphicImages.dart';
import 'package:graphic/views/BarGraphic.dart';
import 'package:graphic/views/BarGraphicSemanal.dart';
import 'package:graphic/views/LineGraphic.dart';
import 'package:graphic/views/LineGraphicVendas.dart';
import 'package:graphic/views/PieGraphic.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, String>> listGraphics = [];
  List<String> typesGraphic = [];
  List<String> labelGraphic = [];

  _inicializarDados() {
    listGraphics.forEach((graphic) {
      typesGraphic.add(graphic["type"]);
      labelGraphic.add(graphic["title"]);
    });
  }

  @override
  void initState() {
    super.initState();
    listGraphics = GraphicImages.listGraphics();
    _inicializarDados();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: defaultTheme.primaryColor,
        title: Text("Graphic"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              //Deslogar
              FirebaseAuth auth = FirebaseAuth.instance;
              auth.signOut().then((value) {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/login", (Route<dynamic> route) => false);
              });
            },
          ),
        ],
      ),
      body: Container(
        height: size.height * 0.88,
        child: SingleChildScrollView(
          child: Column(
        
            children: <Widget>[
              Container(
                height: size.height * 0.55,//0.38,
                padding: EdgeInsets.all(8),
                child: PageView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8),
                      child: PieGraphic(
                        namesGraphics: typesGraphic,
                        titlesGraphics: labelGraphic,
                      ),
                    ),
                    Container(
                      height: size.height * 0.55,
                        width: size.width - 16,
                      child: BarGraphic(namesGraphics: typesGraphic,),
                    ),
                    Container(
                      height: size.height * 0.55,
                        width: size.width - 16,
                      child: BarGraphicSemanal(),
                    ),
                    Container(
                      height: size.height * 0.55,
                        width: size.width - 16,
                      child: Center(child: LineGraphic(namesGraphics: typesGraphic,)),
                    ),
                    Container(
                      height: size.height * 0.55,
                        width: size.width - 16,
                      child: Center(child: LineGraphicVendas()),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Column(
                children: listGraphics.map((graphic) {
                  return CardGraphic(
                    text: graphic["title"],
                    url: graphic["url"],
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/relatorios",
                        arguments: graphic,
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
