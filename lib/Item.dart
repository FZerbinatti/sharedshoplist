class Item{
  String name;
  String crossed;

    Item({
      this.crossed = '0',
      this.name = ''
  });

    Map <String,dynamic>  toJson()=>{
      'crossed' : crossed
    };

    static Item fromJson(Map<String, dynamic> json) => Item(
      crossed: json['crossed']
    );
}