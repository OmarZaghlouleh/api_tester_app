import 'dart:developer';

import 'package:api_tester_app/enums/http_types.dart';
import 'package:api_tester_app/enums/request_types.dart';
import 'package:api_tester_app/extensions/map_print_extension.dart';
import 'package:flutter/material.dart';

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
      required MapEntry<TextEditingController, TextEditingController> key}) {
    _bodyControllers.update(key, (value) => dataType);
    notifyListeners();
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
              newBody.putIfAbsent(key, () => value as List);
              break;
          }
        } catch (error) {
          Future.delayed(const Duration(seconds: 1), () {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "$value is not a ${e.value.name}",
                ),
              ),
            );
          });
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
    notifyListeners();
  }

  void setIP({required String ip}) {
    _ip = ip;
    notifyListeners();
  }

  void setEndpoint({required String endpoint}) {
    _endpoint = endpoint;
    notifyListeners();
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
}
