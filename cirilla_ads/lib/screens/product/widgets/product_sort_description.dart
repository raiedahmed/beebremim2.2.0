import 'package:cirilla/models/product/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;

class ProductSortDescription extends StatelessWidget {
  final Product? product;

  const ProductSortDescription({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: product!.shortDescription ?? '',
      onLinkTap: (
        String? url,
        RenderContext context,
        Map<String, String> attributes,
        dom.Element? element,
      ) {
        if (url is String && Uri.parse(url).isAbsolute) {
          launch(url);
        }
      },
    );
  }
}
