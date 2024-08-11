import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WritePage extends StatelessWidget {
  const WritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(
          255,
          240,
          208,
          3,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 246, 187),
      body: Center(
        // child:Column(children: [Text('let’s see what you got to write today!',style: TextStyle(fontFamily: 'Gagalin-Regular',fontSize: 30),)],),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'let’s see what you got to write today!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Gagalin-Regular',
                  fontSize: 30,
                  color: Color.fromARGB(
                    255,
                    240,
                    208,
                    3,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                  padding: const EdgeInsets.all(10),  // Add padding to move the image to the right
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        //alignment: Alignment.center,
                        image: AssetImage('assets/writefirst.png'),
                      ),
                    ),
                  ),
                ),
            ),
            Positioned(
                bottom: 27,
                right: 23,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 50,
                    width: 140,
                    child: Center(
                        child: Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Gagalin-Regular',
                          fontSize: 24),
                    )),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        color: Color.fromARGB(
                          255,
                          240,
                          208,
                          3,
                        )),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
