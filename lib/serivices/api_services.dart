import 'dart:convert';
import 'package:center_monitor/constants/constants.dart';
import 'package:center_monitor/models/center/center_list_info.dart';
import 'package:center_monitor/models/device/device_list_info.dart';
import 'package:center_monitor/models/device/device_logdata_info.dart';
import 'package:center_monitor/serivices/http_error_handler.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final http.Client httpClient;

  ApiServices({required this.httpClient});

  Future<String> intergrationLogin(String ID, String Password) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['userId'] = ID;
    data["password"] = Password;

    var client = http.Client();
    var uri = Uri.parse('$khttpUri$kIntergrationLoginUri');
    try {
      final http.Response response = await client.post(uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data));

      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }

      final responseBody = response.body;
      final center = responseBody.toString();

      // if (strResponse == '{msg: No Data In MANAGER_INFO, notice: []}') {
      //   throw Exception('ID 및 Password를 학인해 주세요');
      // }

      return center;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<String> login(String ID, String Password, String center) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['userId'] = ID;
    data["password"] = Password;

    var client = http.Client();
    var uri = Uri.parse('$khttpUri$center$kLoginUri');

    // print('Login Uri ${uri}');

    try {
      final http.Response response = await client.post(uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data));

      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }

      final responseBody = json.decode(response.body);
      final token = responseBody['token'];

      // if (strResponse == '{msg: No Data In MANAGER_INFO, notice: []}') {
      //   throw Exception('ID 및 Password를 학인해 주세요');
      // }

      // print(responseBody.toString());

      return token;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CenterInfo>> getCenterList(String token, String center) async {
    var client = http.Client();
    var uri = Uri.parse('$khttpUri$center$kcenterListUri');

    // print('centerList Uri $uri');

    try {
      final http.Response response = await client.post(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }

      final utfResponseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> responseBody = json.decode(utfResponseBody);

      // print('getCenterList ${responseBody.toString()}');

      final centerList =
          responseBody.map((i) => CenterInfo.fromJson(i)).toList();
      return centerList;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<A10>> getDeviceList(
    int id,
    String company,
    String token,
  ) async {
    var client = http.Client();
    var uri = Uri.parse('$khttpUri$company$kdeviceListUri$id');

    // print('getDeviceList Uri : ${uri.toString()}');

    try {
      final http.Response response = await client.post(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }

      final utfResponseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> responseBody = json.decode(utfResponseBody);

      // print('getDeviceList $responseBody');

      final deviceList = responseBody.map((i) => A10.fromJsonLocal(i)).toList();
      return deviceList;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LogData>> getDeviceLogData(
    A10 selectedDevice,
    String company,
    String token,
  ) async {
    var client = http.Client();
    var uri = Uri.parse('$khttpUri$company$kdeviceDataUri');

    // print('getDeviceLogData Uri : ${uri.toString()}');

    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = selectedDevice.id;
    data["deNumber"] = selectedDevice.deNumber;
    data["startTime"] =
        selectedDevice.startTime.toString().replaceAll(" ", "T");
    data["endTime"] = selectedDevice.timeStamp.toString().replaceAll(" ", "T");
    ;
    data["dataType"] = "C";
    data["timezone"] = "string";
    data["timeBased"] = true;

    print(' data ${data}');

    try {
      final http.Response response = await client.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data));

      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }

      final utfResponseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> responseBody = json.decode(utfResponseBody);

      // print('getDeviceLogData $responseBody');

      final logDatas =
          responseBody.map((i) => LogData.fromJsonLocal(i)).toList();
      return logDatas;
    } catch (e) {
      rethrow;
    }
  }
// {
//   "id": 0,
//   "deNumber": "string",
//   "startTime": "2024-10-05T11:17:44.957Z",
//   "endTime": "2024-10-05T11:17:44.957Z",
//   "dataType": "C",
//   "timezone": "string",
//   "timeBased": true
// }
  /// 인성 1501 , 보령 1601
  /// MNB 1101 , BCS 1301

  /// 인성
  // Future<List<A10>> selectInSungCenterList() async {
  //   final conn = await MySQLConnection.createConnection(
  //     host: 'new-geo.ctx65l43l4tv.ap-northeast-2.rds.amazonaws.com',
  //     port: 3306,
  //     userName: 'optilo',
  //     password: 'optilo123',
  //     databaseName: 'GEO_3PL',
  //   );
  //   await conn.connect();

  //   var result = await conn.execute(
  //       "SELECT * FROM (SELECT DISTINCT a.de_number, a.center_sn, a.de_name, TRUNCATE(b.temp, 1) AS temp, TRUNCATE(b.hum, 1) AS hum, b.battery, a.de_location, c.temp_low, c.temp_high, c.hum_low, c.hum_high, DATE_FORMAT(b.datetime, '%Y-%m-%d %H:%i') AS `datetime`, DATE_FORMAT(a.start_time, '%Y-%m-%d %H:%i') AS start_time, DATE_FORMAT(a.end_time, '%Y-%m-%d %H:%i') AS end_time, b.position_x, b.position_y FROM CENTER_HISTORY a LEFT JOIN CENTER_DEVICE b ON a.de_number = b.de_number AND a.record_date = DATE(b.datetime) AND b.`status` = 1 LEFT JOIN GEO.INFO_LIMIT c ON b.de_location = c.de_location WHERE a.center_sn = 1501 AND a.status = 1 AND a.record_date > DATE_SUB(CURDATE(), INTERVAL 2 MONTH) ORDER BY b.datetime DESC , a.record_date DESC) A GROUP BY A.de_number , A.center_sn , A.de_name ORDER BY A.de_name");

  //   final List<A10> deviceList = [];
  //   A10 a10;
  //   for (final row in result.rows) {
  //     // print(row.assoc());

  //     a10 = A10.fromJsonLocal(row.assoc());
  //     deviceList.add(a10);
  //   }

  //   if (deviceList.isEmpty) {
  //     // throw WeatherException('Cannot get the location of $city');
  //   } else {
  //     // print(deviceList);
  //   }

  //   conn.close();

  //   return deviceList;
  // }

  // /// 보령
  // Future<List<A10>> selectBrCenterList() async {
  //   final conn = await MySQLConnection.createConnection(
  //     host: 'new-geo.ctx65l43l4tv.ap-northeast-2.rds.amazonaws.com',
  //     port: 3306,
  //     userName: 'optilo',
  //     password: 'optilo123',
  //     databaseName: 'GEO_3PL',
  //   );
  //   await conn.connect();

  //   var result = await conn.execute(
  //       "SELECT * FROM (SELECT DISTINCT a.de_number, a.center_sn, a.de_name, TRUNCATE(b.temp, 1) AS temp, TRUNCATE(b.hum, 1) AS hum, b.battery, a.de_location, c.temp_low, c.temp_high, c.hum_low, c.hum_high, DATE_FORMAT(b.datetime, '%Y-%m-%d %H:%i') AS `datetime`, DATE_FORMAT(a.start_time, '%Y-%m-%d %H:%i') AS start_time, DATE_FORMAT(a.end_time, '%Y-%m-%d %H:%i') AS end_time, b.position_x, b.position_y FROM CENTER_HISTORY a LEFT JOIN CENTER_DEVICE b ON a.de_number = b.de_number AND a.record_date = DATE(b.datetime) AND b.`status` = 1 LEFT JOIN GEO.INFO_LIMIT c ON b.de_location = c.de_location WHERE a.center_sn = 1601 AND a.status = 1 AND a.record_date > DATE_SUB(CURDATE(), INTERVAL 2 MONTH) ORDER BY b.datetime DESC , a.record_date DESC) A GROUP BY A.de_number , A.center_sn , A.de_name ORDER BY A.de_name");

  //   final List<A10> deviceList = [];
  //   A10 a10;
  //   for (final row in result.rows) {
  //     // print(row.assoc());

  //     a10 = A10.fromJsonLocal(row.assoc());
  //     deviceList.add(a10);
  //   }

  //   if (deviceList.isEmpty) {
  //     // throw WeatherException('Cannot get the location of $city');
  //   } else {
  //     // print(deviceList);
  //   }

  //   conn.close();

  //   return deviceList;
  // }

  // /// MNB
  // Future<List<A10>> selectMnbCenterList() async {
  //   final conn = await MySQLConnection.createConnection(
  //     host: '175.126.77.180',
  //     port: 3306,
  //     userName: 'iot_platform',
  //     password: 'IotPlatform112!!@',
  //     databaseName: 'IOT_PLATFORM',
  //   );
  //   await conn.connect();

  //   var result = await conn.execute(
  //       "SELECT * FROM (SELECT DISTINCT a.de_number, a.center_sn, a.de_name, TRUNCATE(b.temp, 1) AS temp, TRUNCATE(b.hum, 1) AS hum, b.battery, a.de_location, c.temp_low, c.temp_high, c.hum_low, c.hum_high, DATE_FORMAT(b.datetime, '%Y-%m-%d %H:%i') AS `datetime`, DATE_FORMAT(a.start_time, '%Y-%m-%d %H:%i') AS start_time, DATE_FORMAT(a.end_time, '%Y-%m-%d %H:%i') AS end_time, b.position_x, b.position_y FROM CENTER_HISTORY a LEFT JOIN CENTER_DEVICE b ON a.de_number = b.de_number AND a.record_date = DATE(b.datetime) AND b.`status` = 1 LEFT JOIN LIMIT_INFO c ON b.de_location = c.de_location WHERE a.center_sn = 1101 AND a.status = 1 AND a.record_date = CURDATE()ORDER BY b.datetime DESC , a.record_date DESC) A GROUP BY A.de_number , A.center_sn , A.de_name ORDER BY A.de_name");

  //   final List<A10> deviceList = [];
  //   A10 a10;
  //   for (final row in result.rows) {
  //     print(row.assoc());

  //     a10 = A10.fromJsonUTC(row.assoc());
  //     deviceList.add(a10);
  //   }

  //   if (deviceList.isEmpty) {
  //     // throw WeatherException('Cannot get the location of $city');
  //   } else {
  //     // print(deviceList);
  //   }

  //   conn.close();

  //   return deviceList;
  // }

  // /// BCS
  // Future<List<A10>> selectBcsCenterList() async {
  //   final conn = await MySQLConnection.createConnection(
  //     host: '175.126.77.180',
  //     port: 3306,
  //     userName: 'iot_platform',
  //     password: 'IotPlatform112!!@',
  //     databaseName: 'IOT_PLATFORM',
  //   );
  //   await conn.connect();

  //   var result = await conn.execute(
  //       "SELECT * FROM (SELECT DISTINCT a.de_number, a.center_sn, a.de_name, TRUNCATE(b.temp, 1) AS temp, TRUNCATE(b.hum, 1) AS hum, b.battery, a.de_location, c.temp_low, c.temp_high, c.hum_low, c.hum_high, DATE_FORMAT(b.datetime, '%Y-%m-%d %H:%i') AS `datetime`, DATE_FORMAT(a.start_time, '%Y-%m-%d %H:%i') AS start_time, DATE_FORMAT(a.end_time, '%Y-%m-%d %H:%i') AS end_time, b.position_x, b.position_y FROM CENTER_HISTORY a LEFT JOIN CENTER_DEVICE b ON a.de_number = b.de_number AND a.record_date = DATE(b.datetime) AND b.`status` = 1 LEFT JOIN LIMIT_INFO c ON b.de_location = c.de_location WHERE a.center_sn = 1301 AND a.status = 1 AND a.record_date = CURDATE()ORDER BY b.datetime DESC , a.record_date DESC) A GROUP BY A.de_number , A.center_sn , A.de_name ORDER BY A.de_name");

  //   final List<A10> deviceList = [];
  //   A10 a10;
  //   for (final row in result.rows) {
  //     print(row.assoc());

  //     a10 = A10.fromJsonUTC(row.assoc());
  //     deviceList.add(a10);
  //   }

  //   if (deviceList.isEmpty) {
  //     // throw WeatherException('Cannot get the location of $city');
  //   } else {
  //     // print(deviceList);
  //   }

  //   conn.close();

  //   return deviceList;
  // }

  // Future<List<LogData>> selectInSungCenterData(A10 device) async {
  //   final conn = await MySQLConnection.createConnection(
  //     host: 'new-geo.ctx65l43l4tv.ap-northeast-2.rds.amazonaws.com',
  //     port: 3306,
  //     userName: 'optilo',
  //     password: 'optilo123',
  //     databaseName: 'GEO_3PL',
  //   );
  //   await conn.connect();

  //   var result = await conn.execute(
  //       "SELECT DISTINCT b.de_number, TRUNCATE(a.temp, 1) AS temp, TRUNCATE(a.hum, 1) AS hum, DATE_FORMAT(a.datetime, '%Y-%m-%d %H:%i') AS datetime, c.temp_high, c.temp_low, c.hum_high, c.hum_low FROM GEO.SENSOR_C a LEFT JOIN CENTER_HISTORY b ON a.de_number = b.de_number LEFT JOIN GEO.INFO_LIMIT c ON b.de_location = c.de_location WHERE b.de_number = '${device.deNumber}' AND b.`status` = 1 AND b.record_date BETWEEN DATE('${device.timeStamp}') AND DATE('${device.endTime}') AND a.datetime BETWEEN '${device.timeStamp}' AND '${device.endTime}' AND a.datetime BETWEEN b.start_time AND b.end_time GROUP BY b.seq , YEAR(a.datetime) , MONTH(a.datetime) , DAY(a.datetime) , HOUR(a.datetime) , FLOOR(MINUTE(a.datetime) / 10) * 10 ORDER BY b.seq , a.datetime");

  //   final List<LogData> logDatas = [];
  //   LogData logData;
  //   for (final row in result.rows) {
  //     // print(row.assoc());

  //     logData = LogData.fromJsonLocal(row.assoc());
  //     logDatas.add(logData);
  //   }

  //   if (logDatas.isEmpty) {
  //     // throw WeatherException('Cannot get the location of $city');
  //   } else {
  //     // print(logDatas);
  //   }

  //   conn.close();

  //   return logDatas;
  // }

  // Future<List<LogData>> selectMnbCenterData(A10 device) async {
  //   final conn = await MySQLConnection.createConnection(
  //     host: '175.126.77.180',
  //     port: 3306,
  //     userName: 'iot_platform',
  //     password: 'IotPlatform112!!@',
  //     databaseName: 'IOT_PLATFORM',
  //   );

  //   await conn.connect();

  //   var result = await conn.execute(
  //       "SELECT DISTINCT b.de_number, TRUNCATE(a.temp, 1) AS temp, TRUNCATE(a.hum, 1) AS hum, DATE_FORMAT(a.datetime, '%Y-%m-%d %H:%i') AS datetime, c.temp_high, c.temp_low, c.hum_high, c.hum_low FROM SENSOR_C a LEFT JOIN CENTER_HISTORY b ON a.de_number = b.de_number LEFT JOIN LIMIT_INFO c ON b.de_location = c.de_location WHERE b.de_number = '${device.deNumber}' AND b.`status` = 1 AND b.record_date BETWEEN DATE('${device.timeStamp.toUtc()}') AND DATE('${device.endTime.toUtc()}') AND a.datetime BETWEEN '${device.timeStamp.toUtc()}' AND '${device.endTime.toUtc()}' AND a.datetime BETWEEN b.start_time AND b.end_time GROUP BY b.seq , YEAR(a.datetime) , MONTH(a.datetime) , DAY(a.datetime) , HOUR(a.datetime) , FLOOR(MINUTE(a.datetime) / 10) * 10 ORDER BY b.seq , a.datetime");

  //   final List<LogData> logDatas = [];
  //   LogData logData;
  //   for (final row in result.rows) {
  //     // print(row.assoc());

  //     logData = LogData.fromJsonUTC(row.assoc());
  //     logDatas.add(logData);
  //   }

  //   if (logDatas.isEmpty) {
  //     // throw WeatherException('Cannot get the location of $city');
  //   } else {
  //     // print(logDatas);
  //   }

  //   conn.close();

  //   return logDatas;
  // }

  // Future<void> getCenterInfo(String phoneNumber) async {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   // final Map<String, dynamic> response = new Map<String, dynamic>();
  //   // final Map<String, dynamic> common = new Map<String, dynamic>();

  //   data['userId'] = 'admin';
  //   data["password"] = 'admin123';

  //   var client = http.Client();
  //   var uri = Uri.parse(kLoginUri);

  //   try {
  //     final http.Response response = await client.post(uri,
  //         headers: {"Content-Type": "application/json"},
  //         body: jsonEncode(data));

  //     /// 인터셉터 참고하면 더 편할 듯
  //     ///  원래 기본 헤더 authenti 머시기
  //     ///  baer ? + 토큰 넣기

  //     if (response.statusCode != 200) {
  //       throw Exception(httpErrorHandler(response));
  //     }

  //     final responseBody = json.decode(response.body);

  //     if (responseBody.toString() ==
  //         '{msg: No Data In MANAGER_INFO, notice: []}') {
  //       throw Exception('전화번호를 확인해 주세요');
  //     }

  //     print(responseBody.toString());
  //     // final centerInfo = Centerinfo.fromJson(responseBody);

  //     // return centerInfo;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<List<A10>> getDeviceList(Centerinfo centerInfo) async {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   final Map<String, dynamic> response = new Map<String, dynamic>();
  //   final Map<String, dynamic> common = new Map<String, dynamic>();

  //   common['managerPn'] = centerInfo.managerPn;
  //   response["common"] = common;
  //   data["response"] = response;

  //   var client = http.Client();
  //   var uri = Uri.parse(centerInfo.getDeviceListUri);

  //   try {
  //     final http.Response response = await client.post(uri,
  //         headers: {"Content-Type": "application/json"},
  //         body: jsonEncode(data));

  //     if (response.statusCode != 200) {
  //       throw Exception(httpErrorHandler(response));
  //     }

  //     // print(response.body.toString());
  //     final List<dynamic> responseBody = json.decode(response.body);

  //     if (responseBody.isEmpty) {
  //       // throw WeatherException('Cannot get the location of $city');
  //     }

  //     final deviceList = responseBody.map((i) => A10.fromJson(i)).toList();

  //     // print('Devicelist : $deviceList');
  //     return deviceList;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
