import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graphic/main.dart';
import 'package:graphic/views/graphic/formGraphic/viewGraphic/ViewGraphicBarHorizontal.dart';
import 'package:graphic/views/graphic/formGraphic/viewGraphic/ViewGraphicLine.dart';
import 'package:graphic/views/graphic/formGraphic/viewGraphic/ViewGraphicLineBar.dart';
import 'package:graphic/views/graphic/formGraphic/viewGraphic/ViewGraphicPie.dart';
import 'package:graphic/views/graphic/formGraphic/viewGraphic/ViewGraphicPieLegend.dart';

import 'graphic/formGraphic/viewGraphic/ViewGraphicBar.dart';

class Relatorios extends StatefulWidget {
  final Map<String, String> opGraphic;
  Relatorios(this.opGraphic);
  @override
  _RelatoriosState createState() => _RelatoriosState();
}

class _RelatoriosState extends State<Relatorios> {
  final _controller = StreamController<QuerySnapshot>.broadcast();

  Map<String, String> _graphic;

  Future<Stream<QuerySnapshot>> _recuperandoDadosGraficos() {
    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("relatorios")
        .document(_graphic["type"])
        .collection("graficos")
        .snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
    _graphic = widget.opGraphic;
    _recuperandoDadosGraficos();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: defaultTheme.primaryColor,
        title: Text("Relatorios"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          Widget defaultWidget;
          if (snapshot.connectionState == ConnectionState.waiting) {
            defaultWidget = Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Text("Carregando Relatorios"),
                  SizedBox(height: 5),
                  CircularProgressIndicator(),
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              defaultWidget = Center(child: Text("Erro ao carregar dados!"));
            } else {
              QuerySnapshot querySnapshot = snapshot.data;
              if (querySnapshot.documents.length == 0) {
                return Container(
                  child: Center(
                      child: Text(
                    "Nenhum relatório salvo :(",
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                );
              }
              defaultWidget = ListView.separated(
                itemCount: querySnapshot.documents.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  List<DocumentSnapshot> relatorios =
                      querySnapshot.documents.toList();
                  DocumentSnapshot documentSnapshot = relatorios[index];
                  Map<String, dynamic> result;
                  //?-----------------------------------------------------------
                  //? Gráfico de barra
                  if (_graphic["type"] == "bar") {
                    result = _getBar(documentSnapshot);
                    return ListTile(
                      title: Text(
                        result["titulo"],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      isThreeLine: true,
                      subtitle: _getSubText(result),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text(result["titulo"]),
                                ),
                                body: Container(
                                  padding: EdgeInsets.all(16),
                                  height: size.height,
                                  child: Center(
                                    child: ViewGraphicBar.fromMap(result),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                  //?-----------------------------------------------------------
                  //? Gráfico de barra horizontal
                  else if (_graphic["type"] == "barHorizontal") {
                    result = _getBarHorizontal(documentSnapshot);
                    return ListTile(
                      title: Text(
                        result["titulo"],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      isThreeLine: true,
                      subtitle: _getSubText(result),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text(result["titulo"]),
                                ),
                                body: Container(
                                  padding: EdgeInsets.all(16),
                                  height: size.height,
                                  child: Center(
                                    child: ViewGraphicBarHorizontal.fromMap(
                                        result),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } 
                  //?-----------------------------------------------------------
                  //? Gráfico de barra e Linha
                  else if (_graphic["type"] == "lineBar") {
                    result = _getLineBar(documentSnapshot);
                    return ListTile(
                      title: Text(
                        result["titulo"],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      isThreeLine: true,
                      subtitle: _getSubText(result),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text(result["titulo"]),
                                ),
                                body: Container(
                                  padding: EdgeInsets.all(16),
                                  height: size.height,
                                  child: Center(
                                    child: ViewGraphicLineBar.fromMap(
                                        result),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                  //?-----------------------------------------------------------
                  //? Gráfico de Linha
                  else if (_graphic["type"] == "line") {
                    result = _getLine(documentSnapshot);
                    return ListTile(
                      title: Text(
                        result["titulo"],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      isThreeLine: true,
                      subtitle: _getSubText(result),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text(result["titulo"]),
                                ),
                                body: Container(
                                  padding: EdgeInsets.all(16),
                                  height: size.height,
                                  child: Center(
                                    child: ViewGraphicLine.fromMap(
                                        result),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                  //?-----------------------------------------------------------
                  //? Gráfico de Pizza
                  else if (_graphic["type"] == "pie") {
                    result = _getPie(documentSnapshot);
                    return ListTile(
                      title: Text(
                        result["titulo"],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      isThreeLine: true,
                      subtitle: _getSubText(result),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text(result["titulo"]),
                                ),
                                body: Container(
                                  padding: EdgeInsets.all(16),
                                  height: size.height,
                                  child: Center(
                                    child: ViewGraphicPie.fromMap(
                                        result),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                  //?-----------------------------------------------------------
                  //? Gráfico de Pizza Legendada
                  else if (_graphic["type"] == "pieLegend") {
                    result = _getPieLegend(documentSnapshot);
                    return ListTile(
                      title: Text(
                        result["titulo"],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      isThreeLine: true,
                      subtitle: _getSubText(result),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Scaffold(
                                appBar: AppBar(
                                  title: Text(result["titulo"]),
                                ),
                                body: Container(
                                  padding: EdgeInsets.all(16),
                                  height: size.height,
                                  child: Center(
                                    child: ViewGraphicPieLegend.fromMap(
                                        result),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              );
            }
          } else {
            defaultWidget = Container();
          }
          return defaultWidget;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/addRelatorio",
            arguments: _graphic,
          );
        },
        backgroundColor: defaultTheme.primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _getSubText(Map<String, dynamic> result) {
    Text subText;
    String text = result["nomeUsuario"] + "\n";
    if (_graphic["type"] == "bar") {
      text += result["segunda"].toString() +
          " - " +
          result["terca"].toString() +
          " - ";
      text += result["quarta"].toString() +
          " - " +
          result["quinta"].toString() +
          " - ";
      text += result["sexta"].toString();
    } 
    else if (_graphic["type"] == "barHorizontal") {
      result.forEach((key, value) {
        if (key != "idUsuario" &&
            key != "titulo" &&
            key != "nomeUsuario" &&
            key != "emailUsuario") {
          text = text + " | " + key;
        }
      });
      text += " | ";
    } 
    else if (_graphic["type"] == "lineBar") {
      text += result["player1"] + " - " + result["player2"] + " - ";
      text += result["player3"] + " - " + result["voce"] + " - ";
    } 
    else if (_graphic["type"] == "line") {
      text += result["value1"].toString() + " - " + result["value2"].toString() + " - ";
      text += result["value3"].toString() + " - " + result["value4"].toString();
    } 
    else if (_graphic["type"] == "pie") {
      text += result["name1"].toString() + " - " + result["name2"].toString() + " - ";
      text += result["name3"].toString() + " - " + result["name4"].toString();
    }
    else if (_graphic["type"] == "pieLegend") {
      text += result["value1"].toString() + " - " + result["value2"].toString() + " - ";
      text += result["value3"].toString() + " - " + result["value4"].toString() + " - ";
      text += result["value5"].toString();
    }
    subText = Text(
      text,
      style: TextStyle(
        color: Colors.grey,
      ),
    );
    return subText;
  }

  _getBar(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> map = {
      "nomeUsuario": documentSnapshot["nomeUsuario"],
      "titulo": documentSnapshot["titulo"],
      "segunda": documentSnapshot["segunda"],
      "terca": documentSnapshot["terca"],
      "quarta": documentSnapshot["quarta"],
      "quinta": documentSnapshot["quinta"],
      "sexta": documentSnapshot["sexta"],
    };
    return map;
  }

  _getBarHorizontal(DocumentSnapshot documentSnapshot) {
    return documentSnapshot.data;
  }

  _getLineBar(DocumentSnapshot documentSnapshot) {
    return documentSnapshot.data;
  }

  _getLine(DocumentSnapshot documentSnapshot) {
    return documentSnapshot.data;
  }

  _getPie(DocumentSnapshot documentSnapshot) {
    return documentSnapshot.data;
  }

  _getPieLegend(DocumentSnapshot documentSnapshot) {
    return documentSnapshot.data;
  }
}
