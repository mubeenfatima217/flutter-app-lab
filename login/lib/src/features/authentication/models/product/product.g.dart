// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as String?,
      name: json['name'] as String?,
      category: json['category'] as String?,
      image: json['image'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      quantity: (json['quantity'] as num?)?.toDouble(),
      quantityUnit: json['quantityUnit'] as String?,
      farmerId: json['farmerId'] as String?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'image': instance.image,
      'price': instance.price,
      'quantity': instance.quantity,
      'quantityUnit': instance.quantityUnit,
      'farmerId': instance.farmerId,
    };
