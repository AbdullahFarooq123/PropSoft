import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

class API {
  static Future<Response> getLoginResponse(
      {required String username, required String password}) async {
    return await post(Uri.parse('http://aareapi.futuresofts.co.uk/api/auth/login'),
        body: json.encode({
          "UserName": username,
          "Password": password,
        }),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
  }

  static Future<Response> getStatuses(String tokenId) async {
    return await get(
      Uri.parse('http://aareapi.futuresofts.co.uk/api/v1/status'),
      headers: {
        'authorization': 'Bearer $tokenId',
      },
    );
  }

  static Future<Response> getCommunications(
      String tokenId, String leadId) async {
    log(tokenId);
    print(leadId);
    return await get(
      Uri.parse(
          'http://aareapi.futuresofts.co.uk/api/v1/reports/Leadcommunications?Lid=$leadId'),
      headers: {
        'authorization': 'Bearer $tokenId',
      },
    );
  }

  static Future<Response> saveCommunications(
      String tokenId, Map<String, Object?> communication) async {
    return await post(
      Uri.parse('http://aareapi.futuresofts.co.uk/api/v1/Communications'),
      body: json.encode(communication),
      headers: {
        "authorization": "Bearer $tokenId",
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
  }

  static Future<Response> updateCommunications(
      String tokenId, Map<String, Object?> communication, String leadId) async {
    print('Updating');
    print(leadId);
    print(communication);
    return await put(
      Uri.parse('http://aareapi.futuresofts.co.uk/api/v1/Communications/$leadId'),
      body: json.encode(communication),
      headers: {
        "authorization": "Bearer $tokenId",
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
  }

  static Future<Response> getCommunicationInfo(
      String tokenId, String leadId) async {
    print(leadId);
    print(leadId);
    return await get(
      Uri.parse('http://aareapi.futuresofts.co.uk/api/v1/Communications/$leadId'),
      headers: {
        "authorization": "Bearer $tokenId",
      },
    );
  }

  static Future<Response> getMyLeads(String tokenId) async {
    return await post(
      Uri.parse('http://aareapi.futuresofts.co.uk/api/v1/reports/myleads'),
      headers: {
        "authorization": "Bearer $tokenId",
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: json.encode({
        "from": "2022-06-01T00:00:00",
        "till":
            DateTime.now().toString().replaceRange(10, 11, 'T').split('.')[0],
        "nonTransfered": false,
        "assigned": false,
        "filterType": 1,
        "dateFilterTypeID": 1,
        "userID": null,
        "statusIDs": [],
        "sourceIDs": [],
        "staffIDs": [],
        "projectIDs": [],
        "teamIDs": [],
        "useStatusIDs": false,
        "useSourceIDs": false,
        "useStaffIDs": false,
        "useProjectIDs": false,
        "useTeamIDs": false,
        "leadID": 0
      }),
    );
  }
}
