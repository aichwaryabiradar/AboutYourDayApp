import 'package:flutter/material.dart';

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  String _inputText = ""; // Holds the user's input text

  void _saveText() {
    // Implement your save logic here
    // For example, you could save the text to local storage, send it to a server, etc.
    print("Saved text: $_inputText");
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 105, 104, 98),
      ),
      backgroundColor: const Color.fromARGB(255, 186, 183, 166),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Let’s see what you got to write today!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Gagalin-Regular',
                    fontSize: 30,
                    color: Color.fromARGB(255, 105, 104, 98),
                  ),
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Container(
                      //width: 410,
                      height: screenSize.height*0.60,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/writepagefinal.png'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 300,
                        maxHeight: 400, // Restrict the height to the image's height
                      ),
                      child: SingleChildScrollView(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _inputText = value; // Update the input text on change
                            });
                          },
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Lucida-console',
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: 'Type here...',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Lucida-console',
                              fontSize: 22,
                            ),
                            border: InputBorder.none,
                          ),
                          maxLines: null, // Allows the text to wrap to the next line
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: _saveText, // Call the save function when pressed
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 105, 104, 98),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Gagalin-Regular',
                      fontSize: 24,
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
