import 'package:flutter/material.dart';
import 'package:math_tool/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const int proportionalMode = 1;
  static const int inverseMode = 2;
  int mode = proportionalMode;
  TextEditingController x1y1Controller = TextEditingController();
  TextEditingController x2y1Controller = TextEditingController();
  TextEditingController x3y1Controller = TextEditingController();

  TextEditingController x1y2Controller = TextEditingController();
  TextEditingController x2y2Controller = TextEditingController();
  TextEditingController x3y2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("欧姆定律"),
        actions: [
          Center(
            child: InkWell(
              child: const Text("切换"),
              onTap: () {
                mode =
                    mode == proportionalMode ? inverseMode : proportionalMode;
                x1y1Controller.text = "";
                x2y1Controller.text = "";
                x3y1Controller.text = "";

                x1y2Controller.text = "";
                x2y2Controller.text = "";
                x3y2Controller.text = "";
                setState(() {});
              },
            ),
          )
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 50, right: 50),
              child: _buildTable(),
            ),
            const SizedBox(height: 10),
            builtChart(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        tooltip: 'Increment',
        child: const Text("画图"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildTable() {
    return Table(
      border: TableBorder.all(color: Colors.black),
      children: [
        TableRow(children: [
          mode == proportionalMode
              ? _createCell(const Text("电压 U/V"))
              : _createCell(const Text("电阻 R/Ω")),
          _createCell(createCommonField(x1y1Controller)),
          _createCell(createCommonField(x2y1Controller)),
          _createCell(createCommonField(x3y1Controller)),
        ]),
        TableRow(children: [
          _createCell(const Text('电流 I/A')),
          _createCell(
            createCommonField(x1y2Controller),
          ),
          _createCell(createCommonField(x2y2Controller)),
          _createCell(createCommonField(x3y2Controller)),
        ]),
      ],
    );
  }

  TextField createCommonField(TextEditingController controller) {
    return TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(border: InputBorder.none));
  }

  Widget _createCell(Widget child) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: child,
      ),
    );
  }

  Widget builtChart() {
    List<ChartData> chartData = [];
    if (x1y1Controller.text.isNotEmpty && x1y2Controller.text.isNotEmpty) {
      chartData.add(ChartData(double.parse(x1y1Controller.text),
          double.parse(x1y2Controller.text)));
    }

    if (x2y1Controller.text.isNotEmpty && x2y2Controller.text.isNotEmpty) {
      chartData.add(ChartData(double.parse(x2y1Controller.text),
          double.parse(x2y2Controller.text)));
    }

    if (x3y1Controller.text.isNotEmpty && x3y2Controller.text.isNotEmpty) {
      chartData.add(ChartData(double.parse(x3y1Controller.text),
          double.parse(x3y2Controller.text)));
    }

    return SfCartesianChart(
      key: Key('${Uuid().v4().toString()}'),
      primaryXAxis: NumericAxis(decimalPlaces: 5),
      primaryYAxis:
          NumericAxis(decimalPlaces: 5, rangePadding: ChartRangePadding.none),
      series: <ChartSeries<ChartData, double>>[
        LineSeries<ChartData, double>(
            dataSource: chartData,
            markerSettings: const MarkerSettings(isVisible: true),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y),
      ],
    );
  }
}
