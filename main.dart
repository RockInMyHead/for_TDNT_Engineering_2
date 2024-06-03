import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mysql1/mysql1.dart';

var register_flag = false;
var name = '';
var id;
var my_route = '/register';
var route = '/register';
void show_registr() {
  if (register_flag == true) {
    var route = '/';
  }
}

void main() {
  show_registr();
  runApp(const MyApp());
}

var all_items = [];
var all_items_about = [];
var all_who_add = [];
var user_things = [];
var item_name;
var about_item;
var id_who_add;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: route,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (BuildContext context) => MyHomePage(),
          '/item': (BuildContext context) => Item(),
          '/user': (BuildContext context) => User(),
          '/register': (BuildContext context) => Register(),
          '/login': (BuildContext context) => Login(),
        },
        onGenerateRoute: (routeSettings) {
          var path = routeSettings.name?.split('/');
          print(path);
          if (path![1] == "item") {
            return new MaterialPageRoute(
              builder: (context) => new Item(
                item_name: path[3],
                about_item: path[4],
                id_who_add: path[5],
              ),
              settings: routeSettings,
            );
          }
        });
  }
}

Future data_base(String thing, String about, int who_add) async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      db: 'app',
      password: '135797531AaA'));
  await Future.delayed(Duration(seconds: 1));
  var result = await conn.query(
      'INSERT INTO items (thing, about, who_add) values ( ?, ?, ?)',
      [thing, about, who_add]);
  await conn.close();
}

Future what_add_for_data_base(String id) async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      db: 'app',
      password: '135797531'));
  await Future.delayed(Duration(seconds: 1));
  var result = await conn
      .query('SELECT thing, about FROM items WHERE who_add = ?', [id]);
  user_things = [];
  for (var row in result) {
    user_things.add(row[0]);
  }
  await conn.close();
}

Future show_data_base() async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      db: 'app',
      password: '135797531AaA'));
  await Future.delayed(Duration(seconds: 1));

  var results = await conn.query('SELECT thing, about, who_add FROM items');
  //DataNameUserName = results.fields;
  var DataNameUserName;
  all_items = [];
  all_items_about = [];
  all_who_add = [];
  print(results);
  for (var row in results) {
    DataNameUserName = row[0];
    print(row.length);
    all_items.add(row[0]);
    all_items_about.add(row[1]);
    all_who_add.add(row[2]);
  }
  await conn.close();
  print(all_items);
}

Future show_data_base_2() async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      db: 'app',
      password: '135797531AaA'));
  await Future.delayed(Duration(seconds: 2));
  var result_2 = await conn.query('SELECT thing, about, who_add FROM items');
  all_items = [];
  all_items_about = [];
  all_who_add = [];
  for (var row in result_2) {
    all_items.add(row[0]);
    all_items_about.add(row[1]);
    all_who_add.add(row[2]);
  }
  print("Новая функция");
  print(all_items);
  await conn.close();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var thing;
  var about;

  void add_text(String Text) {
    thing = Text;
  }

  void add_about_item(String Text) {
    about = Text;
  }

  void _incrementCounter() {
    setState(() {
      print("Add to base data");
      data_base(thing, about, id);
      show_data_base_2();
    });
  }

  show_what_add_user() {
    String string_id = "$id";
    what_add_for_data_base(string_id);
  }

  add_new() {
    print("Add to base data");
    data_base(thing, about, id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 218, 188, 23),
        title: Text('Freesty'),
        leading: Icon(Icons.eco),
        leadingWidth: 50, // default is 56
        actions: [
          TextButton(
              onPressed: () {
                show_what_add_user();
                Navigator.pushNamed(context, '/user');
              },
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.supervised_user_circle,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ],
              )),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: all_items.length,
        itemBuilder: (context, index) {
          return TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.pushNamed(
                  context,
                  '/item/' +
                      index.toString() +
                      '/' +
                      all_items[index] +
                      '/' +
                      all_items_about[index] +
                      '/' +
                      all_who_add[index]);
            },
            child: Center(
              child: Text('${index + 1} - ${all_items[index]}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('data'),
                  content: Column(children: [
                    TextField(
                      obscureText: false,
                      onChanged: add_text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'data',
                      ),
                    ),
                    TextField(
                      obscureText: false,
                      onChanged: add_about_item,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'about',
                      ),
                    )
                  ]),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Canel")),
                    TextButton(
                        onPressed: () {
                          _incrementCounter();
                          //add_new();
                          Navigator.pop(context);
                        },
                        child: const Text("Ok")),
                  ],
                )),
        backgroundColor: Color.fromARGB(255, 218, 188, 23),
        child: const Icon(
          Icons.add,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Item extends StatelessWidget {
  String _item_name;
  String _about_item;
  String _who_add;

  Item({
    String item_name = '',
    String about_item = '',
    String id_who_add = '',
  })  : _item_name = item_name,
        _about_item = about_item,
        _who_add = id_who_add;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 218, 188, 23),
          leadingWidth: 50, // default is 56
          title: Text('$_item_name'),
        ),
        body: Center(
          child: Column(children: <Widget>[
            Text(
              "$_item_name",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                height: 2,
                fontSize: 40,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2
                  ..color = Color.fromARGB(255, 218, 188, 23),
              ),
            ),
            Text(
              "$_about_item",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              "Добавил : $_who_add",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            TextButton(
              //onPressed: () => Navigator.pop(context, 'OK'),
              onPressed: () {
                //add_data_base();
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Отозваться'),
            ),
          ]),
        ));
  }
}

