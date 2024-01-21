import 'package:battle_it_out/entities_localisation.dart';
import 'package:battle_it_out/interface/components/padded_text.dart';
import 'package:battle_it_out/interface/components/search_bar.dart';
import 'package:battle_it_out/localisation.dart';
import 'package:battle_it_out/persistence/ancestry.dart';
import 'package:battle_it_out/persistence/attribute.dart';
import 'package:battle_it_out/persistence/race.dart';
import 'package:battle_it_out/persistence/skill/skill.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class EditAncestryScreen extends StatefulWidget {
  final Ancestry? ancestry;
  final List<Skill> skills;
  const EditAncestryScreen({super.key, this.ancestry, required this.skills});

  @override
  State<EditAncestryScreen> createState() => _EditAncestryScreenState();
}

class _EditAncestryScreenState extends State<EditAncestryScreen> {
  AncestryPartial ancestryPartial = AncestryPartial();

  @override
  void initState() {
    super.initState();
    ancestryPartial = AncestryPartial.from(widget.ancestry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.of(context).pop<Tuple3<bool, Race?, List<Attribute>>>(const Tuple3(false, null, [])),
        ),
        centerTitle: true,
        title: Text("${widget.ancestry != null ? "Edit" : "New"} Ancestry"),
      ),
      body: ListView(shrinkWrap: true, padding: const EdgeInsets.all(10.0), children: [
        Center(child: LocalisedText("NAME", context, style: const TextStyle(fontSize: 24))),
        Container(
          alignment: Alignment.center,
          child: TextFormField(
            textAlign: TextAlign.center,
            initialValue:
                ancestryPartial.name != null ? AppLocalizations.of(context).localise(ancestryPartial.name!) : "",
            onChanged: (val) {},
            decoration: const InputDecoration(contentPadding: EdgeInsets.all(8)),
          ),
        ),
        SizedBox(
          height: 500,
          child: CheckboxListWithSearchBar<Skill>(
            title: LocalisedText("SKILLS", context, style: const TextStyle(fontSize: 24)),
            items: widget.skills,
            convert: (s) => s.name.localise(context),
          ),
        ),
      ]),
      floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        if (widget.ancestry == null || !ancestryPartial.compareTo(widget.ancestry))
          FloatingActionButton(
            heroTag: "btn2",
            child: const Icon(Icons.save),
            onPressed: () {},
          ),
        const SizedBox(height: 10),
        if (widget.ancestry != null)
          FloatingActionButton(
            heroTag: "btn1",
            child: const Icon(Icons.delete),
            onPressed: () {},
          ),
      ]),
    );
  }
}
