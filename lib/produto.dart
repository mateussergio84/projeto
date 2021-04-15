class Produto {
  int id;
  int cod;
  String nome;
  int quantidade;
  num preco;
  int minimo;
  int maximo;
  String vencimento;
  String data;
  num total;
  String quant;

  Produto(
      {this.id,
      this.cod,
      this.nome,
      this.quantidade,
      this.preco,
      this.minimo,
      this.maximo,
      this.vencimento,
      this.data,
      this.total,
      this.quant});

  Produto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cod = json['cod'];
    nome = json['nome'];
    quantidade = json['quantidade'];
    preco = json['preco'];
    minimo = json['minimo'];
    maximo = json['maximo'];
    vencimento = json['vencimento'];
    data = json['data'];
    total = json['total'];
    quant = json['quant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cod'] = this.cod;
    data['nome'] = this.nome;
    data['quantidade'] = this.quantidade;
    data['preco'] = this.preco;
    data['minimo'] = this.minimo;
    data['maximo'] = this.maximo;
    data['vencimento'] = this.vencimento;
    data['data'] = this.data;
    data['total'] = this.total;
    data['quant'] = this.quant;
    return data;
  }
}

