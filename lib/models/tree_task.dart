class TreeTask {
  int id;
  String title;
  String description;
  List<TreeTask> children;

  TreeTask.empty() {
    this.id = -1;
    this.children = List();
  }

  TreeTask({this.id, this.title, this.description, this.children});

  int get getId {
    return id;
  }

  String get getTitle {
    return title;
  }

  String get getDesc {
    return description;
  }

  List<TreeTask> get getChildren {
    return children;
  }
}
