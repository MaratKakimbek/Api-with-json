import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        '/users': (context) => DataFromAPI(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateInputs);
    _passwordController.addListener(_validateInputs);
  }

  void _validateInputs() {
    final email = _emailController.text;
    final password = _passwordController.text;

    setState(() {
      _isButtonDisabled = email.isEmpty || password.isEmpty;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              margin: const EdgeInsets.all(16.0),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Вход',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Вход',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'Пароль',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isButtonDisabled
                          ? null
                          : () {
                              Navigator.pushNamed(context, '/users');
                            },
                      child: Text('Войти'),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(double.infinity, 48.0),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.purple[200]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DataFromAPI extends StatefulWidget {
  @override
  _DataFromAPIState createState() => _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {
  Future getUserData() async {
    var responce =
        await http.get(Uri.https('jsonplaceholder.typicode.com', 'users'));
    var jsonData = jsonDecode(responce.body);
    List<User> users = [];

    for (var u in jsonData) {
      User user = User(u["name"], u["email"], u["username"]);
      users.add(user);
    }
    print(users.length);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Пользователи'),
        ),
        body: Container(
          child: Card(
              child: FutureBuilder(
                  future: getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://st2.depositphotos.com/1032749/9444/v/950/depositphotos_94449248-stock-illustration-person-icon-symbol-illustration-design.jpg/350x150"),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data[i].name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data[i].username,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(snapshot.data[i].email),
                            );
                          });
                  })),
        ));
  }
}

class User {
  final String name, email, username;
  User(this.name, this.email, this.username);
}
