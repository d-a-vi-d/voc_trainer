import 'package:flutter/material.dart';

class LanguageBar extends StatelessWidget {
  final List<String> langList;
  final int selectedLangIndex;
  final int? draggingIndex;
  final int? dropPreviewIndex;
  final bool isDraggingMode;
  final VoidCallback onAddLanguage;
  final Function(int) onSelect;
  final Function(int) onDelete;
  final Function(int) onDragStart;
  final Function(int?) onDragUpdate;
  final VoidCallback onDragEnd;
  final Function(int?) onDrop;
  final Color mainGreen;
  final Color accentGreen;

  const LanguageBar({
    super.key,
    required this.langList,
    required this.selectedLangIndex,
    required this.draggingIndex,
    required this.dropPreviewIndex,
    required this.isDraggingMode,
    required this.onAddLanguage,
    required this.onSelect,
    required this.onDelete,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onDrop,
    required this.mainGreen,
    required this.accentGreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: langList.length + 1, // Plus-Slot
        itemBuilder: (context, i) {
          if (i == langList.length) {
            // Plus / Mülleimer Slot
            final isTrash = isDraggingMode;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DragTarget<int>(
                onWillAccept: (dragIndex) => true,
                onAccept: (dragIndex) => onDrop(-1),
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 70,
                    decoration: BoxDecoration(
                      color: isTrash ? Colors.red : mainGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(isTrash ? Icons.delete : Icons.add,
                        color: Colors.white),
                  );
                },
              ),
            );
          }

          final lang = langList[i];
          final isSelected = selectedLangIndex == i;
          final isDragging = draggingIndex == i;
          final isPreview = dropPreviewIndex == i && isDraggingMode;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: LongPressDraggable<int>(
              data: i,
              onDragStarted: () => onDragStart(i),
              onDragUpdate: (details) {
                // Einfacher horizontaler Check
                final box = context.findRenderObject() as RenderBox;
                final localPos = box.globalToLocal(details.globalPosition);
                int? targetIndex;
                if (localPos.dx < 40) targetIndex = 0;
                else if (localPos.dx > box.size.width - 40)
                  targetIndex = langList.length - 1;
                else targetIndex = i; // einfache Logik
                onDragUpdate(targetIndex);
              },
              onDraggableCanceled: (_, __) => onDragEnd(),
              onDragEnd: (_) => onDragEnd(),
              feedback: Material(
                child: Container(
                  width: 70,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: accentGreen,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2))
                      ]),
                  child: Center(child: Text(lang)),
                ),
              ),
              child: GestureDetector(
                onTap: () => onSelect(i),
                child: Container(
                  width: 70,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? mainGreen : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    border: isPreview
                        ? Border.all(color: Colors.blue, width: 3)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      lang,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
