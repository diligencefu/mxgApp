// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserModel _$$_UserModelFromJson(Map<String, dynamic> json) => _$_UserModel(
      alipayAccount: json['alipayAccount'] as String? ?? '',
      alipayName: json['alipayName'] as String? ?? '',
      city: json['city'] as String? ?? '',
      cityCode: json['cityCode'] as String? ?? '',
      county: json['county'] as String? ?? '',
      earliestAppointmentTime: json['earliestAppointmentTime'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      introduction: json['introduction'] as String? ?? '',
      isAuthentication: json['isAuthentication'] as int? ?? 0,
      isGoldmedalRecommend: json['isGoldmedalRecommend'] as int? ?? 0,
      lat: json['lat'] as num? ?? 0,
      lng: json['lng'] as num? ?? 0,
      mobileAuthentication: json['mobileAuthentication'] as int? ?? 0,
      orderReceivingRange: json['orderReceivingRange'] as int? ?? 0,
      province: json['province'] as String? ?? '',
      realnameAuthentication: json['realnameAuthentication'] as int? ?? 0,
      status: json['status'] as int? ?? 0,
    );

Map<String, dynamic> _$$_UserModelToJson(_$_UserModel instance) =>
    <String, dynamic>{
      'alipayAccount': instance.alipayAccount,
      'alipayName': instance.alipayName,
      'city': instance.city,
      'cityCode': instance.cityCode,
      'county': instance.county,
      'earliestAppointmentTime': instance.earliestAppointmentTime,
      'id': instance.id,
      'introduction': instance.introduction,
      'isAuthentication': instance.isAuthentication,
      'isGoldmedalRecommend': instance.isGoldmedalRecommend,
      'lat': instance.lat,
      'lng': instance.lng,
      'mobileAuthentication': instance.mobileAuthentication,
      'orderReceivingRange': instance.orderReceivingRange,
      'province': instance.province,
      'realnameAuthentication': instance.realnameAuthentication,
      'status': instance.status,
    };
