import 'package:flutter/src/material/list_tile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "category")
  String? category;

  @JsonKey(name: "image")
  String? image;

  @JsonKey(name: "price")
  double? price;

  @JsonKey(name: "quantity")
  double? quantity;

  @JsonKey(name: "quantityUnit")
  String? quantityUnit;

  @JsonKey(name: "farmerId")
  String? farmerId;

  Product({
    this.id,
    this.name,
    this.category,
    this.image,
    this.price,
    this.quantity,
    this.quantityUnit,
    required this.farmerId, // Ensure correct initialization
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

}
