import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yourday/DrawPage.dart';
import 'package:yourday/Writepage.dart';  // Import intl package for date formatting

class SelectionPage extends StatelessWidget {
  final DateTime selectedDay;
  const SelectionPage({super.key, required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final formattedDate = DateFormat('dd-MM-yyyy').format(selectedDay); // Format the date

    // List of options for the list and their corresponding pages
    final List<String> options = ["Write", "Draw", "Record voice", "Add Image / Video"];
    final List<Widget> pages = [WritePage(), DrawPage(), RecordVoicePage(), AddImageVideoPage()];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 15, 148, 20),
      ),
      backgroundColor: Color.fromARGB(255, 231, 251, 222),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,  // Aligns items to the start
        children: [
          SizedBox(height: 20),  // Add some space at the top
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'You selected: $formattedDate',  // Display the formatted date
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          SizedBox(height: 20),  // Add some space between the date and the text
          Text(
            'Select what you wanna do!',  // Instruction text
            style: TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.bold,
              fontFamily: 'Gagalin-Regular',
              color: Color.fromARGB(255, 15, 148, 20),
            ),
          ),
          SizedBox(height: 20),  // Add some space between the text and the containers
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(height: 20);  // Space between containers
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
                          builder: (context) => pages[index],  // Navigate to the corresponding page
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
                          options[index],  // Use text from the options list
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
            mainAxisAlignment: MainAxisAlignment.end,  // Align the image to the right
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),  // Add padding to move the image to the right
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

// Sample pages for navigation
/*class WritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Write Page')),
      body: Center(child: Text('This is the Write Page')),
    );
  }
}*/



class RecordVoicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Record Voice Page')),
      body: Center(child: Text('This is the Record Voice Page')),
    );
  }
}

class AddImageVideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Image/Video Page')),
      body: Center(child: Text('This is the Add Image/Video Page')),
    );
  }
}
