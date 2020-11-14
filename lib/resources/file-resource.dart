import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as fileUtil;
import 'package:hda_driver/resources/misc/base-url.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:path_provider/path_provider.dart';

typedef void OnDownloadProgressCallback(int receivedBytes, int totalBytes);
typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);

class FileResource {
  static bool trustSelfSigned = true;

  static HttpClient getHttpClient() {
    HttpClient httpClient = new HttpClient()
      ..connectionTimeout = const Duration(seconds: 10)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);

    return httpClient;
  }

  String get url => "files";
  String get host => apiHost;
  String get baseUrl => apiBaseUrl;
  Identity identity = getIt<Identity>();

  Future<String> fileUpload(
      File file, OnUploadProgressCallback onUploadProgress) async {
    final fileStream = file.openRead();

    int totalByteLength = file.lengthSync();

    final httpClient = getHttpClient();

    final request = await httpClient.postUrl(Uri.http(host, baseUrl + url));

    request.headers
        .set(HttpHeaders.contentTypeHeader, ContentType.binary.subType);

    request.headers.add("filename", fileUtil.basename(file.path));
    request.headers.add(HttpHeaders.authorizationHeader, identity.getToken());

    request.contentLength = totalByteLength;

    int byteCount = 0;
    Stream<List<int>> streamUpload = fileStream.transform(
      new StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          byteCount += data.length;

          if (onUploadProgress != null) {
            onUploadProgress(byteCount, totalByteLength);
          }

          sink.add(data);
        },
        handleError: (error, stack, sink) {
          print(error.toString());
        },
        handleDone: (sink) {
          // UPLOAD DONE
          sink.close();
        },
      ),
    );

    await request.addStream(streamUpload);

    final httpResponse = await request.close();

    if (httpResponse.statusCode != 200) {
      throw Exception('Error uploading file');
    } else {
      return await readResponseAsString(httpResponse);
    }
  }

  Future<String> fileDownload(
      {String fileName, OnDownloadProgressCallback onDownloadProgress}) async {
    assert(fileName != null);

    final httpClient = getHttpClient();

    final request =
        await httpClient.getUrl(Uri.http(host, "$baseUrl$url/$fileName"));

    request.headers
        .add(HttpHeaders.contentTypeHeader, "application/octet-stream");
    request.headers.add(HttpHeaders.authorizationHeader, identity.getToken());

    var httpResponse = await request.close();

    int byteCount = 0;
    int totalBytes = httpResponse.contentLength;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    //appDocPath = "/storage/emulated/0/Download";

    File file = new File(appDocPath + "/" + fileName);

    var raf = file.openSync(mode: FileMode.write);

    Completer completer = new Completer<String>();

    httpResponse.listen(
      (data) {
        byteCount += data.length;

        raf.writeFromSync(data);

        if (onDownloadProgress != null) {
          onDownloadProgress(byteCount, totalBytes);
        }
      },
      onDone: () {
        raf.closeSync();

        completer.complete(file.path);
      },
      onError: (e) {
        raf.closeSync();
        file.deleteSync();
        completer.completeError(e);
      },
      cancelOnError: true,
    );

    return completer.future;
  }

  static Future<String> readResponseAsString(HttpClientResponse response) {
    var completer = new Completer<String>();
    var contents = new StringBuffer();
    response.transform(utf8.decoder).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }
}
