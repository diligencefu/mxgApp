// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    @Default('') String alipayAccount,
    @Default('') String alipayName,
    @Default('') String city,
    @Default('') String cityCode,
    @Default('') String county,
    @Default('') String earliestAppointmentTime,
    @Default(0) int id,
    @Default('') String introduction,
    @Default(0) int isAuthentication,
    @Default(0) int isGoldmedalRecommend,
    @Default(0) num lat,
    @Default(0) num lng,
    @Default(0) int mobileAuthentication,
    @Default(0) int orderReceivingRange,
    @Default('') String province,
    @Default(0) int realnameAuthentication,
    @Default(0) int status,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
