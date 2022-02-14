import 'package:flutter/material.dart';
import 'package:photomaster/Widgets/tag_list.dart';
import 'package:photomaster/data/tags_operations.dart';
import 'package:photomaster/models/tags.dart';

class Tags extends StatefulWidget {

  @override

  _TagsState createState() => _TagsState();

}



class _TagsState extends State<Tags> {

  TagsOperations tagsOperations = TagsOperations();

  List<Tag> tags;

  final _formKey = GlobalKey<FormState>();

  String tagname = "";
  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text("Tags"),

      ),

      body:  Expanded(

        child: SingleChildScrollView(

          child: Center(

            child: FutureBuilder(

                future: tagsOperations.getAllTags(),

                builder: (context, snapshot) {

                  if (snapshot.hasError) {

                    print("error");

                  }

                  var data = snapshot.data;

                  return snapshot.hasData

                      ? TagList(data)

                      : Center(child: Text("No Tags"));

                }),

          ),

        ),

      ),

    );

  }

}