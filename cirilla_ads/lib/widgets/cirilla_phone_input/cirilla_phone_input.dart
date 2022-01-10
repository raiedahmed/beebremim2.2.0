import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import 'countries.dart';
import 'phone_number.dart';

const String defaultCountryCode = 'US';

enum CirillaPhoneInputType { enable, disable, error }

class CirillaPhoneInput extends StatefulWidget {
  final String? initialCountryCode;
  final String? initialValue;
  final TextInputType keyboardType;
  final bool autoValidate;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final bool autofocus;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final ValueChanged<PhoneNumber>? onChanged;
  final FormFieldSetter<PhoneNumber>? onSaved;
  final void Function(PhoneNumber)? onSubmitted;
  final String? searchText;

  const CirillaPhoneInput({
    Key? key,
    this.initialCountryCode,
    this.initialValue,
    this.keyboardType = TextInputType.phone,
    this.autoValidate = true,
    this.validator,
    this.enabled = true,
    this.autofocus = false,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSaved,
    this.onSubmitted,
    this.textInputAction = TextInputAction.next,
    this.searchText,
  }) : super(key: key);

  @override
  _CirillaPhoneInputState createState() => _CirillaPhoneInputState();
}

class _CirillaPhoneInputState extends State<CirillaPhoneInput> {
  final GlobalKey _keyContainer = GlobalKey();
  double widthContainer = 80;

  Map<String, String>? _selectedCountry;
  List<Map<String, String>?> filteredCountries = countries;
  FormFieldValidator<String>? validator;
  FocusNode? _focusNode;

  CirillaPhoneInputType type = CirillaPhoneInputType.enable;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback(_getSizes);
    String initialCountryCode = widget.initialCountryCode ?? defaultCountryCode;
    Map<String, String>? init = countries.firstWhere((item) => item!['code'] == 'US');
    _selectedCountry = countries.firstWhere((item) => item!['code']!.toUpperCase() == initialCountryCode.toUpperCase(),
        orElse: () => init);
    validator =
        widget.autoValidate ? ((value) => value!.length != 10 ? 'Invalid Mobile Number' : null) : widget.validator;
    if (!widget.enabled) {
      type = CirillaPhoneInputType.disable;
    }
    _focusNode = widget.focusNode is FocusNode ? widget.focusNode : FocusNode();
    super.initState();
  }

  _getSizes(_) {
    final RenderBox renderBoxContainer = _keyContainer.currentContext!.findRenderObject() as RenderBox;
    final size = renderBoxContainer.size;
    setState(() {
      widthContainer = size.width + 16;
    });
  }

  Color colorLine(ThemeData theme) {
    if (_focusNode!.hasFocus && (type != CirillaPhoneInputType.error && type != CirillaPhoneInputType.disable)) {
      return theme.primaryColor;
    }
    switch (type) {
      case CirillaPhoneInputType.disable:
        return theme.disabledColor.withOpacity(0.2);
      case CirillaPhoneInputType.error:
        return theme.errorColor;
      default:
        return theme.dividerColor;
    }
  }

  void onFieldSubmitted(String value) {
    CirillaPhoneInputType newType = !widget.enabled
        ? CirillaPhoneInputType.disable
        : type == CirillaPhoneInputType.error
            ? CirillaPhoneInputType.error
            : CirillaPhoneInputType.enable;
    setState(() {
      type = newType;
    });
    if (widget.onSubmitted != null) {
      PhoneNumber data = PhoneNumber(
        countryISOCode: _selectedCountry!['code'],
        countryCode: _selectedCountry!['dial_code'],
        number: value,
      );
      widget.onSubmitted!(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color colorBorderCountry = colorLine(theme);
    double widthLine = _focusNode!.hasFocus ? 2 : 1;
    return Stack(
      children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: _selectedCountry!['dial_code'],
            prefixIcon: Container(
              width: widthContainer,
            ),
            border: const OutlineInputBorder(borderSide: BorderSide(width: 1)),
          ),
          initialValue: widget.initialValue,
          keyboardType: widget.keyboardType,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          controller: widget.controller,
          focusNode: _focusNode,
          textAlignVertical: TextAlignVertical.center,
          onTap: () {
            FocusScope.of(context).requestFocus(_focusNode);
          },
          validator: (String? value) {
            String? resultValidator = validator!(value);
            setState(() {
              type = resultValidator != null ? CirillaPhoneInputType.error : CirillaPhoneInputType.enable;
            });
            return resultValidator;
          },
          onFieldSubmitted: onFieldSubmitted,
          onSaved: (value) {
            if (widget.onSaved != null) {
              widget.onSaved!(
                PhoneNumber(
                  countryISOCode: _selectedCountry!['code'],
                  countryCode: _selectedCountry!['dial_code'],
                  number: value,
                ),
              );
            }
          },
          onChanged: (value) {
            if (value.startsWith("+") && value.length > 2 && value.length < 5) {
              setState(() {
                _selectedCountry = countries.firstWhere((item) => item!['dial_code']!.startsWith(value),
                    orElse: () => _selectedCountry);
              });
            }

            if (widget.onChanged != null) {
              widget.onChanged!(
                PhoneNumber(
                  countryISOCode: _selectedCountry!['code'],
                  countryCode: _selectedCountry!['dial_code'],
                  number: value,
                ),
              );
            }
          },
          textInputAction: widget.textInputAction,
        ),
        PositionedDirectional(
          top: 0,
          start: 0,
          child: InkWell(
            onTap: () => _changeCountry(),
            child: Container(
              key: _keyContainer,
              height: 48,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: itemPaddingMedium, right: itemPadding),
              decoration: BoxDecoration(
                border: BorderDirectional(
                  end: BorderSide(width: widthLine, color: colorBorderCountry),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    _selectedCountry!['flag']!,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  const Icon(FeatherIcons.chevronDown, size: 16)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _changeCountry() async {
    filteredCountries = countries;

    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        ThemeData theme = Theme.of(context);
        TranslateType translate = AppLocalizations.of(context)!.translate;

        InputBorder border = OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: theme.dividerColor),
          borderRadius: BorderRadius.circular(24),
        );
        return StatefulBuilder(
          builder: (ctx, setState) => Dialog(
            child: Container(
              padding: paddingDefault,
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: widget.searchText ?? translate('label_search_phone')!,
                      border: border,
                      enabledBorder: border,
                      focusedErrorBorder: border,
                      focusedBorder: border,
                      errorBorder: border,
                      disabledBorder: border,
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredCountries = countries
                            .where((country) => country!['name']!.toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredCountries.length,
                      itemBuilder: (ctx, index) => Column(
                        children: <Widget>[
                          ListTile(
                            leading: Text(
                              filteredCountries[index]!['flag']!,
                              style: const TextStyle(fontSize: 30),
                            ),
                            title: Text(
                              filteredCountries[index]!['name']!,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: Text(
                              filteredCountries[index]!['dial_code']!,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              _selectedCountry = filteredCountries[index];
                              Navigator.of(context).pop();
                            },
                          ),
                          const Divider(thickness: 1),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    setState(() {});
  }
}
