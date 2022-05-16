class Note {
  int? id;
  String? title;
  String? description;
  String? date;
  int? priority;

  Note(this.title, this.priority, this.date, [this.description]);

  Note.withId(this.id, this.title, this.priority, this.date,
      [this.description]);

  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    priority = json['priority'];
  }




}
