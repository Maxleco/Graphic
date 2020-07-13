import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graphic/Widgets/CustomButtom.dart';
import 'package:graphic/Widgets/CustomInputText.dart';
import 'package:validadores/Validador.dart';

import '../main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  FocusScopeNode focusScopeNode;
  String _email;
  String _senha;
  bool _isLoading = false;

  loading(bool value){
    setState(() {
      _isLoading = value;
    });
  }

  _logar() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signInWithEmailAndPassword(
      email: _email,
      password: _senha,
    ).then((firebaseUser) {
      loading(false);
      //Redirecionar para Tela Principal
      Navigator.pushNamedAndRemoveUntil(
          context, "/home", (Route<dynamic> route) => false);
    });

  }

  _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.currentUser().then((FirebaseUser firebaseUser){
      if(firebaseUser != null){
        Navigator.pushNamedAndRemoveUntil(
          context, "/home", (Route<dynamic> route) => false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    focusScopeNode = FocusScope.of(context);

    return Scaffold(
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
                  height: 175,
                  child: Image.asset(
                    "images/graphic.png",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  height: 200,
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
                          label: "Email",
                          hint: "example@gmail.com",
                          keyboardType: TextInputType.emailAddress,
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
                                .valido(email.trim());
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
                  text: "Entrar",
                  cor: defaultTheme.accentColor,
                  height: 55,
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      loading(true);
                      _formKey.currentState.save();
                      _logar();
                    }
                  },
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/cadastro");
                  },
                  child: Text(
                    "Cadastrar-se",
                    style: TextStyle(
                      color: defaultTheme.accentColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_isLoading == true)
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(top: 15),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