class User extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name | | |  $user_things'),
      ),
    );
  }
}

class Register extends StatelessWidget {
  String user_name = "";
  String user_password = "";

  @override
  _add_name(String text) {
    user_name = text;
    print(user_name);
  }

  @override
  _add_password(String text) {
    user_password = text;
    print(user_password);
  }

  @override
  add_data_base() {
    show_data_base(user_name, user_password);
  }

  @override
  Future show_data_base(String name, String password) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        db: 'app',
        password: '135797531AaA'));

    await Future.delayed(Duration(seconds: 1));
    var result = await conn.query(
        'INSERT INTO users (name, password) values (?, ?)', [name, password]);

    print('Inserted row id=${result.insertId}');

    var userId = 2;
    await Future.delayed(Duration(seconds: 1));

    var results =
        await conn.query('SELECT name FROM users WHERE id = ?', [userId]);
    var DataNameUserName;
    //DataNameUserName = results.fields;
    for (var row in results) {
      DataNameUserName = row[0];
    }
    await conn.close();
  }

  reguster() {
    print("Register");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    20.0,
                    0,
                    20.0,
                    55.0,
                  ),
                  child: Center(
                    child: Text(
                      "Freesty",
                      style: TextStyle(height: 5, fontSize: 50),
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(children: [
                  Container(
                    width: double.maxFinite,
                    height: 400,
                    color: Color.fromARGB(255, 255, 255, 255),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Container(
                            width: double.maxFinite,
                            height: 300,
                            color: Color.fromARGB(255, 28, 63, 108),
                            padding: EdgeInsets.all(10),
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Column(children: <Widget>[
                                Text(
                                  "Регистрация",
                                  style: TextStyle(
                                    height: 2,
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 218, 188, 23),
                                  ),
                                ),
                                TextField(
                                  obscureText: false,
                                  onChanged: _add_name,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Логин',
                                  ),
                                ),
                                TextField(
                                  obscureText: true,
                                  onChanged: _add_password,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Пароль',
                                  ),
                                ),
                                TextButton(
                                  //onPressed: () => Navigator.pop(context, 'OK'),
                                  onPressed: () {
                                    add_data_base();
                                    Navigator.pushNamed(context, '/');
                                  },
                                  child: const Text(
                                    'Дальше',
                                    style: TextStyle(
                                      height: 2,
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 218, 188, 23),
                                    ),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    child: Text(
                                      'Уже есть аккаунт?',
                                      style: TextStyle(
                                        height: 2,
                                        fontSize: 20,
                                        color:
                                            Color.fromARGB(255, 218, 188, 23),
                                      ),
                                    )),
                              ]),
                            )),
                      ),
                    ),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Login extends StatefulWidget {
  @override
  Login_user createState() => Login_user();
}

class Login_user extends State<Login> {
  String user_name = '';
  String user_password = '';
  String authorisaishion = '';
  bool authorisaishion_flag = false;
  @override
  _add_name(String text) {
    user_name = text;
    print(user_name);
  }

  @override
  _add_password(String text) {
    user_password = text;
    check_user_name();
    print(user_name);
  }

  @override
  Future check_user_name() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        db: 'app',
        password: '135797531AaA'));

    var userId = 2;
    await Future.delayed(Duration(seconds: 1));

    var results = await conn.query(
        'SELECT name, password, id FROM app.users WHERE name LIKE ? AND password LIKE ?;',
        [user_name, user_password]);
    var DataNameUserName;
    //DataNameUserName = results.fields;
    for (var row in results) {
      DataNameUserName = row[0];
      id = row[2];
    }
    print("$DataNameUserName  DataNameUserName");
    print(my_route + " my route");
    if (DataNameUserName != "" && DataNameUserName != null) {
      register_flag = true;
      my_route = '/';
      name = user_name;
      print(my_route + "ROUTE");
    }
    show_data_base();
    await conn.close();
  }

  reguster() {
    print("Register");
  }

  check_route() {
    print(my_route + " my_route");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    20.0,
                    20.0,
                    20.0,
                    95.0,
                  ),
                  child: Center(
                    child: Text("Freesty"),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                      width: double.maxFinite,
                      height: 300,
                      color: Color.fromARGB(255, 59, 56, 45),
                      padding: EdgeInsets.all(40),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: <Widget>[
                          TextField(
                            obscureText: false,
                            onChanged: _add_name,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'You name',
                            ),
                          ),
                          TextField(
                            obscureText: true,
                            onChanged: _add_password,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'You password',
                            ),
                          ),
                          TextButton(
                            //onPressed: () => Navigator.pop(context, 'OK'),
                            onPressed: () {
                              show_data_base();
                              Navigator.pushNamed(context, my_route);
                            },
                            child: const Text('Дальше!'),
                          ),
                          TextButton(
                            //onPressed: () => Navigator.pop(context, 'OK'),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/register'),
                            child: const Text('Все же нет аккаунта?)'),
                          ),
                        ]),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
