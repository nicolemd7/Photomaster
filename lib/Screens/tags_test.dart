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
  final id;

  ChipDemo({this.id});
}

class _ChipDemoState extends State<ChipDemo> {
  Future<List<Tag>> _tagsOperations = TagsOperations().getAllTags();
  GlobalKey<ScaffoldState> _key;
  bool _isSelected;
  List<Tag> _allTags;
  List<String> _filters;
  List<dynamic> _idtags = [];
  List<dynamic> _idimages = [];
  List<String> _choices;
  int _choiceIndex;
  String tagname = "";
  final _formKey = GlobalKey<FormState>();
  TagsOperations tagsOperations = TagsOperations();

  TextEditingController input_tag = TextEditingController();

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
  }

  TextButton okButton() {
    return (TextButton(
      child: Text("OK"),
      onPressed: () {
        if (tagname != null || tagname != ''){
          final tag = Tag(name: tagname);
          print(tagname);
          print(tag);
          tagsOperations.createTag(tag);

          print("TAG CREATED");
          get_data();
          Navigator.pop(context);
        }
      },
    ));
  }

  TextButton ok_delete_Button(id) {
    return (TextButton(
      child: Text("OK"),
      onPressed: () {
        print("$id DELETED");
        final tag = Tag(id: id);
        tagsOperations.deleteTag(tag);
        get_data();
        Navigator.pop(context);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text('Add a new tag'),
                          content: Container(
                              height: 70,
                              child: Column(
                                children: [
                                  TextField(
                                    controller: input_tag,
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                        labelText: "Enter a new tag"),
                                    onChanged: (val) {
                                      tagname = val ?? null;
                                      print(tagname);
                                    },
                                  )
                                ],
                              )),
                          actions: [okButton()],
                        ));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(Colors.black),
                shape: MaterialStateProperty.all(CircleBorder()),
              ),
              child: Icon(Icons.add)),
          Wrap(
            children: selectedTags.toList(),
          ),
        ],
      ),
    );
  }

  Iterable<Widget> get selectedTags sync* {
    // important
    if (_allTags != null) {
      print(_allTags);
      for (Tag company in _allTags) {
        print(company);
        yield Padding(
            padding: const EdgeInsets.all(6.0),
            child: GestureDetector(
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title:
                              Text('Are you sure you want to delete this tag?'),
                          actions: [ok_delete_Button(company.id)],
                        ));
              },
              child: FilterChip(
                backgroundColor: const Color(0xfffff4cc),
                shape: StadiumBorder(side: BorderSide()),
                avatar: CircleAvatar(
                  backgroundColor: Colors.black,
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
                      _idimages.add(widget.id);
                      print("selected");
                    } else {
                      print("not selected");
                      _filters.removeWhere((String name) {
                        return name == company.name;
                      });
                    }
                  });
                },
              ),
            ));
      }
    } else {
      print("no tags created!");
      Text("no tags created!");
    }
  }
}
