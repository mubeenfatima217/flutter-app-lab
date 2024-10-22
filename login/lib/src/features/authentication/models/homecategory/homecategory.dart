import 'package:json_annotation/json_annotation.dart';

part 'homecategory.g.dart'; // This is the generated file that will contain serialization logic

@JsonSerializable()
class HomeCategory {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "image")
  String? image;

  HomeCategory({
    this.id,
    this.name,
    this.image,
  });

  factory HomeCategory.fromJson(Map<String, dynamic> json) => _$HomeCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$HomeCategoryToJson(this);
}