


class NoteList extends StatefulWidget {
  const NoteList({Key? key}) : super(key: key);

  @override
  State<NoteList> createState() => _NoteListState();
}


class _NoteListState extends State<NoteList> {

  DbHelper helper = DbHelper.instance;
  List<Note> notes = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }
  
  void getData() {
    final notesFuture = helper.getNotes();
    notesFuture.then((result) {
      setState(() {
        notes = result as List<Note>;
        count = notes.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text(
            'notes',
            style: TextStyle(
                fontFamily: "Anton-Regular",
                letterSpacing: 1,
                fontSize: 35,
                color: Color.fromRGBO(200, 200, 200, 0.9)),
          )),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/list_bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: ((context, index) => Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                      child: Card(
                        color: const Color.fromRGBO(200, 220, 250, 0.9),
                        elevation: 2.0,
                        child: ListTile(
                          tileColor: Colors.transparent,
                          leading: Container(
                            width: 5,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: getColor(notes[index].priority ?? 1),
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                            child: Text(notes[index].title ?? '',
                                style: const TextStyle(
                                    fontSize: 17, letterSpacing: 1.5),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: Text(
                              notes[index].description ?? '',
                              style: const TextStyle(fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          onTap: () {
                            navigateToDetails(notes[index]);
                          },
                        ),
                      ),
                    ))),
          )),


      floatingActionButton: FloatingActionButton(
          splashColor: Colors.blue.shade900,
          backgroundColor: Colors.black45.withOpacity(0.8),
          child: const Icon(
            Icons.add,
            color: Color.fromRGBO(230, 230, 240, 1),
            size: 35,
          ),
          onPressed: () {
            navigateToDetails(Note("", 3, ""));
          }),

    );
  }

  void navigateToDetails(Note note) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: ((context) => NoteAction(note: note))));
    if (result) {
      getData();
    }
  }

  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.black45;
      case 2:
        return Colors.blueGrey.shade400;
      case 3:
        return Colors.black12;
      default:
        return Colors.blueGrey.shade400;
    }
  }

}
