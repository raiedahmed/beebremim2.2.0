import 'package:cirilla/constants/app.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LanguageScreen extends StatefulWidget {
  final SettingStore? store;

  const LanguageScreen({
    Key? key,
    this.store,
  }) : super(key: key);

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late String _language;

  @override
  void initState() {
    _language = widget.store?.locale ?? defaultLanguage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Language> languages = widget.store?.supportedLanguages ?? [];

    return Theme(
      data: theme.copyWith(
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 48,
          margin: paddingHorizontal.add(paddingVerticalMedium),
          child: ElevatedButton(
            onPressed: () {
              if (_language != widget.store?.locale) {
                widget.store?.changeLanguage(_language);
              }

              widget.store?.closeSelectLanguage();
            },
            child: const Text('Save'),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: paddingHorizontal.copyWith(top: 60, bottom: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.only(end: 25),
                  child: Icon(
                    FontAwesomeIcons.language,
                    size: 76,
                    color: theme.primaryColor,
                    textDirection: TextDirection.ltr,
                  ),
                ),
                const SizedBox(height: 24),
                Text('Select Language', style: theme.textTheme.subtitle1),
                if (languages.isNotEmpty) ...[
                  const SizedBox(height: 26),
                  Container(
                    padding: paddingHorizontal,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(itemPaddingMedium),
                      boxShadow: initBoxShadow,
                    ),
                    child: Column(
                      children: List.generate(languages.length, (index) {
                        Language lang = languages[index];
                        bool isSelected = lang.locale == _language;
                        return CirillaTile(
                          title: Text(
                            lang.language!,
                            style: theme.textTheme.subtitle2
                                ?.copyWith(color: isSelected ? theme.primaryColor : theme.textTheme.caption!.color),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  FeatherIcons.check,
                                  size: 16,
                                  color: theme.primaryColor,
                                )
                              : null,
                          isChevron: false,
                          isDivider: index < 3,
                          onTap: () {
                            if (!isSelected) {
                              setState(() {
                                _language = lang.locale!;
                              });
                            }
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
