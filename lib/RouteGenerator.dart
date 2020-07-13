import 'package:flutter/material.dart';
import 'package:graphic/views/AddRelatorio.dart';
import 'package:graphic/views/Cadastro.dart';
import 'package:graphic/views/Home.dart';
import 'package:graphic/views/Login.dart';
import 'package:graphic/views/Relatorios.dart';

class RouteGenerator{

  static Route<dynamic> generateRoute(RouteSettings settings){

    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => Login(),
        );
        break;
      case "/login":
        return MaterialPageRoute(
          builder: (_) => Login(),
        );
        break;
      case "/cadastro":
        return MaterialPageRoute(
          builder: (_) => Cadastro(),
        );
        break;
      case "/home":
        return MaterialPageRoute(
          builder: (_) => Home(),
        );
        break;
      case "/relatorios":
        return MaterialPageRoute(
          builder: (_) => Relatorios(args),
        );
        break;
      case "/addRelatorio":
        return MaterialPageRoute(
          builder: (_) => AddRelatorio(args),
        );
        break;
      default:
        _erroRota();
    }

  }

  static Route<dynamic> _erroRota(){
    return MaterialPageRoute(
      builder: (_){
        return Scaffold(
          appBar: AppBar(title: Text("Tela não encontrada")),
          body: Center(
            child: Text("Tela não encontrada"),
          ),
        );
      }
    );
  }

}
