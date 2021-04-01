class Gasto {
  num total;
  String itens;

  Gasto({this.total, this.itens});

  Gasto.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    itens = json['itens'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['itens'] = this.itens;
    return data;
  }
}