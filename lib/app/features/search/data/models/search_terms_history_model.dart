import '../../../../core/local_storage/local_storage.dart';

class SearchTermsHistoryModel with JsonSerializableMixin {
  SearchTermsHistoryModel({required this.terms});

  factory SearchTermsHistoryModel.fromJson(Map<String, dynamic> json) {
    final termsFromJson =
        (json['terms'] as List<dynamic>?)
            ?.map((term) => term as String)
            .toList() ??
        [];
    return SearchTermsHistoryModel(terms: termsFromJson);
  }

  final List<String> terms;

  @override
  Map<String, dynamic> toJson() {
    return {
      'terms': terms,
    };
  }
}
