import 'package:catfact/src/config/http/api_client.dart';
import 'package:flutter/material.dart';

//* it won't be null; and will be initialized before use 
late BuildContext gContext;


ApiClient api = ApiClient.init();

const int factsPerPage = 20;