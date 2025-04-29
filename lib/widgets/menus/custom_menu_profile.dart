import 'package:flutter/material.dart';
import 'package:project_v1/widgets/texts/customs_texts.dart';

class CustomMenuProfile extends StatelessWidget {
  final List<Map<String, dynamic>> listItems;

  const CustomMenuProfile({
    super.key,
    required this.listItems,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: listItems.length,
        separatorBuilder: (context, index) => const Divider(
          thickness: 0.3,
          color: Color.fromARGB(255, 205, 205, 205),
        ),
        itemBuilder: (context, index) {
          final item = listItems[index];
          return SizedBox(
            height: 65.0,
            child: Container(
              alignment: Alignment.center,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                leading: Icon(
                  item['leading'],
                  size: 29,
                  color: const Color(0xFF7D848D),
                ),
                title: SubtitleText(
                  text: item['title'],
                  fontSize: 20,
                  color: Colors.black,
                ),
                trailing: Icon(
                  item['trailing'],
                  size: 18,
                  color: const Color(0xFF7D848D),
                ),
                onTap: item['onTap'] ??
                    () {
                      if (item['destination'] != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => item['destination'],
                          ),
                        );
                      }
                    }, // Navega solo si hay un destination válido
              ),
            ),
          );
        },
      ),
    );
  }
}
