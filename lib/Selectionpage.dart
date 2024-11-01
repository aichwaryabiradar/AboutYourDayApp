import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yourday/DrawPage.dart';
import 'package:yourday/ImageVideo.dart';
import 'package:yourday/RecordvoicePage.dart';
import 'package:yourday/Writepage.dart';
import 'package:yourday/CalendarPage.dart'; // Import CalendarPage

class SelectionPage extends StatelessWidget {
  final DateTime selectedDay;
  const SelectionPage({super.key, required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final formattedDate =
        DateFormat('dd-MM-yyyy').format(selectedDay);

    final List<String> options = [
      "Write",
      "Draw",
      "Record voice",
      "Add Image / Video"
    ];
    final List<Widget> pages = [
      WritePage(),
      DrawPage(),
      RecordVoicePage(
        selectedDay: selectedDay,
      ),
      ImageVideo()
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 15, 148, 20),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CalendarPage()),
            );
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 231, 251, 222),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Selected Date: $formattedDate',
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'PlayfairDisplay',
                    color: Color.fromARGB(255, 15, 148, 20),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Select what you wanna do!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Gagalin-Regular',
              color: Color.fromARGB(255, 15, 148, 20),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(height: 20);
              },
              itemCount: options.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => pages[index],
                        ),
                      );
                    },
                    child: Container(
                      height: 85,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 131, 210, 98),
                        borderRadius: BorderRadius.circular(45),
                      ),
                      child: Center(
                        child: Text(
                          options[index],
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontFamily: 'BrittanySignature',
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Container(
                  width: screenSize.width * 0.5,
                  height: screenSize.height * 0.2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/selectionfirst.png'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
