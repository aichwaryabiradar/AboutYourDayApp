import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourday/RecordvoicePage.dart';

class DrawPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize;
    return Scaffold(
      backgroundColor: Color.fromRGBO(199, 201, 199, 1),
      appBar: AppBar(
        //title: Text('Draw Page'),
        backgroundColor: Color.fromRGBO(91, 97, 89, 1),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment:MainAxisAlignment.spaceAround ,
                children: [
                  Text(
                    "Let’s see your \ncolorful day!",
                    style: TextStyle(
                        color: Color.fromRGBO(91, 97, 89, 1),
                        fontSize: 32,
                        fontFamily: 'Gagalin-Regular'),
                  ),
                  Container(
                    
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        color: Color.fromRGBO(91, 97, 89, 1)),
                  )
                ],
              ),
            ),
            Container(
              height: 700,
              width: 350,
              decoration: BoxDecoration(color: Colors.white),
              child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecordVoicePage(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 70,
                    ),
                  ),
            )
          ],
        ),
      ),
    );
  }
}
