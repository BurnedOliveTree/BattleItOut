import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/dto.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class Talent extends DTO {
  int id;
  String name;
  String? specialisation;
  BaseTalent? baseTalent;
  List<TalentTest> tests;

  int currentLvl = 0;
  bool advancable = false;

  Talent({required this.id, required this.name, this.specialisation, this.baseTalent, this.tests = const []});

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

  BaseTalent(
      {required this.id,
      required this.name,
      required this.description,
      required this.source,
      this.attribute,
      this.constLvl});

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
  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "NAME": name,
      "DESCRIPTION": description,
      "SOURCE": source,
      "MAX_LVL": attribute,
      "CONST_LVL": constLvl
    };
  }
}

class TalentTest extends DTO {
  int testID;
  Talent? talent;
  String? comment;

  BaseSkill? baseSkill;
  Skill? skill;
  Attribute? attribute;

  TalentTest({
    required this.testID,
    required this.talent,
    this.comment,
    this.baseSkill,
    this.skill,
    this.attribute});

  @override
  Map<String, dynamic> toMap() {
    return {
      "TEST_ID": testID,
      "TALENT_ID": talent!.id,
      "COMMENT": comment,
      "BASE_SKILL_ID": baseSkill?.id,
      "SKILL_ID": skill!.id,
      "ATTRIBUTE_ID": attribute!.id
    };
  }
}
