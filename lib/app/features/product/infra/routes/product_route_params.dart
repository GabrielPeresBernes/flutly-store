import '../../../../core/router/router.dart';
import '../../../../shared/utils/json_parser.dart';

class ProductRouteParams extends CoreRouteParams {
  const ProductRouteParams({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.tag,
  });

  factory ProductRouteParams.fromJson(Map<String, dynamic> data) {
    return ProductRouteParams(
      id: JsonParser.parseInt(data['id']),
      title: JsonParser.parseString(data['title']),
      thumbnail: JsonParser.parseString(data['thumbnail']),
      tag: JsonParser.parseString(data['tag']),
    );
  }

  final int id;
  final String title;
  final String thumbnail;
  final String tag;

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'thumbnail': thumbnail,
    'tag': tag,
  };
}
