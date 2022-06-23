import 'package:battle_it_out/persistence/dao/item_dao.dart';
import 'package:battle_it_out/persistence/dao/skill_dao.dart';
import 'package:battle_it_out/persistence/entities/attribute.dart';
import 'package:battle_it_out/persistence/entities/ranged_weapon.dart';
import 'package:battle_it_out/persistence/entities/skill.dart';

class RangedWeaponFactory extends ItemFactory<RangedWeapon> {
  Map<int, Skill> skills;
  Map<int, Attribute> attributes;

  RangedWeaponFactory([this.attributes = const {}, this.skills = const {}]);

  @override
  get tableName => 'weapons_ranged';
  @override
  get qualitiesTableName => 'weapons_melee_qualities';

  @override
  Future<RangedWeapon> fromMap(Map<String, dynamic> map, [Map overrideMap = const {}]) async {
    return RangedWeapon(
        id: map["ID"],
        name: map["NAME"],
        range: map["WEAPON_RANGE"],
        rangeAttribute: attributes[map["RANGE_ATTRIBUTE"]],
        damage: map["DAMAGE"],
        damageAttribute: attributes[map["DAMAGE_ATTRIBUTE"]],
        skill: skills[map['SKILL']] ?? await SkillFactory(attributes).get(map['SKILL']),
        qualities: await getQualities(map["ID"]));
  }

  @override
  Map<String, dynamic> toMap(RangedWeapon object) {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
