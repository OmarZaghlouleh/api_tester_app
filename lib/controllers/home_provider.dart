import 'dart:developer';

import 'package:api_tester_app/classes/response_class.dart';
import 'package:api_tester_app/enums/http_types.dart';
import 'package:api_tester_app/enums/request_types.dart';
import 'package:api_tester_app/functions/delete.dart';
import 'package:api_tester_app/functions/get.dart';
import 'package:api_tester_app/functions/post.dart';
import 'package:api_tester_app/functions/put.dart';
import 'package:api_tester_app/screens/response_screen.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../classes/debouncer.dart';
import '../enums/data_type.dart';

class HomeProvider with ChangeNotifier {
  HttpTypes _httpType = HttpTypes.values.first;
  String _ip = "";
  String _endpoint = "";
  RequestTypes _method = RequestTypes.get;
  Map<String, String> _header = {};
  final Map<TextEditingController, TextEditingController> _headerControllers =
      {};

  Map<String, dynamic> _body = {};
  final Map<MapEntry<TextEditingController, TextEditingController>, DataType>
      _bodyControllers = {};

  bool _overallBodyStatus = true;
  bool _overallUrlStatus = false;
  String _url = "";
  bool _isLoading = false;

  void toggleIsLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void setUrl() {
    _url = getIP.isNotEmpty
        ? "${getHttpType.name}://${"$getIP/"}$getEndpoint"
        : "${getHttpType.name}://$getIP";
    if (getIP.isNotEmpty &&
        getEndpoint.isNotEmpty &&
        getEndpoint.substring(0, 1) != '/' &&
        getIP.substring(getIP.length - 1, getIP.length) != '/' &&
        Uri.tryParse(_url) != null) {
      _overallUrlStatus = true;
    } else {
      _overallUrlStatus = false;
    }
  }

  void setOverallBodyStatus({required bool status}) {
    _overallBodyStatus = status;
    notifyListeners();
  }

  void setOverallUrlStatus({required bool status}) {
    _overallUrlStatus = status;
    notifyListeners();
  }

  void addHeaderController() {
    TextEditingController keyController = TextEditingController();
    TextEditingController valueController = TextEditingController();

    keyController.addListener(() {
      final _debouncer = Debouncer(milliseconds: 500);

      _debouncer.run(() {
        setHeader();
      });
    });

    valueController.addListener(() {
      final _debouncer = Debouncer(milliseconds: 500);

      _debouncer.run(() {
        setHeader();
      });
    });

    _headerControllers.putIfAbsent(keyController, () => valueController);
    notifyListeners();
  }

  void deleteHeaderController({required TextEditingController key}) {
    _headerControllers.remove(key);
    _header.remove(key.text.trim());
    notifyListeners();
  }

  void addBodyController({required BuildContext context}) {
    TextEditingController keyController = TextEditingController();
    TextEditingController valueController = TextEditingController();

    keyController.addListener(() {
      final _debouncer = Debouncer(milliseconds: 1000);

      setBody(context: context);
    });

    valueController.addListener(() {
      final _debouncer = Debouncer(milliseconds: 1000);

      setBody(context: context);
    });

    _bodyControllers.putIfAbsent(
        MapEntry(keyController, valueController), () => DataType.string);
    notifyListeners();
  }

  void deleteBodyController(
      {required MapEntry<TextEditingController, TextEditingController> key}) {
    _bodyControllers.remove(key);
    _body.remove(key.key.text.trim());
    notifyListeners();
  }

  void setHeader() {
    Map<String, String> newHeader = {};
    for (var e in _headerControllers.entries) {
      String key = e.key.text.trim();
      String value = e.value.text.trim();
      newHeader.putIfAbsent(key, () => value);
    }
    _header = newHeader;
    notifyListeners();
  }

  void updateBodyControllerDataType(
      {required DataType dataType,
      required BuildContext context,
      required MapEntry<TextEditingController, TextEditingController> key}) {
    _bodyControllers.update(key, (value) => dataType);
    setBody(context: context);
    //notifyListeners();
  }

  void setBody({required BuildContext context}) {
    Map<String, dynamic> newBody = {};
    for (var e in _bodyControllers.entries) {
      MapEntry<TextEditingController, TextEditingController> controllers =
          e.key;
      String key = controllers.key.text.trim();
      String value = controllers.value.text.trim();
      if (key.isNotEmpty && value.isNotEmpty) {
        try {
          switch (e.value) {
            case DataType.int:
              newBody.putIfAbsent(key, () => int.parse(value));
              break;
            case DataType.double:
              newBody.putIfAbsent(key, () => double.parse(value));
              break;
            case DataType.string:
              newBody.putIfAbsent(key, () => value.toString());
              break;
            case DataType.list:
              newBody.putIfAbsent(key, () => value.split(','));
              break;
          }
          setOverallBodyStatus(status: true);
        } catch (error) {
          setOverallBodyStatus(status: false);
        }
      }
    }
    _body = newBody;
    notifyListeners();
  }

  void setMethod({required RequestTypes method}) {
    _method = method;
    notifyListeners();
  }

  void setHttpType({required HttpTypes type}) {
    _httpType = type;
    setUrl();
    notifyListeners();
  }

  void setIP({required String ip}) {
    _ip = ip;
    setUrl();
    notifyListeners();
  }

  void setEndpoint({required String endpoint}) {
    _endpoint = endpoint;
    setUrl();

    notifyListeners();
  }

  Future<Either<bool, APIResponse>> test(
      {required BuildContext context}) async {
    APIResponse response;
    toggleIsLoading();

    if (getOverAllBodyStatus == false) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid url")));
      toggleIsLoading();

      return const Left(false);
    } else if (getOverAllBodyStatus == false) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid body")));
      toggleIsLoading();

      return const Left(false);
    }

    switch (getMethod) {
      case RequestTypes.get:
        response = await getAPIMethod(url: getUrl, headers: getHeader);
        break;
      case RequestTypes.post:
        response =
            await postAPIMethod(url: getUrl, headers: getHeader, body: getBody);
        break;
      case RequestTypes.put:
        response =
            await putAPIMethod(url: getUrl, headers: getHeader, body: getBody);
        break;
      case RequestTypes.delete:
        response = await deleteAPIMethod(
            url: getUrl, headers: getHeader, body: getBody);
        break;
    }
    toggleIsLoading();
    return Right(response);
  }

  HttpTypes get getHttpType => _httpType;
  String get getIP => _ip;
  String get getEndpoint => _endpoint;
  RequestTypes get getMethod => _method;
  Map<String, String> get getHeader => _header;
  Map<TextEditingController, TextEditingController> get getHeaderControllers =>
      _headerControllers;

  Map<String, dynamic> get getBody => _body;
  Map<MapEntry<TextEditingController, TextEditingController>, DataType>
      get getBodyControllers => _bodyControllers;
  bool get getOverAllBodyStatus => _overallBodyStatus;
  bool get getOverAllUrlStatus => _overallUrlStatus;
  String get getUrl => _url;
  bool get getIsLoading => _isLoading;
}
