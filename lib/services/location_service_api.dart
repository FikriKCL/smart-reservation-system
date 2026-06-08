import 'dart:convert';

import '../models/franchise_location.dart';
import 'api_client.dart';

class LocationApiService {
  static Future<List<FranchiseLocation>>
      fetchLocations() async {
    final response =
        await ApiClient.get('/locations');

    final data =
        jsonDecode(response.body) as List;

    return data
        .map(
          (e) => FranchiseLocation.fromJson(e),
        )
        .toList();
  }
}