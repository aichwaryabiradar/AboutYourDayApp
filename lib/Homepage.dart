/*6import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yourday/Calendarpage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromRGBO(240, 147, 147, 1),title: Text('Your Day!',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),),
      
      //backgroundColor: Color.fromRGBO(240, 202, 202, 1),   
 body: Center(
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  Container(decoration: BoxDecoration(color: Color.fromRGBO(240, 147, 147, 1),borderRadius: BorderRadius.circular(15)),),
                  Container(
                     width: screenSize.width,
                              height: screenSize.height,
                    //decoration: BoxDecoration(
                    //  image: DecorationImage(
                      //  fit: BoxFit.cover, image:AssetImage('assets/firstpage.png'),
                     // ),
                    //),
                  ),
                ],
              ),
              Positioned(
                bottom: 27,
                right: 23,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(45),color: Color.fromRGBO(240, 147, 147, 1)),
                  child: IconButton(
                    onPressed: () { 
                      Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalendarPage()),);},
                    icon:Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.white,
                      size: 70,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}*/

import 'package:flutter/material.dart';
import 'package:yourday/Calendarpage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(240, 147, 147, 1),
        title: Text(
          'Your Day!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        color: Color.fromRGBO(240, 202, 202, 1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: screenSize.width ,
                  height: screenSize.height * 0.25,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/firstfirst.png'),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: screenSize.width * 0.9,
                  height: screenSize.height * 0.15,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(240, 147, 147, 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      'Tell  us  about  your Day!',
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Amsterdam' ,
                        color: Color.fromARGB(248, 61, 52, 52),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Adds some spacing between the container and the image
              Container(
                width: screenSize.width * 1,
                height: screenSize.height * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/firstsecond.png'),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              SizedBox(height: 20), // Adds some spacing between the image and the button
              Positioned(
                bottom: 10,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    color: Color.fromRGBO(240, 147, 147, 1),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CalendarPage(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.white,
                      size: 70,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}