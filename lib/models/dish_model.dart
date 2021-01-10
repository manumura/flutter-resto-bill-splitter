import 'package:flutter/cupertino.dart';

class DishModel {
  DishModel({
    @required this.uuid,
    @required this.name,
    this.price,
    this.guestUuids,
  }) : assert(uuid != null && name != null);

  String uuid;
  String name;
  double price;
  List<String> guestUuids = <String>[];

  double getPriceWithTax({@required double taxAsPercentage}) {
    if (taxAsPercentage == null ||
        taxAsPercentage < 0 ||
        taxAsPercentage > 100) {
      return price;
    }
    return price * (1 + taxAsPercentage / 100);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DishModel &&
          runtimeType == other.runtimeType &&
          uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() {
    return 'DishModel{uuid: $uuid, name: $name, price: $price, guestUuids: $guestUuids}';
  }
}
