import 'package:flutter/material.dart';

class LanguageBar extends StatelessWidget {
  final List<String> languages;
  final String selectedLanguage;
  final ValueChanged<String> onLanguageSelected;
  final VoidCallback onAddLanguage;
  
  const LanguageBar({
    super.key,
    required this.languages,
    required this.selectedLanguage,
    required this.onLanguageSelected,
    required this.onAddLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.grey[200],
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...languages.map((lang) {
                  final isSelected = lang == selectedLanguage;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () => onLanguageSelected(lang),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:                         
                          Text(
                            lang,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            fontSize: 16,
                            ),
                          ),
                      ),
                    ),
                  );
                }),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: onAddLanguage,

                  // showDialog(
                  //     context: context,
                  //     builder: (context) {
                  //       return AlertDialog(
                  //         title: const Text('Neue Sprache hinzufügen'),
                  //         content: TextField(
                  //           decoration: const InputDecoration(hintText: 'Sprache'),
                  //         ),
                  //         actions: [
                  //           TextButton(
                  //             onPressed: () => Navigator.of(context).pop(),
                  //             child: const Text('Abbrechen'),
                  //           ),
                  //           ElevatedButton(
                  //             onPressed: () async {
                  //               final newLang = controller.text.trim();
                  //               if (newLang.isNotEmpty && !languages.contains(newLang)) {
                  //                 await WordService.addLanguage(newLang);
                                  
                  //                 setState(() {
                  //                   languages = getLanguages();
                  //                   _currentLanguage = newLang;
                  //                 });
                  //               }
                  //               Navigator.of(context).pop();
                  //             },
                  //             child: const Text('Hinzufügen'),
                  //           ),
                  //         ],
                  //       );
                  //     },
                  //   );


                ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}      
    // return SizedBox(
    //   height: 50,
    //   child: ListView.separated(
    //     scrollDirection: Axis.horizontal,
    //     padding: const EdgeInsets.symmetric(horizontal: 8),                        
    //     itemCount: languages.length,
    //     separatorBuilder: (context, index) => const SizedBox(width: 8),
    //     itemBuilder: (context, index) {
    //       final lang = languages[index];
    //       final isSelected = lang == selectedLanguage;

    //       return GestureDetector(
    //         onTap: () => onLanguageSelected(lang),
    //         child: Container(
    //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    //           decoration: BoxDecoration(
    //             color: isSelected ? Colors.blue.shade300 : Colors.transparent,
    //             borderRadius: BorderRadius.circular(20),
    //           ),
    //           child: Center(
    //             child: Text(
    //               lang,
    //               style: TextStyle(
    //                 color: isSelected ? Colors.white : Colors.black,
                    
    //               ),
    //             ),
    //           ),
    //         ),
    //       );        
    //     }      
    //   ),
    // );
  