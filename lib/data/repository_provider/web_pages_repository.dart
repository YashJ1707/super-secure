import 'package:super_secure/data/models/data_model.dart';
import 'package:super_secure/data/repositories/api.dart';

class WebPagesRepository {
  Future<List<University>> getWebPageModelFromRawData() async {
    String rawWebPageData = await API.getRawUniversitiesData();
    final webPageModelData = universitiesFromJson(rawWebPageData);
    return webPageModelData;
  }
}
