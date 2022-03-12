import 'dart:convert';
import 'dart:io';
import 'package:battle_it_out/persistence/character.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  File file = File('assets/test/character_test.json');
  Character character = await Character.create(jsonDecode(await file.readAsString()));

  group('Links between attributes, skills and weapons', ()
  {
    test('Start conditions', () async {
      // Attribute
      expect(character.attributes[1]!.base, 34);
      expect(character.attributes[1]!.advances, 5);
      expect(character.attributes[1]!.getTotalValue(), 39);
      expect(character.attributes[1]!.getTotalBonus(), 3);

      // Skill
      expect(character.skills[38]!.advances, 5);
      expect(character.skills[38]!.getTotalValue(), 44);

      // Talent
      expect(character.talents[26]!.currentLvl, 1);
      expect(character.talents[26]!.getMaxLvl(), 3);
    });
    test('Increasing base value', () async {
      character.attributes[1]!.base++;
      expect(character.attributes[1]!.getTotalValue(), 40);
      expect(character.attributes[1]!.getTotalBonus(), 4);

      // Skill
      expect(character.skills[38]!.getTotalValue(), 45);

      // Talent
      expect(character.talents[26]!.getMaxLvl(), 4);
    });
  });
}