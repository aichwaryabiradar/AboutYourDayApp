import 'package:flutter/material.dart';
import 'package:yourday/AddImagePage.dart';
import 'package:yourday/AddVideoPage.dart';

class ImageVideo extends StatelessWidget {
  const ImageVideo({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> options = [
      "Add Image",
      "Add Video",
    ];
    final List<IconData> icons = [
      Icons.add_a_photo, // Icon for Add Image
      Icons.video_library, // Icon for Add Video
    ];
    final List<Widget> pages = [
      const AddImagePage(),
      const AddVideoPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(222, 99, 50, 1),
      ),
      backgroundColor: const Color.fromRGBO(255, 215, 177, 1),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              "Let’s see what you have!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Gagalin-Regular',
                fontSize: 32,
                color: Color.fromRGBO(222, 99, 50, 1),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(height: 20); // Space between containers
              },
              itemCount: options.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(222, 99, 50, 1),
                        borderRadius: BorderRadius.circular(45),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icons[index], // Icon for each option
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(width: 10), // Space between icon and text
                            Text(
                              options[index],
                              style: const TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: 'BrittanySignature',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
           Image.asset(
                'assets/selectimagevideo.png',
                width: 280,
                height: 280,
              ),
        ],
      ),
    );
  }
}
