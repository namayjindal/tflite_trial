import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TFLite Tester',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TFLite Tester'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Interpreter? _anomaly_interpreter;
  Interpreter? _classify_interpreter;
  String _result = 'No inference yet';

  @override
  void initState() {
    super.initState();
    _loadAnomalyModel();
    _loadClassifyModel();
  }

  Future<void> _loadAnomalyModel() async {
    try {
      _anomaly_interpreter = await Interpreter.fromAsset('assets/anomaly_detector.tflite');
      setState(() {
        _result = 'Model loaded successfully';
      });
    } catch (e) {
      setState(() {
        _result = 'Error loading model: $e';
      });
    }
  }

  Future<void> _loadClassifyModel() async {
    try {
      _classify_interpreter = await Interpreter.fromAsset('assets/classification.tflite');
      setState(() {
        _result = 'Model loaded successfully';
      });
    } catch (e) {
      setState(() {
        _result = 'Error loading model: $e';
      });
    }
  }

  Future<void> _runAnomalyInference() async {
    if (_anomaly_interpreter == null) {
      setState(() {
        _result = 'Model not loaded';
      });
      return;
    }

    try {
      // Generate a sample input (you may want to modify this based on your actual input data)
      List<List<double>> input = [List.generate(156, (index) => Random().nextDouble())];

      List<double> output = List.filled(1, 0);

      _anomaly_interpreter!.run(input, output);

      setState(() {
        _result = 'Inference result: ${output[0]}';
      });
    } catch (e) {
      setState(() {
        _result = 'Error running inference: $e';
      });
    }
  }

  Future<void> _runClassifyInference() async {
    if (_anomaly_interpreter == null) {
      setState(() {
        _result = 'Model not loaded';
      });
      return;
    }

    try {
      // Generate a sample input (you may want to modify this based on your actual input data)
      List<List<double>> input = [List.generate(156, (index) => Random().nextDouble())];

      List<double> output = List.filled(1, 0);

      _classify_interpreter!.run(input, output);

      setState(() {
        _result = 'Inference result: ${output[0]}';
      });
    } catch (e) {
      setState(() {
        _result = 'Error running inference: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'TFLite Model Test',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _runAnomalyInference,
              child: const Text('Run Anomaly Detection'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _runClassifyInference,
              child: const Text('Run Classification Inference'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _anomaly_interpreter?.close();
    _classify_interpreter?.close();
    super.dispose();
  }
}