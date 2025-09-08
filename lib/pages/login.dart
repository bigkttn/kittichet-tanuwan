import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/config/inernal.config.dart';
import 'package:flutter_application_1/model/request/customer_login_post_req.dart';
import 'package:flutter_application_1/model/response/customer_login_post_res.dart';
import 'package:flutter_application_1/pages/RegisterPage.dart';
import 'package:flutter_application_1/pages/ShowTropPage.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  int number = 0;
  String phonenumber = '';
  TextEditingController phoneCT1 = TextEditingController();
  TextEditingController phoneCT2 = TextEditingController();
  String url = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => login(),
                child: Image.network(
                  "https://static.vecteezy.com/system/resources/thumbnails/036/324/708/small/ai-generated-picture-of-a-tiger-walking-in-the-forest-photo.jpg",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 2, top: 20),
                child: Text("หมายเลขโทรศัพท์", style: TextStyle(fontSize: 18)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: TextField(
                  controller: phoneCT1,
                  // onChanged: (value) {
                  //   phonenumber = value;
                  // },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 2, top: 20),
                child: Text("รหัสผ่าน", style: TextStyle(fontSize: 18)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: TextField(
                  controller: phoneCT2,
                  keyboardType: TextInputType.phone,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextButton(
                      onPressed: register,
                      child: const Text("ลงทะเบียนใหม่"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilledButton(
                      onPressed: () => submit(),
                      child: const Text('เข้าสู่ระบบ'),
                    ),
                  ),
                ],
              ),
              Center(child: Text(text, style: TextStyle(fontSize: 20))),
            ],
          ),
        ),
      ),
    );
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Registerpage()),
    );
  }

  void login() {
    setState(() {
      text = '1222';
    });
    //dart
    log(text);
  }

  void submit() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => Showtrippage()),
    // );
    // if (phoneCT1.text == '0' && phoneCT2.text == '1234') {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => Showtrippage()),
    //   );
    // } else {
    //   setState(() {
    //     text = 'phone no or password incorrect';
    //   });
    // }
    // var data = {"phone": "0817399999", "password": "1111"};
    CustomerLoginPostRequest customerLoginPostRequest =
        CustomerLoginPostRequest(phone: phoneCT1.text, password: phoneCT2.text);
    log(url);
    http
        .post(
          Uri.parse("$API_ENDPOINT/customers/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerLoginPostRequestToJson(customerLoginPostRequest),
        )
        .then((value) {
          CustomerLoginPostResponse customerLoginPostResponse =
              customerLoginPostResponseFromJson(value.body);
          log(customerLoginPostResponse.customer.fullname);
          log(customerLoginPostResponse.customer.email);
          log(customerLoginPostResponse.customer.idx.toString());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Showtrippage(cid: customerLoginPostResponse.customer.idx),
            ),
          );
        })
        .catchError((error) {
          log('Error $error');
        });
    // http
    //     .get(Uri.parse("http://10.34.10.138:3000/customers"))
    //     .then((value) {
    //       log(value.body);
    //     })
    //     .catchError((error) {
    //       log('Error $error');
    //     });
  }
}
