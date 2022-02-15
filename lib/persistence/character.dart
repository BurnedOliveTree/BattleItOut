import 'dart:convert';
import 'package:battle_it_out/persistence/dao/profession_dao.dart';
import 'package:battle_it_out/persistence/dao/race_dao.dart';
import 'package:battle_it_out/persistence/entities/melee_weapon.dart';
import 'package:battle_it_out/persistence/entities/ranged_weapon.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';
import 'package:battle_it_out/persistence/entities/talent.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/profession.dart';
import 'package:battle_it_out/persistence/entities/race.dart';
import 'package:battle_it_out/persistence/entities/armour.dart';
import 'package:battle_it_out/persistence/wfrp_database.dart';
import 'package:flutter/services.dart';

class Character {
  String name;
  Race race;
  Subrace subrace;
  Profession profession;
  Map<int, Attribute> attributes;
  Map<int, Skill> skills;
  Map<int, Talent> talents = {};
  List<Armour> armour = [];
  List<MeleeWeapon> meleeWeapons = [];
  List<RangedWeapon> rangedWeapons = [];
  int? initiative;
  // List<Trait> traits;

  Character(
      {required this.name,
      required this.race,
      required this.subrace,
      required this.profession,
      required this.attributes,
      this.skills = const {},
      this.talents = const {},
      this.meleeWeapons = const [],
      this.rangedWeapons = const [],
      this.armour = const []});

  static Character from(Character character) {
    var newInstance = Character(
        name: character.name,
        race: character.race,
        subrace: character.subrace,
        profession: character.profession,
        attributes: character.attributes);
    newInstance.skills = character.skills;
    newInstance.talents = character.talents;
    newInstance.initiative = character.initiative;
    return newInstance;
  }

  static Future<Character> create(String jsonPath, WFRPDatabase database) async {
    var json = await _loadJson(jsonPath);

    String name = json['name'];
    Race race = await RaceDAO().get(database, json["race_id"]);
    Subrace subrace = await SubraceDAO().get(database, json["subrace_id"]);
    Profession profession = await ProfessionDAO().get(database, json["profession_id"]);
    Map<int, Attribute> attributes = await _createAttributes(database, json["attributes"], race, profession);
    Map<int, Skill> skills = await _getSkills(database, json['skills'], attributes);
    Map<int, Talent> talents = await _getTalents(database, json['talents'], attributes);
    List<MeleeWeapon> meleeWeapons = await _getMeleeWeapons(database, json["melee_weapons"], attributes, skills);
    List<RangedWeapon> rangedWeapons = await _getRangedWeapons(database, json["ranged_weapons"], attributes, skills);
    List<Armour> armour = await _getArmour(database, json["armour"]);

    Character character = Character(
        name: name,
        race: race,
        subrace: subrace,
        profession: profession,
        attributes: attributes,
        skills: skills,
        talents: talents,
        meleeWeapons: meleeWeapons,
        rangedWeapons: rangedWeapons,
        armour: armour);

    return character;
  }

  static Future<Map<int, Attribute>> _createAttributes(
      WFRPDatabase database, json, Race race, Profession profession) async {
    Map<int, Attribute> attributes = await race.getAttributes(database);
    for (var attributeMap in json) {
      attributes[attributeMap["id"]]!.base = attributeMap["base"];
      attributes[attributeMap["id"]]!.advances = attributeMap["advances"] ?? 0;
    }
    return attributes;
  }

  static Future<List<RangedWeapon>> _getRangedWeapons(
      WFRPDatabase database, json, Map<int, Attribute> attributes, Map<int, Skill> skills) async {
    List<RangedWeapon> weaponList = [];
    for (var map in json ?? []) {
      RangedWeapon weapon = await database.getRangedWeapon(map["weapon_id"], skills, attributes);
      weapon.ammunition = map["ammunition"] ?? 0;
      for (var qualityMap in map["qualities"] ?? []) {
        weapon.addQuality(await database.getQuality(qualityMap["quality_id"]));
      }
      weaponList.add(weapon);
    }
    return weaponList;
  }

  static Future<List<MeleeWeapon>> _getMeleeWeapons(
      WFRPDatabase database, json, Map<int, Attribute> attributes, Map<int, Skill> skills) async {
    List<MeleeWeapon> weaponList = [];
    for (var map in json ?? []) {
      MeleeWeapon weapon = await database.getMeleeWeapon(map["weapon_id"], skills, attributes);
      map["name"] != null ? weapon.name = map["name"] : null;
      map["length"] != null ? weapon.length = map["length"] : null;
      for (var qualityMap in map["qualities"] ?? []) {
        weapon.addQuality(await database.getQuality(qualityMap["quality_id"]));
      }
      weaponList.add(weapon);
    }
    return weaponList;
  }

  static Future<List<Armour>> _getArmour(WFRPDatabase database, json) async {
    List<Armour> armourList = [];
    for (var map in json ?? []) {
      Armour armour = await database.getArmour(map["armour_id"]);
      map["head_AP"] != null ? armour.headAP = map["head_AP"] : null;
      map["body_AP"] != null ? armour.bodyAP = map["body_AP"] : null;
      map["left_arm_AP"] != null ? armour.leftArmAP = map["left_arm_AP"] : null;
      map["right_arm_AP"] != null ? armour.rightArmAP = map["right_arm_AP"] : null;
      map["left_leg_AP"] != null ? armour.leftLegAP = map["left_leg_AP"] : null;
      map["right_leg_AP"] != null ? armour.rightLegAP = map["right_leg_AP"] : null;
      armourList.add(armour);
    }
    return armourList;
  }

  static Future<Map<int, Skill>> _getSkills(WFRPDatabase database, json, Map<int, Attribute> attributes) async {
    Map<int, Skill> skillsMap = {};
    for (var map in json ?? []) {
      Skill skill = await database.getSkill(map["skill_id"], attributes);
      map["advances"] != null ? skill.advances = map["advances"] : null;
      map["advancable"] != null ? skill.advancable = map["advancable"] : null;
      map["earning"] != null ? skill.earning = map["earning"] : null;
      skillsMap[skill.id] = skill;
    }
    return skillsMap;
  }

  static Future<Map<int, Talent>> _getTalents(WFRPDatabase database, json, Map<int, Attribute> attributes) async {
    Map<int, Talent> talentsMap = {};
    for (var map in json ?? []) {
      Talent talent = await database.getTalent(map["talent_id"], attributes);
      map["lvl"] != null ? talent.currentLvl = map["lvl"] : null;
      map["advancable"] != null ? talent.advancable = map["advancable"] : null;
      talentsMap[talent.id] = talent;
    }
    return talentsMap;
  }

  static _loadJson(String jsonPath) async {
    String data = await rootBundle.loadString(jsonPath);
    return jsonDecode(data);
  }

  // List getters

  List<Attribute> getAttributes() {
    return List.of(attributes.values);
  }

  List<Skill> getSkills() {
    return List.of(skills.values);
  }

  List<Talent> getTalents() {
    return List.of(talents.values);
  }

  @override
  String toString() {
    return "Character (name=$name, race=$race), profession=$profession";
  }
}
