import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CustomColumn extends MultiChildRenderObjectWidget {
  CustomColumn({Key? key, List<Widget> children = const []})
      : super(key: key, children: children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomColumnRenderObject();
  }
}

class CustomColumnRenderObject extends RenderBox with
    ContainerRenderObjectMixin<RenderBox, FlexParentData>, RenderBoxContainerDefaultsMixin<RenderBox, FlexParentData> {
  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! FlexParentData) {
      child.parentData = FlexParentData();
    }
  }

  @override
  void performLayout() {
    double width = 0, height = 0;
    RenderBox? child = firstChild;
    var flex = 0;

    while (child != null) {
      final childParentData = child.parentData as FlexParentData;
      var childFlex = childParentData.flex?? 0;
      flex += childFlex;
      if (childFlex== 0) {
        child.layout(BoxConstraints(maxWidth: constraints.maxHeight), parentUsesSize: true);
        childParentData.offset = Offset(0, height);
        height += child.size.height;
        width = max(width, child.size.width);
      }

      child = childParentData.nextSibling;
    }

    if (flex > 0) {
      var remainHeight = constraints.maxHeight - height;
      height = 0;
      child = firstChild;
      while (child != null) {
        final childParentData = child.parentData as FlexParentData;
        var childFlex = childParentData.flex?? 0;
        if (childFlex > 0) {
          var childHeight = remainHeight / flex * childFlex;
          child.layout(BoxConstraints(maxWidth: constraints.maxHeight, maxHeight: childHeight, minHeight: childHeight), parentUsesSize: true);
        }
        childParentData.offset = Offset(0, height);
        height += child.size.height;
        child = childParentData.nextSibling;
      }
    }

    size = Size(width, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}