class pesquisa {
	String code;
	String company;
	String description;
	String imageUrl;
	String size;
	String status;

	pesquisa({this.code, this.company, this.description, this.imageUrl, this.size, this.status});

	pesquisa.fromJson(Map<String, dynamic> json) {
		code = json['code'];
		company = json['company'];
		description = json['description'];
		imageUrl = json['image_url'];
		size = json['size'];
		status = json['status'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['code'] = this.code;
		data['company'] = this.company;
		data['description'] = this.description;
		data['image_url'] = this.imageUrl;
		data['size'] = this.size;
		data['status'] = this.status;
		return data;
	}
}