import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphic/main.dart';
import 'package:graphic/util/Configuracoes.dart';
import 'package:graphic/views/graphic/formGraphic/viewGraphic/ViewGraphicBarHorizontal.dart';
import 'package:graphic/widgets/CustomButtom.dart';
import 'package:graphic/widgets/CustomInputText.dart';
import 'package:validadores/Validador.dart';

//* Rendimento por Região
class IncomeByRegion {
  String region;
  double value;
  IncomeByRegion({this.region, this.value});
}

class FormGraphicBarHorizontal extends StatefulWidget {
  final String typeGraphic;
  const FormGraphicBarHorizontal(this.typeGraphic);
  @override
  _FormGraphicBarHorizontalState createState() =>
      _FormGraphicBarHorizontalState();
}

class _FormGraphicBarHorizontalState extends State<FormGraphicBarHorizontal> {
  ScrollController _scrollController;
  final _formKey = GlobalKey<FormState>();
  FocusScopeNode focusScopeNode;
  bool isGerar = false;

  String _idUsuarioLogado;
  String _nomeUsuario;
  String _emailUsuario;
  List<DropdownMenuItem<String>> _listItensDropEstado = List();
  List<IncomeByRegion> data = [];
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
      "titulo": title
    };
    for(var item in data){
      map.addAll({item.region: item.value});
    }
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
    await db.collection("usuario")
      .document(_idUsuarioLogado)
      .get()
    .then((DocumentSnapshot documentSnapshot){
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
    _listItensDropEstado = Configuracoes.getEstados();
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

                    Container(
                      height: data.length == 5
                          ? (60 * data.length.toDouble()) + 50
                          : (60 * data.length.toDouble()) + 90,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: data.length + 1,
                        itemBuilder: (context, index) {
                          Widget defaultWidget = Container();
                          if (index == data.length) {
                            defaultWidget = Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    data.add(IncomeByRegion());
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[400],
                                  radius: 25,
                                  child: Icon(
                                    Icons.add_circle,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                            if (data.length == 5) {
                              defaultWidget = Container();
                            }
                          } else if (data.length > 0) {
                            defaultWidget = Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButtonFormField(
                                        value: data[index].region,
                                        hint: Text("Estados"),
                                        onSaved: (estado) {
                                          data[index].region = estado;
                                        },
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                        items: _listItensDropEstado,
                                        validator: (String value) {
                                          return Validador()
                                              .add(Validar.OBRIGATORIO,
                                                  msg: "Campo Obrigatório")
                                              .valido(value);
                                        },
                                        onChanged: (String value) {
                                          setState(() {
                                            data[index].region = value;
                                          });
                                        }),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CustomInputText(
                                    hint: "R\$ ---",
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
                                        data[index].value = value;
                                      });
                                    },
                                    validator: (value) {
                                      return Validador()
                                          .add(Validar.OBRIGATORIO,
                                              msg: 'Campo obrigatório')
                                          .valido(value.trim());
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                          return defaultWidget;
                        },
                      ),
                    ),

                    //*------------------------------------------------------
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
                      focusScopeNode.unfocus();
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
                  child: ViewGraphicBarHorizontal(data),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
