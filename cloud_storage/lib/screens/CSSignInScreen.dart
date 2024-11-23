import 'dart:convert';
import 'package:cloud_storage/screens/CSDashboardScreen.dart';
import 'package:cloud_storage/screens/CSSignUpScreen.dart';
import 'package:cloud_storage/utils/CSColors.dart';
import 'package:cloud_storage/utils/CSConstants.dart';
import 'package:cloud_storage/utils/CSWidgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;

class CSSignInScreen extends StatefulWidget {
  static String tag = '/CSSignInScreen';

  @override
  CSSignInScreenState createState() => CSSignInScreenState();
}

class CSSignInScreenState extends State<CSSignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> loginUser(String username, String password) async {
  final url = Uri.parse('http://localhost:8080/auth');
  final body = jsonEncode({'username': username, 'password': password});

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      // Успешный вход
      final token = jsonDecode(response.body)['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      await prefs.setString('username', username);  

      toastLong("Вход выполнен успешно");
      CSDashboardScreen().launch(context);
    } else {
      // Ошибка входа
      final responseBody = response.body;
      final xmlResponse = xml.XmlDocument.parse(responseBody);
      final errorMessage = xmlResponse.findAllElements('error').first.name;
      toastLong("Ошибка входа: $errorMessage");
    }
  } catch (e) {
    // Обработка сетевых ошибок
    toastLong("Ошибка сети: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CSCommonAppBar(context, title: "Sign in to $CSAppName"),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: Column(
                children: [
                  TextFormField(
                    controller: usernameController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Введите имя пользователя";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration("Имя пользователя"),
                  ),
                  20.height,
                  TextFormField(
                    controller: passwordController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Введите пароль";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: buildInputDecoration("Пароль"),
                  ),
                  20.height,
                  authButtonWidget("Войти").onTap(() async {
                    if (_formKey.currentState!.validate()) {
                      String username = usernameController.text;
                      String password = passwordController.text;

                      await loginUser(username, password);
                    }
                  }),
                  20.height,
                  TextButton(
                    onPressed: () {
                      CSSignUpScreen().launch(context);
                    },
                    child: Text(
                      "Зарегистрироваться в Cloudbox",
                      style: boldTextStyle(
                        size: 17,
                        color: CSDarkBlueColor,
                      ),
                    ),
                  ),
                  20.height,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration(String labelText) {
    return InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.black),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.black, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.5,
          color: CSGreyColor,
        ),
        borderRadius: BorderRadius.zero,
      ),
    );
  }
}

Future<http.Response> authenticatedRequest(
    Uri url, String method, {Map<String, String>? headers, Object? body}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');

  if (token == null) {
    throw Exception('Токен не найден');
  }

  headers ??= {};
  headers['Authorization'] = 'Bearer $token';

  switch (method) {
    case 'GET':
      return http.get(url, headers: headers);
    case 'POST':
      return http.post(url, headers: headers, body: body);
    case 'PUT':
      return http.put(url, headers: headers, body: body);
    case 'DELETE':
      return http.delete(url, headers: headers);
    default:
      throw Exception('Неподдерживаемый метод');
  }
}