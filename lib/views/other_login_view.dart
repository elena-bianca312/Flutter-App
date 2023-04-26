import 'package:flutter/material.dart';
import 'package:myproject/animation/heart.dart';
import 'package:myproject/animation/fade_animation.dart';

class OtherLoginView extends StatefulWidget {
  const OtherLoginView({super.key});

  @override
  State<OtherLoginView> createState() => _OtherLoginViewState();
}

class _OtherLoginViewState extends State<OtherLoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        child: Column(
          children: <Widget>[
            Container(
              // height: 400,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bloc1.jpg'),
                  fit: BoxFit.fill
                )
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: FadeAnimation(2, Axis.vertical, Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: const Center(
                        child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                      ),
                    )),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(143, 148, 251, .2),
                          blurRadius: 20.0,
                          offset: Offset(0, 10)
                        )
                      ]
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: const TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email or Phone number",
                              hintStyle: TextStyle(color: Colors.grey)
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey)
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(143, 148, 251, 1),
                          Color.fromRGBO(143, 148, 251, .6),
                        ]
                      )
                    ),
                    child: const Center(
                      child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              ),
            ),
          ]
        )
      )
    );
  }
}