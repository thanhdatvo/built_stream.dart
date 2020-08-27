import 'package:example/streams/built_composed_streams/start_app_stream.dart';
import 'package:flutter/material.dart';
import 'package:built_stream/stream_annotations.dart';
import 'package:built_stream/stream_types.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Built Stream Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StartAppBloc _startAppBloc;
  @override
  void initState() {
    super.initState();
    _startAppBloc = StartAppBloc();
  }

  void _handleStartApp() {
    _startAppBloc.startAppSubject.input = EmptyParams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<StreamState>(
                stream: _startAppBloc.startAppSubject.outputStream,
                builder: (context, snapshot) {
                  StreamState state = snapshot.data;
                  return Text("Process: " + state.runtimeType.toString());
                }),
            RaisedButton(
              child: Text('Start app'),
              onPressed: _handleStartApp,
            ),
          ],
        ),
      ),
    );
  }
}
