import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photomaster/data/tags_operations.dart';
import '/models/tags.dart';

typedef void VoidCallback(Tag newTag);

class TagInterface extends StatefulWidget {
  final List<Tag> existingTags;
  final VoidCallback addTagCallback;
  final VoidCallback remTagCallback;

//  List<Tag> selectedTags;
//  List<Tag> defaultVal = [];

  TagInterface(
      {@required this.addTagCallback,
      @required this.remTagCallback,
      existingTags})
      : this.existingTags = existingTags ?? [];

  @override
  _TagInterfaceState createState() => _TagInterfaceState();
}

class _TagInterfaceState extends State<TagInterface> {
  TagsOperations tagOp = TagsOperations();
  List<Tag> addTags = [];
  Future<List<Tag>> allTags;

  Future<List<Tag>> getData() async {
    var tags = await tagOp.getAllTags();
    return tags;
  }

  @override
  void initState() {
    super.initState();
    addTags = widget.existingTags;
//    print("init ${widget.existingTags}");
//    print("init ${addTags}");
    allTags = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              width: MediaQuery.of(context).size.width - 50,
              child: selectedTags()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: StadiumBorder(side: BorderSide(color: Colors.black)),
        backgroundColor: const Color(0xfffff4cc),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: newTagPanel,
      ),
    );
  }

  TextButton okButton(String tagName) {
    print("new tag name: $tagName");
    return (TextButton(
      child: Text("OK"),
      onPressed: () {
        final tag = Tag(name: tagName);
        tagOp.createTag(tag);

        print("TAG CREATED");
        getData();
        Navigator.pop(context);
      },
    ));
  }

  Widget selectedTags() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Builder(builder: (context) {
        if (addTags.length == 0) return Text("No Tags");
        return Container(
          width: MediaQuery.of(context).size.width - 50,
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  childAspectRatio: 2.0),
              padding: EdgeInsets.zero,
              itemCount: addTags.length,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text(
                                  'Are you sure you want to delete this tag?'),
                              actions: [
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    setState(() {
                                      widget.remTagCallback(addTags[i]);
                                      addTags.removeAt(i);
                                    });
                                    print("TAG REMOVED");
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ));
                  },
                  child: FilterChip(
                    backgroundColor: Colors.blue,
                    avatar: CircleAvatar(
                      backgroundColor: Colors.cyan,
                      child: Icon(Icons.check),
                    ),
                    label: Text(addTags[i].name),
//              selected: _filters.contains(company.name),
//              selectedColor: Colors.purpleAccent,
//              onSelected: (bool selected) {
//                setState(() {
//                  if (selected) {
//                    _filters.add(company.name);
//                    _idtags.add(company.id);
//                    _idimages.add(widget.id);
//                    print("selected");
//                  } else {
//                    print("not selected");
//                    _filters.removeWhere((String name) {
//                      return name == company.name;
//                    });
//                  }
//                });
//              },
                  ),
                );
              }),
        );
      }),
    );
  }

  void newTagPanel() {
    TextEditingController input_tag = TextEditingController();
    String tagName;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Container(
                width: MediaQuery.of(context).size.width - 100,
                child: FutureBuilder<List<Tag>>(
                  future: allTags,
                  builder: (_, snapshot) {
                    Widget body;
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data.length == 0) {
                        body = Container();
                      } else {
                        body = Container(
                          height: MediaQuery.of(context).size.height / 3,
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
//                        itemCount: 3,
                            itemBuilder: (_, i) {
                              return FilterChip(
                                backgroundColor: Colors.blue,
                                label: Text(
                                  snapshot.data[i].name,
                                ),
                                selected: addTags.indexWhere((Tag t) =>
                                            t.id == snapshot.data[i].id) ==
                                        -1
                                    ? false
                                    : true,
                                selectedColor: Colors.purpleAccent,
                                onSelected: (bool selected) {
                                  setState(() {
                                    if (selected) {
                                      addTags.add(snapshot.data[i]);
                                      widget.addTagCallback(snapshot.data[i]);
                                    } else {
                                      print("already selected");
//                                  addTags.removeWhere((Tag t) {
//                                    return t.id == snapshot.data[i].id;
//                                  });
                                    }
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        );
                      }
                    } else {
                      body = CircularProgressIndicator();
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        body,
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
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Enter a new tag"),
                                                onChanged: (val) {
                                                  tagName = val ?? null;
                                                  print(tagName);
                                                },
                                              )
                                            ],
                                          )),
                                      actions: [
                                        TextButton(
                                          child: Text("OK"),
                                          onPressed: () async {
                                            Tag tag = Tag(name: tagName);
                                            await tagOp.createTag(tag);
                                            print("TAG CREATED");
                                            setState(() {
                                              allTags = getData();
                                            });
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            newTagPanel();
                                          },
                                        )
                                      ],
                                    ));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.add),
                              Text("New Tag"),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ));
  }
}
