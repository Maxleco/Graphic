
class Usuario{

  String _nome;
  String _email;

  Usuario();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "nome": this.nome,
      "email": this.email,
    };
    return map;
  }

  String get nome => this._nome;
  set nome(String value) => this._nome = value;

  String get email => this._email;
  set email(String value) => this._email = value;

}