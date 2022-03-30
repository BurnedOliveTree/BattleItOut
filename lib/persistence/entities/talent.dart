import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/dto.dart';

class Talent extends DTO {
  int id;
  String name;
  String? specialisation;
  BaseTalent? baseTalent;

  int currentLvl = 0;
  bool advancable = false;

  Talent({required this.id, required this.name, this.specialisation, this.baseTalent});

  bool isSpecialised() {
    return specialisation != null;
  }

  int? getMaxLvl() {
    return baseTalent!.getMaxLvl();
  }

  @override
  String toString() {
    return "Talent (id=$id, name=$name)";
  }

  @override
  Map<String, dynamic> toMap() {
    return {"ID": id, "NAME": name, "SPECIALISATION": specialisation, "BASE_TALENT": baseTalent?.id};
  }
}

class BaseTalent extends DTO {
  int id;
  String name;
  String description;
  String source;
  Attribute? attribute;
  int? constLvl;
  bool grouped;

  BaseTalent(
      {required this.id,
      required this.name,
      required this.description,
      required this.source,
      this.attribute,
      this.constLvl,
      required this.grouped});

  int? getMaxLvl() {
    if (attribute != null) {
      return attribute!.getTotalValue() ~/ 10;
    }
    if (constLvl != null) {
      return constLvl;
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BaseTalent &&
              id == other.id &&
              name == other.name &&
              description == other.description &&
              source == other.source &&
              grouped == other.grouped &&
              attribute == other.attribute &&
              constLvl == other.constLvl;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode ^ constLvl.hashCode ^ source.hashCode ^ grouped.hashCode ^ attribute.hashCode;

  @override
  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "NAME": name,
      "DESCRIPTION": description,
      "SOURCE": source,
      "MAX_LVL": attribute,
      "CONST_LVL": constLvl,
      "GROUPED": grouped ? 1 : 0
    };
  }
}
