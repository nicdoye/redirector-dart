/*
   Copyright 2012 Nicolas Doye
     
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/ 

library redirector;

import "dart:io";

// For the moment we can only serve http as far as I can tell.
// Of course you could be running this behind an https proxy :(

// There's no logging in this either. Fork me and fix it! :)

const PROTOCOL = "http";
const AFTER_PROTOCOL = "://";
const BEFORE_PORT = ":";
const PREFIX = "www.";
const HOST = "127.0.0.1";
const PORT = 8080;

void main() {
  startServer();
}

void startServer() {
  HttpServer server = new HttpServer();

  server.addRequestHandler((HttpRequest request) => true, requestReceivedHandler);

  server.listen(HOST, PORT);
}

void requestReceivedHandler(HttpRequest request, HttpResponse response) {
  String portString = (request.headers.port == 80) ? '' : BEFORE_PORT.concat(request.headers.port.toString()) ;
  StringBuffer sb = new StringBuffer();
  sb.addAll([PROTOCOL, AFTER_PROTOCOL, PREFIX, request.headers.host, portString, request.uri]) ;
  response.statusCode = HttpStatus.MOVED_TEMPORARILY;
  response.headers.set(HttpHeaders.LOCATION, sb.toString());
  response.outputStream.close();
}