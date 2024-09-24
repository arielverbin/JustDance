import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import 'client.dart';

Future<void> initPyImpl({String host = "localhost", int? port}) async {
  String workingDirectory = p.join(Directory.current.path, 'assets/pose-scoring');
  if (!Directory(workingDirectory).existsSync()) {
    throw 'The directory $workingDirectory does not exist';
  }

  String serverDist = p.join(workingDirectory, 'server.dist');
  String serverExecutable = p.join(workingDirectory, 'server.dist/server.bin');

  if (!File(serverExecutable).existsSync()) {
    if (defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      await Process.run("chmod", ["u+x", serverDist]);
      await Process.run("chmod", ["u+x", serverExecutable]);
    }
    if (!File(serverExecutable).existsSync()) {
      throw 'The server binary $serverExecutable does not exist';
    }
  }

  if (port == null && host == "localhost") {
    var serverSocket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    port = serverSocket.port;
    serverSocket.close();
    defaultPort = port;
  }

  await shutdownPyIfAnyImpl();

  Process process = await Process.start(
    './server.dist/server.bin',
    [port.toString()],
    workingDirectory: workingDirectory,
    runInShell: true,
  );

  // Capture server output and errors to debug any issues
  process.stdout.transform(utf8.decoder).listen((data) {
    print('Server stdout: $data');
  });

  process.stderr.transform(utf8.decoder).listen((data) {
    print('Server stderr: $data');
  });

  // Check if the process exits with an error immediately
  int? exitCode;
  process.exitCode.then((code) {
    exitCode = code;
  });

  // Wait a short time to ensure the process starts correctly
  await Future.delayed(const Duration(seconds: 2));
  if (exitCode != null) {
    throw 'Failure while launching server process. It stopped right after starting. Exit code: $exitCode';
  }

  print('Server is running on port $port');
}

Future<void> shutdownPyIfAnyImpl() async {
  // Implement logic to kill existing server process by name (server.bin)
  switch (defaultTargetPlatform) {
    case TargetPlatform.linux:
    case TargetPlatform.macOS:
      await Process.run('pkill', ['server.dist/server.bin']);
      break;
    case TargetPlatform.windows:
      await Process.run('taskkill', ['/F', '/IM', 'server.dist/server.bin']);
      break;
    default:
      break;
  }
}
