import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graphic/Widgets/CustomButtom.dart';
import 'package:graphic/Widgets/CustomInputText.dart';
import 'package:graphic/model/Usuario.dart';
import 'package:validadores/Validador.dart';

import '../main.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _formKey = GlobalKey<FormState>();
  FocusScopeNode focusScopeNode;
  String _nome;
  String _email;
  String _senha;
  bool _isLoading = false;
  String _messagemError;

  loading(bool value) {
    setState(() {
      _messagemError = null;
      _isLoading = value;
    });
  }

  _cadastrar() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth
        .createUserWithEmailAndPassword(
      email: _email,
      password: _senha,
    ).then((AuthResult firebaseUser) {
      loading(false);
      //--------------------------------
      Usuario usuario = Usuario();
      usuario.nome = _nome;
      usuario.email = _email;
      Firestore.instance
        .collection("usuario")
        .document(firebaseUser.user.uid)
        .setData(usuario.toMap()).then((value){
          //Redirecionar para Tela Principal
          Navigator.pushNamedAndRemoveUntil(
              context, "/home", (Route<dynamic> route) => false);
        }); 
    }).catchError((e) {
      loading(false);
      setState(() {
        _messagemError = e.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    focusScopeNode = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultTheme.primaryColor,
        title: Text("Cadastro de Usuário"),
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          focusScopeNode.unfocus();
        },
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 300,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400],
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CustomInputText(
                          label: "Nome",
                          cor: defaultTheme.primaryColor,
                          onSaved: (nome) {
                            setState(() {
                              _nome = nome;
                            });
                          },
                          validator: (nome) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: 'Campo obrigatório')
                                .valido(nome);
                          },
                        ),
                        CustomInputText(
                          label: "Email",
                          hint: "example@gmail.com",
                          cor: defaultTheme.primaryColor,
                          onSaved: (email) {
                            setState(() {
                              _email = email.trim();
                            });
                          },
                          validator: (email) {
                            return Validador()
                                .add(Validar.EMAIL, msg: 'EMAIL Inválido')
                                .add(Validar.OBRIGATORIO,
                                    msg: 'Campo obrigatório')
                                .valido(email);
                          },
                        ),
                        CustomInputText(
                          label: "Senha",
                          hint: "*******",
                          obscureText: true,
                          cor: defaultTheme.primaryColor,
                          onSaved: (senha) {
                            setState(() {
                              _senha = senha;
                            });
                          },
                          validator: (senha) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: 'Campo obrigatório')
                                .minLength(6, msg: "Mínimo de 6 caracteres")
                                .valido(senha);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                CustomButtom(
                  text: "Cadastrar",
                  cor: defaultTheme.accentColor,
                  height: 55,
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      loading(true);
                      _formKey.currentState.save();
                      _cadastrar();
                    }
                  },
                ),
                if (_isLoading == true)
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(top: 15),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (_messagemError != null)
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(top: 15),
                    child: Center(
                      child: Text(
                        _messagemError,
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
