import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:graphic/main.dart';
import 'package:graphic/views/graphic/formGraphic/viewGraphic/ViewGraphicLineBar.dart';
import 'package:graphic/widgets/CustomButtom.dart';
import 'package:graphic/widgets/CustomInputText.dart';
import 'package:validadores/Validador.dart';

//* Média de Gols
class AverageGoals {
  String player;
  List<GoalsByYear> goalsByYear;
  AverageGoals({this.player, this.goalsByYear});
}

class GoalsByYear {
  String year;
  double value;
  GoalsByYear({this.year, this.value});
}

class FormgraphicLineBar extends StatefulWidget {
  final String typeGraphic;
  const FormgraphicLineBar(this.typeGraphic);
  @override
  _FormgraphicLineBarState createState() => _FormgraphicLineBarState();
}

class _FormgraphicLineBarState extends State<FormgraphicLineBar> {
  ScrollController _scrollController;
  final _formKey = GlobalKey<FormState>();
  FocusScopeNode focusScopeNode;
  bool isGerar = false;

  String _idUsuarioLogado;
  String _nomeUsuario;
  String _emailUsuario;
  Map<AverageGoals, dynamic> data;
  String title;

  _showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 100,
              width: 100,
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        });
  }

  Future _salvar(BuildContext context) async {
    _showLoading(context);
    Map<String, dynamic> map = {"titulo": title};
    List<AverageGoals> dados = []; 
    data.forEach((key, value){
      dados.add(key);
    });
    dados.forEach((AverageGoals element) {
      int index = dados.indexOf(element);
      if (index == 0) {
        map.addAll({
          "player1": element.player,
          "values1": {
            "2017": {
              "year": element.goalsByYear[0].year,
              "value": element.goalsByYear[0].value,
            },
            "2018": {
              "year": element.goalsByYear[1].year,
              "value": element.goalsByYear[1].value,
            },
            "2019": {
              "year": element.goalsByYear[2].year,
              "value": element.goalsByYear[2].value,
            },
            "2020": {
              "year": element.goalsByYear[3].year,
              "value": element.goalsByYear[3].value,
            },
          }
        });
      } else if (index == 1) {
        map.addAll({
          "player2": element.player,
          "values2": {
            "2017": {
              "year": element.goalsByYear[0].year,
              "value": element.goalsByYear[0].value,
            },
            "2018": {
              "year": element.goalsByYear[1].year,
              "value": element.goalsByYear[1].value,
            },
            "2019": {
              "year": element.goalsByYear[2].year,
              "value": element.goalsByYear[2].value,
            },
            "2020": {
              "year": element.goalsByYear[3].year,
              "value": element.goalsByYear[3].value,
            },
          }
        });
      } else if (index == 2) {
        map.addAll({
          "player3": element.player,
          "values3": {
            "2017": {
              "year": element.goalsByYear[0].year,
              "value": element.goalsByYear[0].value,
            },
            "2018": {
              "year": element.goalsByYear[1].year,
              "value": element.goalsByYear[1].value,
            },
            "2019": {
              "year": element.goalsByYear[2].year,
              "value": element.goalsByYear[2].value,
            },
            "2020": {
              "year": element.goalsByYear[3].year,
              "value": element.goalsByYear[3].value,
            },
          }
        });
      } else if (index == 3) {
        map.addAll({
          "voce": element.player,
          "values4": {
            "2017": {
              "year": element.goalsByYear[0].year,
              "value": element.goalsByYear[0].value,
            },
            "2018": {
              "year": element.goalsByYear[1].year,
              "value": element.goalsByYear[1].value,
            },
            "2019": {
              "year": element.goalsByYear[2].year,
              "value": element.goalsByYear[2].value,
            },
            "2020": {
              "year": element.goalsByYear[3].year,
              "value": element.goalsByYear[3].value,
            },
          }
        });
      }
    });
    Firestore db = Firestore.instance;
    await db.collection("meus_relatorios")
        .document(_idUsuarioLogado)
        .collection(widget.typeGraphic)
        .add(map)
        .then((_) {
      ////-------------------
      map.addAll({"idUsuario": _idUsuarioLogado});
      map.addAll({"nomeUsuario": _nomeUsuario});
      map.addAll({"emailUsuario": _emailUsuario});
      db.collection("relatorios")
          .document(widget.typeGraphic)
          .collection("graficos")
          .add(map)
          .then((value) {
        ////-------------------
        db.collection("consultas")
            .add({widget.typeGraphic: map})
            .then((value) {
          ////-------------------
          Navigator.pop(context);
        });
      });
    });
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();
    _idUsuarioLogado = firebaseUser.uid;
    Firestore db = Firestore.instance;
    await db
        .collection("usuario")
        .document(_idUsuarioLogado)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      _nomeUsuario = documentSnapshot["nome"];
      _emailUsuario = documentSnapshot["email"];
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: 0.0,
    );
    _recuperarDadosUsuario();
    data = {
      AverageGoals(
        player: "Jogador 1",
        goalsByYear: [
          GoalsByYear(year: "2017"),
          GoalsByYear(year: "2018"),
          GoalsByYear(year: "2019"),
          GoalsByYear(year: "2020"),
        ],
      ): false,
      AverageGoals(
        player: "Jogador 2",
        goalsByYear: [
          GoalsByYear(year: "2017"),
          GoalsByYear(year: "2018"),
          GoalsByYear(year: "2019"),
          GoalsByYear(year: "2020"),
        ],
      ): false,
      AverageGoals(
        player: "Jogador 3",
        goalsByYear: [
          GoalsByYear(year: "2017"),
          GoalsByYear(year: "2018"),
          GoalsByYear(year: "2019"),
          GoalsByYear(year: "2020"),
        ],
      ): false,
      AverageGoals(
        player: "Você",
        goalsByYear: [
          GoalsByYear(year: "2017"),
          GoalsByYear(year: "2018"),
          GoalsByYear(year: "2019"),
          GoalsByYear(year: "2020"),
        ],
      ): false,
    };
  }

  @override
  Widget build(BuildContext context) {
    focusScopeNode = FocusScope.of(context);
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        focusScopeNode.unfocus();
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _showJogadores(size),
          ),
        ),
      ),
    );
  }

  List<Widget> _showJogadores(Size size) {
    List<Widget> list = [];
    list.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: CustomInputText(
          label: "Título",
          keyboardType: TextInputType.text,
          borderRadius: 6,
          cor: defaultTheme.primaryColor,
          onSaved: (titulo) {
            setState(() {
              title = titulo;
            });
          },
          validator: (title) {
            return Validador()
                .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                .valido(title.trim());
          },
        ),
      ),
    );
    data.forEach((key, value) {
      list.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CustomInputText(
                hint: key.player,
                keyboardType: TextInputType.text,
                borderRadius: 6,
                cor: defaultTheme.primaryColor,
                onChanged: (String text) {
                  if (text.length == 1) {
                    setState(() {
                      data[key] = true;
                    });
                  } else if (text.length == 0) {
                    setState(() {
                      data[key] = false;
                    });
                  }
                },
                onSaved: (jogador) {
                  setState(() {
                    key.player = jogador;
                  });
                },
                validator: (jogador) {
                  return Validador()
                      .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                      .valido(jogador.trim());
                },
              ),
              if (data[key] == true)
                Container(
                  margin: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: key.goalsByYear.map((averageGoals) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 46),
                              child: Text(
                                averageGoals.year,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  color: defaultTheme.accentColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: 46),
                              child: CustomInputText(
                                hint: "Nº de Gols ...",
                                keyboardType: TextInputType.number,
                                borderRadius: 6,
                                cor: defaultTheme.primaryColor,
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly,
                                  RealInputFormatter(),
                                ],
                                onSaved: (goals) {
                                  //Remover os Pontos
                                  goals = goals.replaceAll(".", "");
                                  double value = double.tryParse(goals);
                                  int index =
                                      key.goalsByYear.indexOf(averageGoals);
                                  key.goalsByYear[index].value = value;
                                },
                                validator: (value) {
                                  return Validador()
                                      .add(Validar.OBRIGATORIO,
                                          msg: 'Campo obrigatório')
                                      .valido(value.trim());
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      );
    });
    list.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomButtom(
              text: "Gerar",
              cor: defaultTheme.accentColor,
              height: 55,
              width: size.width / 3,
              onTap: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  List<AverageGoals> dados = [];
                  data.forEach((key, value) {
                    dados.add(key);
                  });
                  setState(() => isGerar = true);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Container(
                            height: 500,
                            padding: EdgeInsets.all(10),
                            color: Colors.white,
                            child: Center(
                              child: ViewGraphicLineBar(dados),
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomButtom(
              text: "Salvar",
              cor: defaultTheme.accentColor,
              height: 55,
              width: size.width / 3,
              onTap: () async {
                focusScopeNode.unfocus();
                if (isGerar == true) {
                  await _salvar(context).then((_) {
                    _formKey.currentState.reset();
                    setState(() {
                      isGerar = false;
                      data.forEach((key, value){
                        data[key] = false;
                      });
                    });
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
    return list;
  }
}
