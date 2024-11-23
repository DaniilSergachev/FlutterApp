import 'package:cloud_storage/utils/CSColors.dart';
import 'package:cloud_storage/utils/CSWidgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CSSignUpScreen extends StatefulWidget {
  static String tag = '/CSSignUpScreen';

  @override
  CSSignUpScreenState createState() => CSSignUpScreenState();
}

class CSSignUpScreenState extends State<CSSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> registerUser(String username, String password, String confirmPassword, String email) async {
  setState(() {
    _isLoading = true;
  });

  final url = Uri.parse('http://localhost:8080/registration'); 
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'username': username,
      'password': password,
      'confirmPassword': confirmPassword,
      'email': email,
    }),
  );

  setState(() {
    _isLoading = false;
  });

  if (response.statusCode == 200) {
    toastLong("Регистрация выполнена успешно");
    // Сохраняем данные пользователя
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    // Возвращаемся на предыдущий экран
    Navigator.pop(context);
  } else {
    toastLong("Ошибка регистрации: ${response.body}");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CSCommonAppBar(context, title: 'Зарегистрироваться Cloudbox'),
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
                      if (val!.isEmpty) return "Введите имя пользователя";
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration("Имя пользователя"),
                  ),
                  20.height,
                  TextFormField(
                    controller: passwordController,
                    validator: (val) {
                      if (val!.isEmpty) return "Пожалуйста, введите пароль";
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: buildInputDecoration("Пароль"),
                  ),
                  20.height,
                  TextFormField(
                    controller: confirmPasswordController,
                    validator: (val) {
                      if (val!.isEmpty) return "Пожалуйста, подтвердите пароль";
                      if (val != passwordController.text) return "Пароли не совпадают";
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: buildInputDecoration("Подтвердите пароль"),
                  ),
                  20.height,
                  TextFormField(
                    controller: emailController,
                    validator: (val) {
                      if (val!.isEmpty) return "Пожалуйста, введите email";
                      if (!val.contains('@')) return "Неверный формат email";
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: buildInputDecoration("Email"),
                  ),
                  20.height,
                  _isLoading
                      ? CircularProgressIndicator()
                      : Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          width: context.width() * 0.9,
                          decoration: boxDecorationRoundedWithShadow(
                            5,
                            backgroundColor: CSDarkBlueColor,
                            spreadRadius: 1,
                            blurRadius: 0,
                            shadowColor: Colors.grey,
                            offset: Offset(0, 1),
                          ),
                          height: context.width() * 0.13,
                          child: Text("Зарегистрироваться", style: boldTextStyle(color: Colors.white)),
                        ).onTap(() async {
                          if (_formKey.currentState!.validate()) {
                            String username = usernameController.text;
                            String password = passwordController.text;
                            String confirmPassword = confirmPasswordController.text;
                            String email = emailController.text;

                            await registerUser(username, password, confirmPassword, email);
                          }
                        }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}