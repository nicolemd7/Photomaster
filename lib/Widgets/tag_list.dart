import 'package:flutter/material.dart';
import 'package:photomaster/data/tags_operations.dart';
import 'package:photomaster/models/tags.dart';

class TagList extends StatelessWidget {
  List<Tag> tags;
  TagsOperations tagsOperations = TagsOperations();

  TagList(List<Tag> this.tags, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: tags.length,
          itemBuilder: (context, index) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: Text('${tags[index].name}'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
