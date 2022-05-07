import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photomaster/data/tags_operations.dart';
import '/models/tags.dart';

class TagInterface extends StatefulWidget {
  List<Tag> selectedTags;
  List<Tag> defaultVal = [];
  TagInterface({selectedTags }) : this.selectedTags = selectedTags ?? [];

  @override
  _TagInterfaceState createState() => _TagInterfaceState();
}

class _TagInterfaceState extends State<TagInterface> {

  TagsOperations tagOp = TagsOperations();
  List<Tag> addTags = [];

  Future<List<Tag>> getData() async {
    var tags = await tagOp.getAllTags();
    return tags;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: MediaQuery.of(context).size.width*0.75,
          child: selectedTags()
        ),
        addTag()
      ],
    );
  }

  TextButton okButton() {
    return (TextButton(
      child: Text("OK"),
      onPressed: () {
        final tag = Tag(name: tagname);
        tagsOperations.createTag(tag);

        print("TAG CREATED");
        get_data();
        Navigator.pop(context);
      },
    ));
  }

  Widget selectedTags() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Builder(
        builder: (context) {
          if(widget.selectedTags.length == 0)
            return Text("No Tags");
          return ListView.builder(
            itemCount: widget.selectedTags.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                onLongPress: (){
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Are you sure you want to delete this tag?'),
                        actions: [
//                      ok_delete_Button(company.id)
                        ],
                      )
                  );
                },
                child: FilterChip(
                  backgroundColor: Colors.tealAccent[200],
                  avatar: CircleAvatar(
                    backgroundColor: Colors.cyan,
                    child: Text(
                      "test",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  label: Text(
                    "test1"
                  ),
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
            }
          );
        }
      ),
    );
  }

  Widget addTag(){
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Container(
                child: FutureBuilder(
                  future: getData(),
                  builder: (_, snapshot) {
                    Widget body;
                    if(snapshot.connectionState == ConnectionState.done) {
                      if(snapshot.data.length == 0) {
                        body = Container();
                      }
                      else {
                        body = Container(
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
                                t.id == snapshot.data[i].id) == -1 ? false : true,
                                selectedColor: Colors.purpleAccent,
                                onSelected: (bool selected) {
                                  setState(() {
                                    if (selected) {
                                      addTags.add(snapshot.data[i]);
                                    } else {
                                      print("not selected");
                                      addTags.removeWhere((Tag t) {
                                        return t.id == snapshot.data[i].id;
                                      });
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        );
                      }
                    }
                    else {
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
                                            decoration: const InputDecoration(labelText: "Enter a new tag"),
                                            onChanged: (val){
                                              tagname = val ?? null;
                                              print(tagname);
                                            },
                                          )
                                        ],
                                      )
                                  ),
                                  actions: [
                                    okButton()
                                  ],
                                )
                            );
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
            )
        );
      }
      );
  }
}
