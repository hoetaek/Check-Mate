import 'package:check_mate/constants.dart';
import 'package:check_mate/widgets/todo_add_button.dart';
import 'package:check_mate/widgets/todo_check_tile_slidable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:hive/hive.dart';

enum ReorderableListSimpleSide { Right, Left }

class ReorderableSlidableListView extends StatefulWidget {
  ReorderableSlidableListView({
    @required this.children,
    @required this.onReorder,
    this.allowReordering = true,
    this.childrenAlreadyHaveListener = false,
    this.handleSide = ReorderableListSimpleSide.Left,
    this.handleIcon,
    this.padding,
  });

  final bool allowReordering;
  final bool childrenAlreadyHaveListener;
  final ReorderableListSimpleSide handleSide;
  final Icon handleIcon;
  final List<Widget> children;
  final ReorderCallback onReorder;
  final EdgeInsets padding;

  @override
  State<ReorderableSlidableListView> createState() =>
      new _ReorderableSlidableListViewState();
}

class _ReorderableSlidableListViewState
    extends State<ReorderableSlidableListView> {
  int _newIndex;
  List<Widget> _children;
  Box userBox = Hive.box(Boxes.userBox);

  @override
  void initState() {
    super.initState();
    _children = List<Widget>.from(widget.children);
  }

  @override
  didUpdateWidget(ReorderableSlidableListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _children = List<Widget>.from(widget.children);
  }

  int _oldIndexOfKey(Key key) {
    return widget.children
        .indexWhere((Widget w) => Key(w.hashCode.toString()) == key);
  }

  int _indexOfKey(Key key) {
    return _children
        .indexWhere((Widget w) => Key(w.hashCode.toString()) == key);
  }

  Widget _buildReorderableItem(BuildContext context, int index) {
    return CheckTileSlidable(
      key: Key(_children[index].hashCode.toString()),
      idx: index,
      child: Padding(
        padding: widget.padding,
        child: ReorderableItemSimple(
          key: Key(_children[index].hashCode.toString()),
          innerItem: _children[index],
          allowReordering: widget.allowReordering,
          childrenAlreadyHaveListener: widget.childrenAlreadyHaveListener,
          handleSide: widget.handleSide,
          handleIcon: widget.handleIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double bodyHeight =
        userBox.get('maxHeight') - Scaffold.of(context).appBarMaxHeight;
    return ReorderableList(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: bodyHeight - 84),
            child: ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: _children.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildReorderableItem(context, index);
              },
            ),
          ),
          SizedBox(height: 10),
          TodoAddButton(
            size: 50,
          ),
          SizedBox(height: 10),
        ],
      ),
      onReorder: (Key draggedItem, Key newPosition) {
        int draggingIndex = _indexOfKey(draggedItem);
        int newPositionIndex = _indexOfKey(newPosition);

        final item = _children[draggingIndex];
        setState(() {
          _newIndex = newPositionIndex;

          _children.removeAt(draggingIndex);
          _children.insert(newPositionIndex, item);
        });

        return true;
      },
      onReorderDone: (Key draggedItem) {
        int oldIndex = _oldIndexOfKey(draggedItem);
        if (_newIndex != null) widget.onReorder(oldIndex, _newIndex);
        _newIndex = null;
      },
    );
  }
}

class ReorderableItemSimple extends StatelessWidget {
  ReorderableItemSimple({
    @required Key key,
    @required this.innerItem,
    this.allowReordering = true,
    this.childrenAlreadyHaveListener = false,
    this.handleSide = ReorderableListSimpleSide.Right,
    this.handleIcon,
  }) : super(key: key);

  final bool allowReordering;
  final bool childrenAlreadyHaveListener;
  final ReorderableListSimpleSide handleSide;
  final Icon handleIcon;
  final Widget innerItem;

  Color _iconColor(ThemeData theme, ListTileTheme tileTheme) {
    if (tileTheme?.selectedColor != null) return tileTheme.selectedColor;

    if (tileTheme?.iconColor != null) return tileTheme.iconColor;

    switch (theme.brightness) {
      case Brightness.light:
        return theme.primaryColor;
      case Brightness.dark:
        return theme.accentColor;
    }
    assert(theme.brightness != null);
    return null;
  }

  Widget _buildInnerItem(BuildContext context) {
    assert(innerItem != null);

    if ((!allowReordering) || childrenAlreadyHaveListener) return innerItem;

    Icon icon = handleIcon;
    if (icon == null) icon = null;

    var item = Expanded(child: innerItem);
    List<Widget> children = <Widget>[];

    if (handleSide == ReorderableListSimpleSide.Right) children.add(item);
    children.add(ReorderableListener(
      child: Container(alignment: Alignment.centerLeft, child: icon),
    ));
    if (handleSide == ReorderableListSimpleSide.Left) children.add(item);

    final Row row = Row(
      mainAxisAlignment: handleSide == ReorderableListSimpleSide.Right
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );

    final ThemeData theme = Theme.of(context);
    final ListTileTheme tileTheme = ListTileTheme.of(context);

    return IconTheme.merge(
      data: IconThemeData(color: _iconColor(theme, tileTheme)),
      child: row,
    );
  }

  BoxDecoration _decoration(BuildContext context, ReorderableItemState state) {
    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      return BoxDecoration(color: Color(0xD0FFFFFF));
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      return BoxDecoration(
        border: Border(
            top: !placeholder
                ? Divider.createBorderSide(context)
                : BorderSide.none,
            bottom: placeholder
                ? BorderSide.none
                : Divider.createBorderSide(context)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
      key: key,
      childBuilder: (BuildContext context, ReorderableItemState state) {
        BoxDecoration decoration = _decoration(context, state);
        return Container(
          decoration: decoration,
          child: Opacity(
            opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
            child: _buildInnerItem(context),
          ),
        );
      },
    );
  }
}
