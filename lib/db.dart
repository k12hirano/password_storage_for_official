import 'package:password_storage_for_official/item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {

  final databaseName = 'PassStorage.db';
  final databaseVersion = 1;
  final String itemtable = 'item';
  final String _id = 'id';
  final String _title = 'title';
  final String _email = 'email';
  final String _pass = 'pass';
  final String _url = 'url';
  final String _memo = 'memo';
  final String _favorite = 'favorite';
  final String _date = 'date';
  final String _memostyle = 'memostyle';

  Database database1;

  Future<Database> get database async{
    if (database1 != null) return database1;
    database1 = await initdb();
    return database1;
  }
  Future<Database> initdb() async {
    String path = join(await getDatabasesPath(), 'item.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: createTable,
    );
  }
  Future<void> createTable(Database db, int version) async {
    await db.execute('CREATE TABLE item(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, email TEXT, pass TEXT, url TEXT, memo TEXT,favorite INTEGER, memostyle INTEGER, date TEXT)');
  }

  /*Future<List<Item>> getItems() async {
    final db = await database;
    if (database1 == null){
    database1 = await initdb();}
    var maps = await db.query(
      itemtable,
      orderBy: '$_id DESC',
    );

    if (maps.isEmpty) return [];
    return maps.map((map) => fromMap(map)).toList();
  }*/

  Future<List<Item>> select(int id) async{
    final db = await database;
    var maps = await db.query(itemtable,
        where: '$_id = ?',
        whereArgs: [id]);
    if(maps.isEmpty) return [];
    return maps.map((map)=> fromMap(map)).toList();
  }

  Future<List<Item>> search(String keyword) async {
    final db = await database;

    var maps = (keyword != null)?await db.query(
      itemtable,
      orderBy: '$_id DESC',
      where: '$_title LIKE ?'
          +'OR $_email LIKE ?'
          +'OR $_pass LIKE ?'
          +'OR $_url LIKE ?'
          +'OR $_memo LIKE ?',
      whereArgs: ['%$keyword%','%$keyword%','%$keyword%','%$keyword%','%$keyword%'],
    )
        :await db.query(
      itemtable,
      orderBy: '$_date DESC',
    );

    if (maps.isEmpty) {
      return [];
    }else {
      return maps.map((map) => fromMap(map)).toList();
    }
  }

  Future<List<Item>> searchBytitle(String keyword) async {
    final db = await database;

    var maps = (keyword != null)?await db.query(
      itemtable,
      orderBy: '$_id DESC',
      where: '$_title LIKE ?'
          +'OR $_email LIKE ?'
          +'OR $_pass LIKE ?'
          +'OR $_url LIKE ?'
          +'OR $_memo LIKE ?',
      whereArgs: ['%$keyword%','%$keyword%','%$keyword%','%$keyword%','%$keyword%'],
    )
        :await db.query(
      itemtable,
      orderBy: '$_title ASC',
    );

    if (maps.isEmpty) {
      return [];
    }else {
      return maps.map((map) => fromMap(map)).toList();
    }
  }

  Future<List<Item>> searchByid(String keyword) async {
    final db = await database;

    var maps = (keyword != null) ?await db.query(
      itemtable,
      orderBy: '$_id DESC',
      where: '$_title LIKE ?'
          +'OR $_email LIKE ?'
          +'OR $_pass LIKE ?'
          +'OR $_url LIKE ?'
          +'OR $_memo LIKE ?',
      whereArgs: ['%$keyword%','%$keyword%','%$keyword%','%$keyword%','%$keyword%'],
    )
        :await db.query(
      itemtable,
      orderBy: '$_email ASC',
    );

    if (maps.isEmpty) {
      return [];
    }else {
      return maps.map((map) => fromMap(map)).toList();
    }
  }

  Future<List<Item>> searchBypass(String keyword) async {
    final db = await database;

    var maps = (keyword != null) ?await db.query(
      itemtable,
      orderBy: '$_id DESC',
      where: '$_title LIKE ?'
          +'OR $_email LIKE ?'
          +'OR $_pass LIKE ?'
          +'OR $_url LIKE ?'
          +'OR $_memo LIKE ?',
      whereArgs: ['%$keyword%','%$keyword%','%$keyword%','%$keyword%','%$keyword%'],
    )
        :await db.query(
      itemtable,
      orderBy: '$_pass ASC',
    );

    if (maps.isEmpty) {
      return [];
    }else {
      return maps.map((map) => fromMap(map)).toList();
    }
  }

  Future<List<Item>> searchFAV(String keyword) async {
    final db = await database;

    var maps = (keyword != null) ?await db.query(
      itemtable,
      orderBy: '$_id DESC',
      where: '$_title LIKE ?'
          +'OR $_email LIKE ?'
          +'OR $_pass LIKE ?'
          +'OR $_url LIKE ?'
          +'OR $_memo LIKE ?'
          +'AND $_favorite = 1',
      whereArgs: ['%$keyword%','%$keyword%','%$keyword%','%$keyword%','%$keyword%'],
    )
        :await db.query(
        itemtable,
        orderBy: '$_date DESC',
        where: '$_favorite=1'
    );

    if (maps.isEmpty) {
      return [];
    }else {
      return maps.map((map) => fromMap(map)).toList();
    }
  }

  Future<List<Item>> searchBytitleFAV(String keyword) async {
    final db = await database;

    var maps = (keyword != null) ?await db.query(
      itemtable,
      orderBy: '$_id DESC',
      where: '$_title LIKE ?'
          +'OR $_email LIKE ?'
          +'OR $_pass LIKE ?'
          +'OR $_url LIKE ?'
          +'OR $_memo LIKE ?'
          +'AND $_favorite = 1',
      whereArgs: ['%$keyword%','%$keyword%','%$keyword%','%$keyword%','%$keyword%'],
    )
        :await db.query(
        itemtable,
        orderBy: '$_title ASC',
        where: '$_favorite=1'
    );

    if (maps.isEmpty) {
      return [];
    }else {
      return maps.map((map) => fromMap(map)).toList();
    }
  }

  Future<List<Item>> searchByidFAV(String keyword) async {
    final db = await database;

    var maps = (keyword != null) ?await db.query(
      itemtable,
      orderBy: '$_id DESC',
      where: '$_title LIKE ?'
          +'OR $_email LIKE ?'
          +'OR $_pass LIKE ?'
          +'OR $_url LIKE ?'
          +'OR $_memo LIKE ?'
          +'AND $_favorite = 1',
      whereArgs: ['%$keyword%','%$keyword%','%$keyword%','%$keyword%','%$keyword%'],
    )
        :await db.query(
        itemtable,
        orderBy: '$_email ASC',
        where: '$_favorite=1'
    );

    if (maps.isEmpty) {
      return [];
    }else {
      return maps.map((map) => fromMap(map)).toList();
    }
  }

  Future<List<Item>> searchBypassFAV(String keyword) async {
    final db = await database;

    var maps = (keyword != null)?await db.query(
      itemtable,
      orderBy: '$_id DESC',
      where: '$_title LIKE ?'
          +'OR $_email LIKE ?'
          +'OR $_pass LIKE ?'
          +'OR $_url LIKE ?'
          +'OR $_memo LIKE ?'
          +'AND $_favorite = 1',
      whereArgs: ['%$keyword%','%$keyword%','%$keyword%','%$keyword%','%$keyword%'],
    )
        :await db.query(
        itemtable,
        orderBy: '$_pass ASC',
        where: '$_favorite=1'
    );

    if (maps.isEmpty) {
      return [];
    }else {
      return maps.map((map) => fromMap(map)).toList();
    }
  }

  Future insert(Item item) async {
    final db = await database;
    await db.insert(itemtable, item.toMap());
  }

  Future update(Item item, int id) async {
    final db = await database;
    return await db.update(
      itemtable,
      toMap(item),
      where: '$_id = ?',
      whereArgs: [id],
    );
  }

  Future delete(int id) async {
    final db = await database;
    return await db.delete(
      itemtable,
      where: '$_id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> toMap(Item item) {
    return {
      _id: item.id,
      _title: item.title,
      _email: item.email,
      _pass: item.pass,
      _url: item.url,
      _memo: item.memo,
      _favorite: item.favorite,
      _memostyle: item.memostyle,
      _date: item.date
    };
  }

  Item fromMap(Map<String, dynamic> json) {
    return Item(
        id: json[_id],
        title: json[_title],
        email: json[_email],
        pass: json[_pass],
        url: json[_url],
        memo: json[_memo],
        favorite: json[_favorite],
        memostyle: json[_memostyle],
        date: json[_date]
    );
  }

}
