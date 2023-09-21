import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteapp/model/note.dart';
import 'package:noteapp/viewmodel/db_helper.dart';

DbHelper helper = DbHelper.instance;

class NoteAction extends StatefulWidget {
  final Note note;
  const NoteAction({Key? key, required this.note}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<NoteAction> createState() => _NoteActionState(note);
}

class _NoteActionState extends State<NoteAction> {
  Note note;

  _NoteActionState(this.note);

  final _priorities = ["High", "Medium", "Low"];

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = note.title ?? '';
    descController.text = note.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var title = note.title == '' ? "New Note" : note.title;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          title ?? '',
          style: const TextStyle(
              fontFamily: "Anton-Regular",
              letterSpacing: 1,
              fontSize: 35,
              color: Color.fromRGBO(200, 200, 200, 0.9)),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/list_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
                child: TextField(
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(
                      fontSize: 20, color: Color.fromRGBO(10, 10, 10, 0.8)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.4),
                    hintText: 'Title',
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white24),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),




              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Priority",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(180, 200, 250, 1),
                        )),
                  ),
                  DropdownButton(
                      dropdownColor: Colors.black38,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      value: _priorities[(note.priority ?? 2) - 1],
                      items: _priorities.map((String str) {
                        return DropdownMenuItem<String>(
                          alignment: AlignmentDirectional.center,
                          value: str,
                          child: Text(str,
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                                color: Color.fromRGBO(180, 200, 250, 1),
                              )),
                        );
                      }).toList(),
                      onChanged: (str) {
                        updatePriority(str.toString());
                      }),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                child: ButtonTheme(
                  minWidth: 145,
                  height: 45,
                  child: MaterialButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
                          side: BorderSide(
                            color: Color.fromRGBO(30, 135, 240, 0.95),
                          )),
                      color: const Color.fromRGBO(0, 105, 210, 0.8),
                      child: const Text("Save",
                          style: TextStyle(
                            color: Color.fromRGBO(250, 250, 250, 1),
                            fontSize: 15,
                          )),
                      onPressed: () async {
                        save();
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: ButtonTheme(
                  minWidth: 145,
                  height: 45,
                  child: MaterialButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
                          side: BorderSide(
                            color: Color.fromRGBO(250, 65, 60, 0.8),
                          )),
                      color: const Color.fromRGBO(250, 25, 10, 0.8),
                      child: const Text("Delete",
                          style: TextStyle(
                            color: Color.fromRGBO(250, 250, 250, 1),
                            fontSize: 15,
                          )),
                      onPressed: () async {
                        delete();
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updatePriority(String value) {
    int priority = 0;

    switch (value) {
      case "High":
        priority = 1;
        break;
      case "Medium":
        priority = 2;
        break;
      case "Low":
        priority = 3;
        break;
      default:
        priority = 3;
    }

    setState(() {
      note.priority = priority;
    });
  }

  void save() {
    note.title = titleController.text;
    note.description = descController.text;
    note.date = DateFormat.yMd().format(DateTime.now());
    if (note.id != null) {
      helper.updateNote(note);
    } else {
      helper.insertNote(note);
    }
    Navigator.pop(context, true);

    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(milliseconds: 2000), () {
            Navigator.of(context).pop(true);
          });
          return saveDialog();
        });
  }

  Future<void> delete() async {
    Navigator.pop(context, true);
    if (note.id == null) {
      return;
    }
    int result = await helper.deleteNote(note.id!);
    if (result != 0) {
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(const Duration(milliseconds: 2000), () {
              Navigator.of(context).pop(true);
            });
            return deleteDialog();
          });
    }
  }

  Widget saveDialog() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: const AlertDialog(
        backgroundColor: Color.fromRGBO(200, 220, 250, 0.9),
        elevation: 2.0,
        title: Center(
          child: Text("The Note has been saved",
              style: TextStyle(
                color: Color.fromRGBO(40, 40, 40, 1),
                fontSize: 20,
              )),
        ),
      ),
    );
  }

  Widget deleteDialog() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: const AlertDialog(
        backgroundColor: Color.fromRGBO(200, 220, 250, 0.9),
        elevation: 2.0,
        title: Center(
          child: Text("The Note has been deleted",
              style: TextStyle(
                color: Color.fromRGBO(40, 40, 40, 1),
                fontSize: 20,
              )),
        ),
      ),
    );
  }
}
