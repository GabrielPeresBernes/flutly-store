import 'package:equatable/equatable.dart';

import '../../../../core/router/router.dart';
import '../../../../shared/utils/json_parser.dart';

class CatalogRouteParams extends CoreRouteParams with EquatableMixin {
  const CatalogRouteParams({required this.term});

  @override
  factory CatalogRouteParams.fromJson(Map<String, dynamic> data) {
    return CatalogRouteParams(
      term: JsonParser.parseString(data['term']),
    );
  }

  final String term;

  @override
  Map<String, dynamic> toJson() => {'term': term};

  @override
  List<Object?> get props => [term];
}
