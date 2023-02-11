import 'package:flashchat/Constants.dart';
import 'package:flashchat/Widgets/NotesBubble.dart';
import 'package:flutter/material.dart';

class PopupMenuContainer<T> extends StatefulWidget {
  final NotesBubble child;
  final List<PopupMenuEntry<T>> items;
  final void Function(int value) onItemSelected;
  final Color menuColor;

  const PopupMenuContainer({
    required this.items,
    required this.child,
    required this.onItemSelected,
    required Key? key,
    required this.menuColor,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PopupMenuContainerState<T>();
}

class PopupMenuContainerState<T> extends State<PopupMenuContainer<T>> {
  late Offset _tapDownPosition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _tapDownPosition = details.globalPosition;
      },
      onLongPress: () async {
        final RenderBox overlay =
            Overlay.of(context)?.context.findRenderObject() as RenderBox;
        (await showMenu<T>(
          color: foregroundColor2,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          context: context,
          items: widget.items,
          position: RelativeRect.fromLTRB(
            _tapDownPosition.dx,
            _tapDownPosition.dy,
            overlay.size.width - _tapDownPosition.dx,
            overlay.size.height - _tapDownPosition.dy,
          ),
        ));
        widget.onItemSelected(widget.child.leadIndex);
      },
      child: widget.child,
    );
  }
}
