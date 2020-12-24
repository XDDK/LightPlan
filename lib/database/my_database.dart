import 'package:moor_flutter/moor_flutter.dart';

part 'my_database.g.dart';

@DataClassName("Task")
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get parentId =>
      integer().nullable().customConstraint('NULL REFERENCES tasks(id)')();
  TextColumn get title => text().withLength(min: 1, max: 32)();
  TextColumn get shortDesc => text().withLength(min: 1, max: 64)();
  TextColumn get desc => text().withLength(min: 1, max: 140).nullable()();

  // @override
  // Set<Column> get primaryKey => {id};
}

@UseDao(tables: [Tasks])
class TaskDao extends DatabaseAccessor<MyDataBase> with _$TaskDaoMixin {
  final MyDataBase db;

  TaskDao(this.db) : super(db);

  Future<List<Task>> getAllTasks() => select(tasks).get();
  Stream<List<Task>> watchAllTasks() => select(tasks).watch();
  Future insertTask(Task task) => into(tasks).insert(task);
  Future updateTask(Task task) => update(tasks).replace(task);
  Future deleteTask(Task task) => delete(tasks).delete(task);
}

@UseMoor(tables: [Tasks], daos: [TaskDao])
class MyDataBase extends _$MyDataBase {
  MyDataBase()
      // Specify the location of the database file
      : super((FlutterQueryExecutor.inDatabaseFolder(
          path: 'lightplannerdb.sqlite',
          // Good for debugging - prints SQL in the console
          logStatements: true,
        )));

  // Bump this when changing tables and columns.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        // Runs if the database has already been opened on the device with a lower version
        onUpgrade: (migrator, from, to) async {
          if (from == 1) {
            // await migrator.addColumn(tasks, tasks.tagName);
            // await migrator.createTable(tags);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
