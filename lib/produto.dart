class Produto {
  int id;
  int quantidade;
  int minimo;
  int maximo;
  num preco;
  String vencimento;
  String entrada;
  int codUsu;
  int codProd;
  int cod;
  String nome;
  double total;

  Produto(
      {this.id,
        this.quantidade,
        this.minimo,
        this.maximo,
        this.preco,
        this.vencimento,
        this.entrada,
        this.codUsu,
        this.codProd,
        this.cod,
        this.nome,
        this.total,
      });

  Produto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantidade = json['quantidade'];
    minimo = json['minimo'];
    maximo = json['maximo'];
    preco = json['preco'];
    vencimento = json['vencimento'];
    entrada = json['entrada'];
    codUsu = json['cod_usu'];
    codProd = json['cod_prod'];
    cod = json['cod'];
    total = json['total'];
    nome = json['nome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantidade'] = this.quantidade;
    data['minimo'] = this.minimo;
    data['maximo'] = this.maximo;
    data['preco'] = this.preco;
    data['vencimento'] = this.vencimento;
    data['entrada'] = this.entrada;
    data['cod_usu'] = this.codUsu;
    data['cod_prod'] = this.codProd;
    data['cod'] = this.cod;
    data['nome'] = this.nome;
    data['total'] = this.total;
    return data;
  }
}


