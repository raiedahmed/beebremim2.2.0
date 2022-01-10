import 'package:flutter/material.dart';
import 'post_category_item.dart';

class PostCategoryItemHorizontal extends PostCategoryItem {
  /// widget image PostCategory
  final Widget image;

  /// widget title PostCategory
  final Widget title;

  /// widget count PostCategory
  final Widget? count;

  /// Function onClick PostCategory
  final Function? onClick;

  final Color? color;

  /// The z-coordinate of this [PostCategoryItemHorizontal].
  /// If null, defaults to `0.0`.
  final double? elevation;

  /// add shadowColor PostCategory
  final Color? shadowColor;

  /// add shape PostCategory
  final ShapeBorder? shape;

  /// The constructor `width` arguments are combined with the
  /// `PostCategoryItemHorizontal` argument to set this property.
  final double? width;

  // final
  const PostCategoryItemHorizontal({
    Key? key,
    required this.image,
    required this.title,
    this.onClick,
    this.count,
    this.width = 335,
    this.elevation = 0.0,
    this.shadowColor,
    this.color,
    this.shape = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
  }) : super(
          key: key,
          elevationPostCategory: elevation,
          shadowColorPostCategory: shadowColor,
          colorPostCategory: color,
          shapePostCategory: shape,
        );

  @override
  Widget buildLayout(BuildContext context) {
    return InkResponse(
      onTap: () => onClick?.call(),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            image,
            const SizedBox(width: 16),
            Expanded(
              child: title,
            ),
            if (count is Widget)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 8),
                child: count ?? Container(),
              )
          ],
        ),
      ),
    );
  }
}
