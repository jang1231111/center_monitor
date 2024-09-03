import 'package:center_monitor/models/a10_model.dart';
import 'package:center_monitor/models/log_data_model.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_client/mysql_client.dart';

class ApiServices {
  final http.Client httpClient;

  ApiServices({required this.httpClient});

  Future<List<A10>> selectCenterList() async {
    final conn = await MySQLConnection.createConnection(
      host: 'new-geo.ctx65l43l4tv.ap-northeast-2.rds.amazonaws.com',
      port: 3306,
      userName: 'optilo',
      password: 'optilo123',
      databaseName: 'GEO_3PL',
    );
    await conn.connect();

    var result = await conn.execute(
        "SELECT * FROM (SELECT DISTINCT a.de_number, a.center_sn, a.de_name, TRUNCATE(b.temp, 1) AS temp, TRUNCATE(b.hum, 1) AS hum, b.battery, a.de_location, c.temp_low, c.temp_high, c.hum_low, c.hum_high, DATE_FORMAT(b.datetime, '%Y-%m-%d %H:%i') AS `datetime`, DATE_FORMAT(a.start_time, '%Y-%m-%d %H:%i') AS start_time, DATE_FORMAT(a.end_time, '%Y-%m-%d %H:%i') AS end_time, b.position_x, b.position_y FROM CENTER_HISTORY a LEFT JOIN CENTER_DEVICE b ON a.de_number = b.de_number AND a.record_date = DATE(b.datetime) AND b.`status` = 1 LEFT JOIN GEO.INFO_LIMIT c ON b.de_location = c.de_location WHERE a.center_sn = 1501 AND a.status = 1 AND a.record_date > DATE_SUB(CURDATE(), INTERVAL 2 MONTH) ORDER BY b.datetime DESC , a.record_date DESC) A GROUP BY A.de_number , A.center_sn , A.de_name ORDER BY A.de_name");

    final List<A10> deviceList = [];
    A10 a10;
    for (final row in result.rows) {
      print(row.assoc());

      a10 = A10.fromJson(row.assoc());
      deviceList.add(a10);
    }

    if (deviceList.isEmpty) {
      // throw WeatherException('Cannot get the location of $city');
    } else {
      // print(deviceList);
    }

    conn.close();

    return deviceList;
  }

  Future<List<LogData>> selectCenterData(A10 device) async {
    final conn = await MySQLConnection.createConnection(
      host: 'new-geo.ctx65l43l4tv.ap-northeast-2.rds.amazonaws.com',
      port: 3306,
      userName: 'optilo',
      password: 'optilo123',
      databaseName: 'GEO_3PL',
    );

    await conn.connect();

    var result = await conn.execute(
        "SELECT DISTINCT b.de_number, TRUNCATE(a.temp, 1) AS temp, TRUNCATE(a.hum, 1) AS hum, DATE_FORMAT(a.datetime, '%Y-%m-%d %H:%i') AS datetime, c.temp_high, c.temp_low, c.hum_high, c.hum_low FROM GEO.SENSOR_C a LEFT JOIN CENTER_HISTORY b ON a.de_number = b.de_number LEFT JOIN GEO.INFO_LIMIT c ON b.de_location = c.de_location WHERE b.de_number = '${device.deNumber}' AND b.`status` = 1 AND b.record_date BETWEEN DATE('${device.startTime}') AND DATE('${device.endTime}') AND a.datetime BETWEEN '${device.startTime}' AND '${device.endTime}' AND a.datetime BETWEEN b.start_time AND b.end_time GROUP BY b.seq , YEAR(a.datetime) , MONTH(a.datetime) , DAY(a.datetime) , HOUR(a.datetime) , FLOOR(MINUTE(a.datetime) / 10) * 10 ORDER BY b.seq , a.datetime");

    final List<LogData> logDatas = [];
    LogData logData;
    for (final row in result.rows) {
      // print(row.assoc());

      logData = LogData.fromJson(row.assoc());
      logDatas.add(logData);
    }

    if (logDatas.isEmpty) {
      // throw WeatherException('Cannot get the location of $city');
    } else {
      // print(logDatas);
    }

    conn.close();

    return logDatas;
  }

  // Future<Centerinfo> getCenterInfo(String phoneNumber) async {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   final Map<String, dynamic> response = new Map<String, dynamic>();
  //   final Map<String, dynamic> common = new Map<String, dynamic>();

  //   common['managerPn'] = phoneNumber;
  //   response["common"] = common;
  //   data["response"] = response;

  //   var client = http.Client();
  //   var uri = Uri.parse(kLoginUri);

  //   try {
  //     final http.Response response = await client.post(uri,
  //         headers: {"Content-Type": "application/json"},
  //         body: jsonEncode(data));

  //     if (response.statusCode != 200) {
  //       throw Exception(httpErrorHandler(response));
  //     }

  //     final responseBody = json.decode(response.body);

  //     if (responseBody.toString() ==
  //         '{msg: No Data In MANAGER_INFO, notice: []}') {
  //       throw Exception('전화번호를 확인해 주세요');
  //     }

  //     // print(responseBody.toString());
  //     final centerInfo = Centerinfo.fromJson(responseBody);

  //     return centerInfo;
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