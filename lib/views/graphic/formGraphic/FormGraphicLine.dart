import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphic/main.dart';
import 'package:graphic/util/Configuracoes.dart';
import 'package:graphic/views/graphic/formGraphic/viewGraphic/ViewGraphicLine.dart';
import 'package:graphic/widgets/CustomButtom.dart';
import 'package:graphic/widgets/CustomInputText.dart';
import 'package:validadores/Validador.dart';

class QuarterlyAverage {
  DateTime date;
  double value;
  QuarterlyAverage({this.date, this.value});
}

class FormGraphicLine extends StatefulWidget {
  final String typeGraphic;
  const FormGraphicLine(this.typeGraphic);
  @override
  _FormGraphicBarHoLineState createState() => _FormGraphicBarHoLineState();
}

class _FormGraphicBarHoLineState extends State<FormGraphicLine> {
  ScrollController _scrollController;
  final _formKey = GlobalKey<FormState>();
  FocusScopeNode focusScopeNode;
  bool isGerar = false;

  String _idUsuarioLogado;
  String _nomeUsuario;
  String _emailUsuario;
  List<QuarterlyAverage> data = [
    QuarterlyAverage(),
    QuarterlyAverage(),
    QuarterlyAverage(),
    QuarterlyAverage(),
  ];
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
    Map<String, dynamic> map = {
      "titulo": title,
      "data1": data[0].date,
      "value1": data[0].value,
      "data2": data[1].date,
      "value2": data[1].value,
      "data3": data[2].date,
      "value3": data[2].value,
      "data4": data[3].date,
      "value4": data[3].value,
    };
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: size.height - (size.height * 0.23),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
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
                              .add(Validar.OBRIGATORIO,
                                  msg: 'Campo obrigatório')
                              .valido(title.trim());
                        },
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: CustomInputText(
                            hint: "Primeira Data",
                            keyboardType: TextInputType.number,
                            borderRadius: 6,
                            cor: defaultTheme.primaryColor,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              DataInputFormatter(),
                            ],
                            onSaved: (data1) {
                              List<String> numData = data1.split("/");
                               DateTime dateTime = DateTime(
                                 int.tryParse(numData[2]),
                                 int.tryParse(numData[1]),
                                 int.tryParse(numData[0]),
                               );
                              setState(() {
                                data[0].date = dateTime;
                              });
                            },
                            validator: (segunda) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: 'Campo obrigatório')
                                  .valido(segunda.trim());
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomInputText(
                            hint: "Nº de Pontos",
                            keyboardType: TextInputType.number,
                            borderRadius: 6,
                            cor: defaultTheme.primaryColor,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              RealInputFormatter(),
                            ],
                            onSaved: (pontos) {
                              //Remover os Pontos
                              pontos = pontos.replaceAll(".", "");
                              double value = double.tryParse(pontos);
                              setState(() {
                                setState(() {
                                  data[0].value = value;
                                });
                              });
                            },
                            validator: (segunda) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: 'Campo obrigatório')
                                  .valido(segunda.trim());
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: CustomInputText(
                            hint: "Segunda Data",
                            keyboardType: TextInputType.number,
                            borderRadius: 6,
                            cor: defaultTheme.primaryColor,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              DataInputFormatter(),
                            ],
                            onSaved: (data1) {
                              List<String> numData = data1.split("/");
                               DateTime dateTime = DateTime(
                                 int.tryParse(numData[2]),
                                 int.tryParse(numData[1]),
                                 int.tryParse(numData[0]),
                               );
                              setState(() {
                                data[1].date = dateTime;
                              });
                            },
                            validator: (segunda) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: 'Campo obrigatório')
                                  .valido(segunda.trim());
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomInputText(
                            hint: "Nº de Pontos",
                            keyboardType: TextInputType.number,
                            borderRadius: 6,
                            cor: defaultTheme.primaryColor,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              RealInputFormatter(),
                            ],
                            onSaved: (pontos) {
                              //Remover os Pontos
                              pontos = pontos.replaceAll(".", "");
                              double value = double.tryParse(pontos);
                              setState(() {
                                setState(() {
                                  data[1].value = value;
                                });
                              });
                            },
                            validator: (segunda) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: 'Campo obrigatório')
                                  .valido(segunda.trim());
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: CustomInputText(
                            hint: "Terceira Data",
                            keyboardType: TextInputType.number,
                            borderRadius: 6,
                            cor: defaultTheme.primaryColor,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              DataInputFormatter(),
                            ],
                            onSaved: (data1) {
                              List<String> numData = data1.split("/");
                               DateTime dateTime = DateTime(
                                 int.tryParse(numData[2]),
                                 int.tryParse(numData[1]),
                                 int.tryParse(numData[0]),
                               );
                              setState(() {
                                data[2].date = dateTime;
                              });
                            },
                            validator: (segunda) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: 'Campo obrigatório')
                                  .valido(segunda.trim());
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomInputText(
                            hint: "Nº de Pontos",
                            keyboardType: TextInputType.number,
                            borderRadius: 6,
                            cor: defaultTheme.primaryColor,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              RealInputFormatter(),
                            ],
                            onSaved: (pontos) {
                              //Remover os Pontos
                              pontos = pontos.replaceAll(".", "");
                              double value = double.tryParse(pontos);
                              setState(() {
                                setState(() {
                                  data[2].value = value;
                                });
                              });
                            },
                            validator: (segunda) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: 'Campo obrigatório')
                                  .valido(segunda.trim());
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: CustomInputText(
                            hint: "Quarta Data",
                            keyboardType: TextInputType.number,
                            borderRadius: 6,
                            cor: defaultTheme.primaryColor,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              DataInputFormatter(),
                            ],
                            onSaved: (data1) {
                              List<String> numData = data1.split("/");
                               DateTime dateTime = DateTime(
                                 int.tryParse(numData[2]),
                                 int.tryParse(numData[1]),
                                 int.tryParse(numData[0]),
                               );
                              setState(() {
                                data[3].date = dateTime;
                              });
                            },
                            validator: (segunda) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: 'Campo obrigatório')
                                  .valido(segunda.trim());
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomInputText(
                            hint: "Nº de Pontos",
                            keyboardType: TextInputType.number,
                            borderRadius: 6,
                            cor: defaultTheme.primaryColor,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              RealInputFormatter(),
                            ],
                            onSaved: (pontos) {
                              //Remover os Pontos
                              pontos = pontos.replaceAll(".", "");
                              double value = double.tryParse(pontos);
                              setState(() {
                                setState(() {
                                  data[3].value = value;
                                });
                              });
                            },
                            validator: (segunda) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: 'Campo obrigatório')
                                  .valido(segunda.trim());
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
                        if (isGerar == false) {
                          setState(() {
                            isGerar = true;
                          });
                        }                        
                        Future.delayed(
                          Duration(milliseconds: 100),
                          () {
                            _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent,
                            );
                          },
                        );
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
                      if (isGerar == true) {
                        await _salvar(context).then((_) {
                          _formKey.currentState.reset();
                          setState(() {
                            isGerar = false;
                            data.clear();
                          });
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            ////----------------------------------------
            ///Graphic
            if (isGerar == true)
              Container(
                height: size.height,
                child: Center(
                  child: ViewGraphicLine(data),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
