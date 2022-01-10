import 'package:awesome_bottom_bar2/awesome_bottom_bar2.dart';
import 'package:awesome_bottom_bar2/widgets/inspired/inspired.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tab_item_count.dart';

class Tabs extends StatefulWidget {
  final String? selected;
  final Function? onItemTapped;
  final Data? data;

  const Tabs({
    Key? key,
    this.selected,
    this.onItemTapped,
    this.data,
  }) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with Utility {
  int _currentIndex = 0;
  final List listKey = [];
  int fixedIndex = 0;
  bool active = false;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;
    String? languageKey = settingStore.languageKey;

    WidgetConfig widgetConfig = widget.data!.widgets!['tabs']!;

    List items = get(widgetConfig.fields, ['items'], []);

    _tabItems() {
      return List.generate(items.length, (index) {
        final item = items.elementAt(index);
        String key = get(item, ['data', 'action', 'args', 'key'], '');
        bool active = get(item, ['active'], false);
        bool enableCount = get(item, ['data', 'enableCount'], false);
        String countType = get(item, ['data', 'countType'], 'Cart');
        listKey.add(key);
        if (active) {
          setState(() {
            fixedIndex = index;
          });
        }
        return TabItem(
          icon: FeatherIconsMap[get(item, ['data', 'icon', 'name'], 'home')],
          title: get(item, ['data', 'title', languageKey], ''),
          key: get(item, ['data', 'action', 'args', 'key'], ''),
          count: enableCount
              ? TabItemCount(
                  type: countType,
                )
              : null,
        );
      });
    }

    String layoutData = widgetConfig.layout ?? 'default';

    Color background =
        ConvertData.fromRGBA(get(widgetConfig.styles, ['background', themeModeKey], {}), theme.bottomAppBarColor);

    Color textColor = ConvertData.fromRGBA(get(widgetConfig.styles, ['color', themeModeKey], {}), Colors.black);

    Color activeColor =
        ConvertData.fromRGBA(get(widgetConfig.styles, ['colorActive', themeModeKey], {}), theme.primaryColor);

    Color colorOnActive =
        ConvertData.fromRGBA(get(widgetConfig.styles, ['colorOnActive', themeModeKey], {}), theme.primaryColor);

    double? radius = ConvertData.stringToDouble(get(widgetConfig.styles, ['radius'], 0));

    double? activeBorderRadius = ConvertData.stringToDouble(get(widgetConfig.styles, ['activeBorderRadius'], 30));

    bool? enableShadow = get(widgetConfig.styles, ['enableShadow'], true);
    bool? animated = get(widgetConfig.fields, ['animated'], true);
    bool? fixedActive = get(widgetConfig.fields, ['fixedActive'], false);

    double? padTop = ConvertData.stringToDouble(get(widgetConfig.styles, ['padTop'], 12));
    double? pad = ConvertData.stringToDouble(get(widgetConfig.styles, ['pad'], 4));
    double? padBottom = ConvertData.stringToDouble(get(widgetConfig.styles, ['padBottom'], 12));

    // int defaultVisit = _tabItems().length / 2 == 0 ? 0 : (_tabItems().length / 2).ceil() - 1;
    indexSelected() {
      if (fixedActive! && !active) {
        return fixedIndex;
      }
      return listKey.indexOf(widget.selected);
    }

    Widget styleBottomBar() {
      switch (layoutData) {
        case 'border_top':
          return BottomBarDivider(
            items: _tabItems(),
            colorSelected: activeColor,
            color: textColor,
            indexSelected: active
                ? listKey.indexOf(widget.selected)
                : fixedActive!
                    ? fixedIndex
                    : listKey.indexOf(widget.selected),
            backgroundColor: background,
            onTap: (int index) {
              _currentIndex = index;
              active = true;
              widget.onItemTapped!(_tabItems().elementAt(_currentIndex).key);
            },
            top: padTop,
            bottom: padBottom,
            pad: pad,
            animated: animated!,
            enableShadow: enableShadow,
          );
        case 'border_bottom':
          return BottomBarDivider(
            items: _tabItems(),
            colorSelected: activeColor,
            color: textColor,
            indexSelected: active
                ? listKey.indexOf(widget.selected)
                : fixedActive!
                    ? fixedIndex
                    : listKey.indexOf(widget.selected),
            backgroundColor: background,
            onTap: (int index) {
              _currentIndex = index;
              active = true;
              widget.onItemTapped!(_tabItems().elementAt(_currentIndex).key);
            },
            top: padTop,
            bottom: padBottom,
            pad: pad,
            animated: animated!,
            enableShadow: enableShadow,
            styleDivider: StyleDivider.bottom,
          );
        case 'salomon':
          return BottomBarSalomon(
            items: _tabItems(),
            color: textColor,
            backgroundColor: background,
            colorSelected: colorOnActive,
            backgroundSelected: activeColor,
            top: padTop,
            bottom: padBottom,
            animated: animated!,
            enableShadow: enableShadow,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
            ),
            radiusSalomon: BorderRadius.circular(activeBorderRadius),
            indexSelected: active
                ? listKey.indexOf(widget.selected)
                : fixedActive!
                    ? fixedIndex
                    : listKey.indexOf(widget.selected),
            onTap: (int index) {
              _currentIndex = index;
              active = true;
              widget.onItemTapped!(_tabItems().elementAt(_currentIndex).key);
            },
          );
        case 'inspired_inside':
          return BottomBarInspiredInside(
            items: _tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: colorOnActive,
            indexSelected: indexSelected(),
            animated: animated!,
            isAnimated: false,
            radius: radius,
            padTop: padTop,
            pad: pad,
            fixed: fixedActive!,
            fixedIndex: fixedIndex,
            padbottom: padBottom,
            onTap: (int index) {
              _currentIndex = index;
              active = true;
              widget.onItemTapped!(_tabItems().elementAt(_currentIndex).key);
            },
            elevation: enableShadow == true ? 5 : 0,
            itemStyle: ItemStyle.circle,
            chipStyle: ChipStyle(convexBridge: true, background: activeColor),
          );
        case 'inspired_inside_hexagon':
          return BottomBarInspiredInside(
            items: _tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: colorOnActive,
            indexSelected: indexSelected(),
            animated: animated!,
            isAnimated: false,
            radius: radius,
            padTop: padTop,
            pad: pad,
            fixed: fixedActive!,
            fixedIndex: fixedIndex,
            padbottom: padBottom,
            elevation: enableShadow == true ? 5 : 0,
            onTap: (int index) {
              _currentIndex = index;
              active = true;
              widget.onItemTapped!(_tabItems().elementAt(_currentIndex).key);
            },
            itemStyle: ItemStyle.hexagon,
            chipStyle: ChipStyle(isHexagon: true, background: activeColor),
          );
        case 'inspired_outside':
          return BottomBarInspiredOutside(
            items: _tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: colorOnActive,
            indexSelected: indexSelected(),
            animated: animated!,
            isAnimated: false,
            radius: radius,
            padTop: padTop,
            pad: pad,
            fixed: fixedActive!,
            fixedIndex: fixedIndex,
            padbottom: padBottom,
            elevation: enableShadow == true ? 5 : 0,
            onTap: (int index) {
              _currentIndex = index;
              active = true;
              widget.onItemTapped!(_tabItems().elementAt(_currentIndex).key);
            },
            itemStyle: ItemStyle.circle,
            chipStyle: ChipStyle(notchSmoothness: NotchSmoothness.sharpEdge, background: activeColor),
          );
        case 'inspired_outside_hexagon':
          return BottomBarInspiredOutside(
            items: _tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: colorOnActive,
            indexSelected: indexSelected(),
            animated: animated!,
            isAnimated: false,
            elevation: enableShadow == true ? 5 : 0,
            onTap: (int index) {
              _currentIndex = index;
              active = true;
              widget.onItemTapped!(_tabItems().elementAt(_currentIndex).key);
            },
            radius: radius,
            padTop: padTop,
            pad: pad,
            fixed: fixedActive!,
            fixedIndex: fixedIndex,
            padbottom: padBottom,
            itemStyle: ItemStyle.hexagon,
            chipStyle:
                ChipStyle(notchSmoothness: NotchSmoothness.defaultEdge, drawHexagon: true, background: activeColor),
          );
        case 'inspired_outside_deep':
          return BottomBarInspiredOutside(
            items: _tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: colorOnActive,
            indexSelected: indexSelected(),
            animated: animated!,
            isAnimated: false,
            elevation: enableShadow == true ? 5 : 0,
            onTap: (int index) {
              _currentIndex = index;
              active = true;
              widget.onItemTapped!(_tabItems().elementAt(_currentIndex).key);
            },
            radius: radius,
            padTop: padTop,
            pad: pad,
            fixed: fixedActive!,
            fixedIndex: fixedIndex,
            padbottom: padBottom,
            itemStyle: ItemStyle.circle,
            chipStyle: ChipStyle(notchSmoothness: NotchSmoothness.verySmoothEdge, background: activeColor),
          );
        case 'inspired_outside_radius':
          return BottomBarInspiredOutside(
            items: _tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: colorOnActive,
            indexSelected: indexSelected(),
            animated: animated!,
            isAnimated: false,
            elevation: enableShadow == true ? 5 : 0,
            onTap: (int index) {
              _currentIndex = index;
              active = true;
              widget.onItemTapped!(_tabItems().elementAt(_currentIndex).key);
            },
            radius: radius,
            padTop: padTop,
            pad: pad,
            fixed: fixedActive!,
            fixedIndex: fixedIndex,
            padbottom: padBottom,
            itemStyle: ItemStyle.circle,
            chipStyle: ChipStyle(notchSmoothness: NotchSmoothness.softEdge, background: activeColor),
          );
        case 'inspired_curve':
          return BottomBarCreative(
            items: _tabItems(),
            backgroundColor: background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
            ),
            color: textColor,
            colorSelected: activeColor,
            enableShadow: enableShadow,
            indexSelected: indexSelected(),
            highlightStyle: HighlightStyle(
              sizeLarge: true,
              background: activeColor,
              color: colorOnActive,
            ),
            top: padTop,
            pad: pad,
            bottom: padBottom,
            isFloating: true,
            onTap: (int index) {
              _currentIndex = index;
              active = true;
              widget.onItemTapped!(_tabItems().elementAt(_currentIndex).key);
            },
          );
        case 'inspired_curve_hexagon':
          return BottomBarCreative(
            items: _tabItems(),
            backgroundColor: background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
            ),
            color: textColor,
            colorSelected: activeColor,
            enableShadow: enableShadow,
            indexSelected: indexSelected(),
            highlightStyle: HighlightStyle(
              isHexagon: true,
              sizeLarge: true,
              background: activeColor,
              color: colorOnActive,
            ),
            top: padTop,
            pad: pad,
            bottom: padBottom,
            isFloating: true,
            onTap: (int index) {
              _currentIndex = index;
              active = true;
              widget.onItemTapped!(_tabItems().elementAt(_currentIndex).key);
            },
          );
        case 'creative':
          return BottomBarCreative(
            items: _tabItems(),
            backgroundColor: background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
            ),
            color: textColor,
            colorSelected: activeColor,
            enableShadow: enableShadow,
            indexSelected: active
                ? listKey.indexOf(widget.selected)
                : fixedActive!
                    ? fixedIndex
                    : listKey.indexOf(widget.selected),
            highlightStyle: HighlightStyle(
              background: activeColor,
              color: colorOnActive,
            ),
            top: padTop,
            pad: pad,
            bottom: padBottom,
            isFloating: false,
            onTap: (int index) {
              _currentIndex = index;
              active = true;
              widget.onItemTapped!(_tabItems().elementAt(index).key);
            },
          );
        case 'creative_hexagon':
          return BottomBarCreative(
            items: _tabItems(),
            backgroundColor: background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
            ),
            color: textColor,
            colorSelected: activeColor,
            enableShadow: enableShadow,
            indexSelected: active
                ? listKey.indexOf(widget.selected)
                : fixedActive!
                    ? fixedIndex
                    : listKey.indexOf(widget.selected),
            highlightStyle: HighlightStyle(
              isHexagon: true,
              sizeLarge: true,
              background: activeColor,
              color: colorOnActive,
            ),
            top: padTop,
            pad: pad,
            bottom: padBottom,
            isFloating: false,
            onTap: (int index) {
              _currentIndex = index;
              active = true;
              widget.onItemTapped!(_tabItems().elementAt(_currentIndex).key);
            },
          );
        case 'fancy':
          return BottomBarInspiredFancy(
            items: _tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: activeColor,
            top: padTop,
            bottom: padBottom,
            pad: pad,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
            ),
            indexSelected: active
                ? listKey.indexOf(widget.selected)
                : fixedActive!
                    ? fixedIndex
                    : listKey.indexOf(widget.selected),
            styleIconFooter: StyleIconFooter.dot,
            animated: animated!,
            enableShadow: enableShadow,
            onTap: (int index) {
              _currentIndex = index;
              active = true;
              widget.onItemTapped!(_tabItems().elementAt(_currentIndex).key);
            },
          );
        case 'fancy_border':
          return BottomBarInspiredFancy(
            items: _tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: activeColor,
            top: padTop,
            bottom: padBottom,
            pad: pad,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
            ),
            indexSelected: active
                ? listKey.indexOf(widget.selected)
                : fixedActive!
                    ? fixedIndex
                    : listKey.indexOf(widget.selected),
            styleIconFooter: StyleIconFooter.divider,
            animated: animated!,
            enableShadow: enableShadow,
            onTap: (int index) {
              _currentIndex = index;
              active = true;
              widget.onItemTapped!(_tabItems().elementAt(_currentIndex).key);
            },
          );
        case 'floating':
          return Container(
            padding: const EdgeInsets.only(bottom: 30, left: 32, right: 32),
            child: BottomBarFloating(
              items: _tabItems(),
              backgroundColor: background,
              color: textColor,
              colorSelected: activeColor,
              indexSelected: active
                  ? listKey.indexOf(widget.selected)
                  : fixedActive!
                      ? fixedIndex
                      : listKey.indexOf(widget.selected),
              animated: animated!,
              borderRadius: BorderRadius.circular(radius),
              top: padTop,
              bottom: padBottom,
              pad: pad,
              enableShadow: enableShadow,
              onTap: (int index) {
                _currentIndex = index;
                active = true;
                widget.onItemTapped!(_tabItems().elementAt(_currentIndex).key);
              },
            ),
          );
        case 'default_bg':
          return BottomBarBackground(
            items: _tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: colorOnActive,
            indexSelected: active
                ? listKey.indexOf(widget.selected)
                : fixedActive!
                    ? fixedIndex
                    : listKey.indexOf(widget.selected),
            backgroundSelected: activeColor,
            paddingVertical: 25,
            animated: animated!,
            top: padTop,
            pad: pad,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
            ),
            bottom: padBottom,
            onTap: (int index) {
              _currentIndex = index;
              active = true;
              widget.onItemTapped!(_tabItems().elementAt(_currentIndex).key);
            },
          );
        default:
          return BottomBarDefault(
            items: _tabItems(),
            backgroundColor: background,
            color: textColor,
            colorSelected: activeColor,
            animated: animated!,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
            ),
            enableShadow: enableShadow,
            indexSelected: active
                ? listKey.indexOf(widget.selected)
                : fixedActive!
                    ? fixedIndex
                    : listKey.indexOf(widget.selected),
            top: padTop,
            bottom: padBottom,
            pad: pad,
            onTap: (int index) {
              _currentIndex = index;
              active = true;
              widget.onItemTapped!(_tabItems().elementAt(_currentIndex).key);
            },
          );
      }
    }

    return styleBottomBar();
  }
}
