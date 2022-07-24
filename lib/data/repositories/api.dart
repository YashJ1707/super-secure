import 'package:http/http.dart' as http;

class API {
  static Future<String> getRawUniversitiesData() async {
    http.Response response = await http.get(Uri.parse(
        "http://universities.hipolabs.com/search?country=United+States"));
    return response.body;
  }
}
