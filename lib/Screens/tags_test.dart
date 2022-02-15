import 'package:flutter/material.dart';
import 'package:photomaster/Screens/Tags.dart';
import 'package:photomaster/data/tags_operations.dart';
import 'package:photomaster/Screens/Images_Details.dart';
import 'package:photomaster/models/tags.dart';
import 'package:photomaster/models/image.dart';

class ChipDemo extends StatefulWidget {
  TagsOperations _tagsOperations = TagsOperations();
  @override
  State<StatefulWidget> createState() => _ChipDemoState();
}

class _ChipDemoState extends State<ChipDemo> {
  Future<List<Tag>> _tagsOperations = TagsOperations().getAllTags();
  GlobalKey<ScaffoldState> _key;
  bool _isSelected;
  List<Tag> _allTags;
  List<String> _filters;
  List<dynamic> _idtags;
  List<dynamic> _idimages;
  List<String> _choices;
  int _choiceIndex;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey<ScaffoldState>();
    _isSelected = false;
    _choiceIndex = 0;
    _filters = <String>[];
    get_data();
  }

  void get_data() async {
    var _tagsOperations = await TagsOperations().getAllTags();
    setState(() {
      _allTags = _tagsOperations;
    });

    print(_allTags);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: selectedTags.toList(),
    );
  }

  Iterable<Widget> get selectedTags sync* {
    // important
    if (_allTags != null) {
      //print(_allTags);
      for (Tag company in _allTags) {
        print(company);
        yield Padding(
          padding: const EdgeInsets.all(6.0),
          child: FilterChip(
            backgroundColor: Colors.tealAccent[200],
            avatar: CircleAvatar(
              backgroundColor: Colors.cyan,
              child: Text(
                company.name[0].toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            label: Text(
              company.name,
            ),
            selected: _filters.contains(company.name),
            selectedColor: Colors.purpleAccent,
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  _filters.add(company.name);
                  _idtags.add(company.id);
                  // _idimages.add(image.id);
                } else {
                  _filters.removeWhere((String name) {
                    return name == company.name;
                  });
                }
              });
            },
          ),
        );
      }
    } else {
      print("no");
      Text("nope");
    }
  }
}
