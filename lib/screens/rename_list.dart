import 'package:flutter/material.dart';

import '../widgets/textstyles.dart';

class RenameList extends StatefulWidget {
  static const String renamelist = "renamelist";
  const RenameList({super.key});

  @override
  State<RenameList> createState() => _RenameListState();
}

class _RenameListState extends State<RenameList> {
  TextEditingController _renameList = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _renameList.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  String newCollectionname = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.clear,
          color: Colors.black,
          size: 20.0,
        ),
        title: const Text("Rename list"),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(right: 20.0, bottom: 15.0, top: 15),
              child: Text("Done",
                  style: TodoTextStyles().textStyles(
                      false,
                      newCollectionname.isEmpty ? true : false,
                      false,
                      14.0,
                      false)),
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: TextFormField(
          controller: _renameList,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              labelText: "Enter List Tiles"),
          textInputAction: TextInputAction.done,
          textAlign: TextAlign.start,
          minLines: 1,
          keyboardType: TextInputType.text,
          clipBehavior: Clip.antiAlias,
          onChanged: (value) {
            setState(() {
              newCollectionname = value;
            });
          },
        ),
      ),
    );
  }
}
