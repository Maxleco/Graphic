import 'package:brasil_fields/formatter/real_input_formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphic/main.dart';
import 'package:graphic/views/graphic/formGraphic/viewGraphic/ViewGraphicPieLegend.dart';
import 'package:graphic/widgets/CustomButtom.dart';
import 'package:graphic/widgets/CustomInputText.dart';
import 'package:validadores/Validador.dart';

class CoronaRegion {
  String region;
  double value;
  CoronaRegion({this.region, this.value});
}

class FormGraphicPieLegend extends StatefulWidget {
  final String typeGraphic;
  const FormGraphicPieLegend(this.typeGraphic);
  @override
  _FormGraphicPieLegendState createState() => _FormGraphicPieLegendState();
}

class _FormGraphicPieLegendState extends State<FormGraphicPieLegend> {
  ScrollController _scrollController;
  final _formKey = GlobalKey<FormState>();
  FocusScopeNode focusScopeNode;
  bool isGerar = false;

  String _idUsuarioLogado;
  String _nomeUsuario;
  String _emailUsuario;
  List<CoronaRegion> data = [
    CoronaRegion(region: "Norte"),
    CoronaRegion(region: "Nordeste"),
    CoronaRegion(region: "Centro-Oeste"),
    CoronaRegion(region: "Sudeste"),
    CoronaRegion(region: "Sul"),
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
      "region1": data[0].region,
      "value1": data[0].value,
      "region2": data[1].region,
      "value2": data[1].value,
      "region3": data[2].region,
      "value3": data[2].value,
      "region4": data[3].region,
      "value4": data[3].value,
      "region5": data[4].region,
      "value5": data[4].value,
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
        padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
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
    ////-----------------------------------------------------------------
    list.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: data.map((coronaRegion) {
            return Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      coronaRegion.region,
                      style: TextStyle(
                        color: defaultTheme.accentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CustomInputText(
                      hint: "Nº de Casos",
                      keyboardType: TextInputType.number,
                      borderRadius: 6,
                      cor: defaultTheme.primaryColor,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        RealInputFormatter(),
                      ],
                      onSaved: (casos) {
                        //Remover os Pontos
                        casos = casos.replaceAll(".", "");
                        double valueCasos = double.tryParse(casos);
                        int index = data.indexOf(coronaRegion);
                        data[index].value = valueCasos;
                      },
                      validator: (value) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
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
    );
    ////-----------------------------------------------------------------
    list.add(
      Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Row(
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
                    setState(() => isGerar = true);                    
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: Container(
                              height: 400,
                              padding: EdgeInsets.all(10),
                              color: Colors.white,
                              child: Center(
                                child: ViewGraphicPieLegend(data),
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
                        data.forEach((element){
                          int index = data.indexOf(element);
                          data[index].value = null;
                        });
                      });
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
    return list;
  }
}
