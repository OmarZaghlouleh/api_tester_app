import 'dart:developer';

import 'package:api_tester_app/classes/request_class.dart';
import 'package:api_tester_app/classes/response_class.dart';
import 'package:api_tester_app/enums/http_types.dart';
import 'package:api_tester_app/enums/request_types.dart';
import 'package:api_tester_app/functions/delete.dart';
import 'package:api_tester_app/functions/get.dart';
import 'package:api_tester_app/functions/post.dart';
import 'package:api_tester_app/functions/put.dart';
import 'package:api_tester_app/functions/storage_functions.dart';
import 'package:api_tester_app/functions/test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../enums/data_type.dart';

class HomeProvider with ChangeNotifier {
  HttpTypes _httpType = HttpTypes.values.first;
  String _ip = "";
  String _endpoint = "";
  //RequestTypes _method = RequestTypes.get;
  final Map<TextEditingController, TextEditingController> _headerControllers =
      {};
  final Map<MapEntry<TextEditingController, TextEditingController>, DataType>
      _bodyControllers = {};

  final Map<TextEditingController, TextEditingController>
      _parametersControllers = {};

  bool _overallBodyStatus = true;
  bool _overallUrlStatus = false;
  bool _isLoading = false;
  String _parameters = "";

  final APIRequest _apiRequest = APIRequest.empty();

  void toggleEncodedBody() {
    getRequestData.encodeBody = !getRequestData.encodeBody;
    notifyListeners();
  }

  void setParameters() {
    _parameters = "";
    String parameter = "";
    for (int i = 0; i < _parametersControllers.entries.length; i++) {
      final String key =
          _parametersControllers.entries.elementAt(i).key.text.trim();
      final String value =
          _parametersControllers.entries.elementAt(i).value.text.trim();

      parameter = "${key}=$value";
      if (i == 0) {
        parameter = "?$parameter";
      } else {
        parameter = "&$parameter";
      }
      if (key.isNotEmpty && value.isNotEmpty) _parameters += parameter;
    }
    log(getParameters);

    //notifyListeners();
  }

  void toggleIsLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void setUrl() {
    _apiRequest.url = getIP.isNotEmpty
        ? "${getHttpType.name}://${"$getIP/"}$getEndpoint"
        : "${getHttpType.name}://$getIP";
    setParameters();
    _apiRequest.url += getParameters;
    if (getIP.isNotEmpty &&
        getEndpoint.isNotEmpty &&
        getEndpoint.substring(0, 1) != '/' &&
        getIP.substring(getIP.length - 1, getIP.length) != '/' &&
        Uri.tryParse(_apiRequest.url) != null) {
      _overallUrlStatus = true;
    } else {
      _overallUrlStatus = false;
    }

    notifyListeners();
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
      setHeader();
    });

    valueController.addListener(() {
      setHeader();
    });

    _headerControllers.putIfAbsent(keyController, () => valueController);
    notifyListeners();
  }

  void addParametersController() {
    TextEditingController keyController = TextEditingController();
    TextEditingController valueController = TextEditingController();

    keyController.addListener(() {
      setUrl();
    });

    valueController.addListener(() {
      setUrl();
    });

    _parametersControllers.putIfAbsent(keyController, () => valueController);
    notifyListeners();
  }

  void deleteParametersController({required TextEditingController key}) {
    _parametersControllers.remove(key);
    _apiRequest.parameters.remove(key.text.trim());
    setUrl();
    // notifyListeners();
  }

  void deleteHeaderController({required TextEditingController key}) {
    _headerControllers.remove(key);
    _apiRequest.header.remove(key.text.trim());
    notifyListeners();
  }

  void addBodyController({required BuildContext context}) {
    TextEditingController keyController = TextEditingController();
    TextEditingController valueController = TextEditingController();

    keyController.addListener(() {
      setBody(context: context);
    });

    valueController.addListener(() {
      setBody(context: context);
    });

    _bodyControllers.putIfAbsent(
        MapEntry(keyController, valueController), () => DataType.string);
    notifyListeners();
  }

  void deleteBodyController(
      {required MapEntry<TextEditingController, TextEditingController> key}) {
    _bodyControllers.remove(key);
    _apiRequest.body.remove(key.key.text.trim());
    notifyListeners();
  }

  void setHeader() {
    Map<String, String> newHeader = {};
    for (var e in _headerControllers.entries) {
      String key = e.key.text.trim();
      String value = e.value.text.trim();
      newHeader.putIfAbsent(key, () => value);
    }
    _apiRequest.header = newHeader;
    notifyListeners();
  }

  void updateBodyControllerDataType(
      {required DataType dataType,
      required BuildContext context,
      required MapEntry<TextEditingController, TextEditingController> key}) {
    _bodyControllers.update(key, (value) => dataType);
    setBody(context: context);
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
              newBody.putIfAbsent(key, () => int.parse(value).toString());
              break;
            case DataType.double:
              newBody.putIfAbsent(key, () => double.parse(value).toString());
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
    _apiRequest.body = newBody;
    notifyListeners();
  }

  void setMethod({required RequestTypes method}) {
    _apiRequest.method = method;
    notifyListeners();
  }

  void setHttpType({required HttpTypes type}) {
    _httpType = type;
    setUrl();
  }

  void setIP({required String ip}) {
    _ip = ip;
    setUrl();
  }

  void setEndpoint({required String endpoint}) {
    _endpoint = endpoint;
    setUrl();
  }

  Future<Either<bool, APIResponse>> test(
      {required BuildContext context}) async {
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
    final response = await testAPI(request: getRequestData);

    toggleIsLoading();
    return Right(response);
  }

  HttpTypes get getHttpType => _httpType;
  String get getIP => _ip;
  String get getEndpoint => _endpoint;

  APIRequest get getRequestData => _apiRequest;
  Map<TextEditingController, TextEditingController> get getHeaderControllers =>
      _headerControllers;
  Map<TextEditingController, TextEditingController>
      get getParametersControllers => _parametersControllers;

  Map<MapEntry<TextEditingController, TextEditingController>, DataType>
      get getBodyControllers => _bodyControllers;
  bool get getOverAllBodyStatus => _overallBodyStatus;
  bool get getOverAllUrlStatus => _overallUrlStatus;
  bool get getIsLoading => _isLoading;
  String get getParameters => _parameters;
}
