import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

String _basicAuth = 'Basic ' + base64Encode(utf8.encode('dina:dina12345'));

Map<String, String> myheaders = {'authorization': _basicAuth};

class Crud {
  getRequest(String Url) async {
    try {
      var response = await http.get(Uri.parse(Url));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response
            .body); //response body mnekhdo bi json(since mnkun aamlna encode lal php), so now badna naamol decode lal json la dart
        return responsebody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch $e");
    }
  }

  postRequest(String Url, Map data) async {
    try {
      var response =
          await http.post(Uri.parse(Url), body: data, headers: myheaders);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response
            .body); //response body mnekhdo bi json(since mnkun aamlna encode lal php), so now badna naamol decode lal json la dart
        return responsebody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch $e");
    }
  }

  postRequestWithFiles(String Url, Map data, File file) async {
    var request = http.MultipartRequest("POST", Uri.parse(Url));
    var length = await file.length();
    var stream = http.ByteStream(file.openRead());
    var multipartfile = http.MultipartFile(
      "file", //it should be the same name as the requestname
      stream,
      length,
      filename: basename(file.path),
    );
    request.headers.addAll(myheaders);
    request.files.add(multipartfile);
    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });
    var myrequest = await request.send();
    var response = await http.Response.fromStream(myrequest);
    if (myrequest.statusCode == 200) {
      var responseBody = response.body;
      return jsonDecode(responseBody);
    } else {
      throw Exception('Failed to post data: ${response.statusCode}');
    }
  }
}
