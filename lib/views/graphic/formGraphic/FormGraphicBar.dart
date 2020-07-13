import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphic/main.dart';
import 'package:graphic/views/graphic/formGraphic/viewGraphic/ViewGraphicBar.dart';
import 'package:graphic/widgets/CustomButtom.dart';
import 'package:graphic/widgets/CustomInputText.dart';
import 'package:validadores/Validador.dart';

//* Rendimento Diário
class DailyIncome {
  final String day;
  final double value;
  DailyIncome(this.day, this.value);
}

class FormGraphicBar extends StatefulWidget {
  final String typeGraphic;
  const FormGraphicBar(this.typeGraphic);
  @override
  _FormGraphicBarState createState() => _FormGraphicBarState();
}

class _FormGraphicBarState extends State<FormGraphicBar> {
  ScrollController _scrollController;
  final _formKey = GlobalKey<FormState>();
  FocusScopeNode focusScopeNode;
  bool isGerar = false;

  String _idUsuarioLogado;
  String _nomeUsuario;
  String _emailUsuario;
  List<DailyIncome> data = [];
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
      "segunda": data[0].value,
      "terca": data[1].value,
      "quarta": data[2].value,
      "quinta": data[3].value,
      "sexta": data[4].value,
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
                    CustomInputText(
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
                    CustomInputText(
                      hint: "Segunda",
                      keyboardType: TextInputType.number,
                      borderRadius: 6,
                      cor: defaultTheme.primaryColor,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        RealInputFormatter(centavos: true),
                      ],
                      onSaved: (segunda) {
                        //Remover os Pontos
                        segunda = segunda.replaceAll(".", "");
                        //Substituir a virgula pelo ponto decimal
                        segunda = segunda.replaceAll(",", ".");
                        double value = double.tryParse(segunda);
                        setState(() {
                          data.add(
                            DailyIncome("Segunda", value),
                          );
                        });
                      },
                      validator: (segunda) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                            .valido(segunda.trim());
                      },
                    ),
                    CustomInputText(
                      hint: "Terça",
                      keyboardType: TextInputType.number,
                      borderRadius: 6,
                      cor: defaultTheme.primaryColor,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        RealInputFormatter(centavos: true),
                      ],
                      onSaved: (terca) {
                        //Remover os Pontos
                        terca = terca.replaceAll(".", "");
                        //Substituir a virgula pelo ponto decimal
                        terca = terca.replaceAll(",", ".");
                        double value = double.tryParse(terca);
                        setState(() {
                          data.add(
                            DailyIncome("Terça", value),
                          );
                        });
                      },
                      validator: (terca) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                            .valido(terca.trim());
                      },
                    ),
                    CustomInputText(
                      hint: "Quarta",
                      keyboardType: TextInputType.number,
                      borderRadius: 6,
                      cor: defaultTheme.primaryColor,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        RealInputFormatter(centavos: true),
                      ],
                      onSaved: (quarta) {
                        //Remover os Pontos
                        quarta = quarta.replaceAll(".", "");
                        //Substituir a virgula pelo ponto decimal
                        quarta = quarta.replaceAll(",", ".");
                        double value = double.tryParse(quarta);
                        setState(() {
                          data.add(
                            DailyIncome("Quarta", value),
                          );
                        });
                      },
                      validator: (quarta) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                            .valido(quarta.trim());
                      },
                    ),
                    CustomInputText(
                      hint: "Quinta",
                      keyboardType: TextInputType.number,
                      borderRadius: 6,
                      cor: defaultTheme.primaryColor,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        RealInputFormatter(centavos: true),
                      ],
                      onSaved: (quinta) {
                        //Remover os Pontos
                        quinta = quinta.replaceAll(".", "");
                        //Substituir a virgula pelo ponto decimal
                        quinta = quinta.replaceAll(",", ".");
                        double value = double.tryParse(quinta);
                        setState(() {
                          data.add(
                            DailyIncome("Quinta", value),
                          );
                        });
                      },
                      validator: (quinta) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                            .valido(quinta.trim());
                      },
                    ),
                    CustomInputText(
                      hint: "Sexta",
                      keyboardType: TextInputType.number,
                      borderRadius: 6,
                      cor: defaultTheme.primaryColor,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        RealInputFormatter(centavos: true),
                      ],
                      onSaved: (sexta) {
                        //Remover os Pontos
                        sexta = sexta.replaceAll(".", "");
                        //Substituir a virgula pelo ponto decimal
                        sexta = sexta.replaceAll(",", ".");
                        double value = double.tryParse(sexta);
                        setState(() {
                          data.add(
                            DailyIncome("Sexta", value),
                          );
                        });
                      },
                      validator: (sexta) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                            .valido(sexta.trim());
                      },
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
                  child: ViewGraphicBar(data),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
