import 'package:flutter/material.dart';
import 'package:app_core/app_core.dart';

void main() {
  initAppCore();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppCore Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'AppCore FFI'),
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
  final _inputController = TextEditingController();
  String _result = '';
  String _asyncResult = '';
  String _blockingResult = '';
  bool _isLoading = false;
  bool _isComputing = false;

  @override
  void initState() {
    super.initState();
    _result = 'AppCore version: ${AppCore.getVersion()}';
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _testMath() {
    final sum = AppCore.sum(10, 20);
    final multiply = AppCore.multiply(5, 6);
    setState(() {
      _result = 'Sum: $sum, Multiply: $multiply';
    });
  }

  void _testStrings() {
    final input =
        _inputController.text.isEmpty ? 'Hello' : _inputController.text;
    final reversed = AppCore.reverseString(input);
    final uppercase = AppCore.toUppercase(input);
    final length = AppCore.stringLength(input);
    final concat = AppCore.concatenate(input, ' World!');

    setState(() {
      _result = '''
                String: "$input"
                Reversed: "$reversed"
                Uppercase: "$uppercase"
                Length: $length
                Concatenated: "$concat"
                ''';
    });
  }

  Future<void> _testFetchAsync() async {
    setState(() {
      _isLoading = true;
      _asyncResult = 'Fetching data...';
    });

    try {
      final result = await AppCore.fetchDataAsync('https://example.com/api');
      setState(() {
        _asyncResult = result;
      });
    } catch (e) {
      setState(() {
        _asyncResult = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testProcessAsync() async {
    final input =
        _inputController.text.isEmpty ? 'Sample data' : _inputController.text;

    setState(() {
      _isLoading = true;
      _asyncResult = 'Processing...';
    });

    try {
      final result = await AppCore.processAsync(input);
      setState(() {
        _asyncResult = result;
      });
    } catch (e) {
      setState(() {
        _asyncResult = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testBlocking() async {
    setState(() {
      _isComputing = true;
      _blockingResult = 'Computing fibonacci(35)...';
    });

    try {
      final stopwatch = Stopwatch()..start();
      final result = await AppCore.fibonacci(35);
      stopwatch.stop();

      setState(() {
        _blockingResult = '''
Fibonacci(35) = $result
Time: ${stopwatch.elapsedMilliseconds}ms
UI stayed responsive!
        ''';
      });
    } catch (e) {
      setState(() {
        _blockingResult = 'Error: $e';
      });
    } finally {
      setState(() {
        _isComputing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Operations',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _testMath,
                      child: const Text('Test Math Functions'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        final greeting = AppCore.helloWorld();
                        setState(() {
                          _result = greeting;
                        });
                      },
                      child: const Text('Hello World'),
                    ),
                    const SizedBox(height: 16),
                    if (_result.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFF00D4AA)
                                  .withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          _result,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'String Operations',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _inputController,
                      decoration: const InputDecoration(
                        labelText: 'Enter text',
                        border: OutlineInputBorder(),
                        hintText: 'Type something...',
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _testStrings,
                      child: const Text('Test String Functions'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Async Operations',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _testFetchAsync,
                            child: const Text('Fetch Data'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _testProcessAsync,
                            child: const Text('Process Async'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.blue.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_isLoading)
                            Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text('Loading...',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic)),
                              ],
                            )
                          else
                            Text(
                              _asyncResult.isEmpty
                                  ? 'No result yet'
                                  : _asyncResult,
                              style: const TextStyle(fontFamily: 'monospace'),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Blocking Operations (Isolates)',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isComputing ? null : _testBlocking,
                      child: const Text('Compute Fibonacci(35)'),
                    ),
                    if (_blockingResult.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.orange.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_isComputing)
                              Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text('Computing...',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic)),
                                ],
                              )
                            else
                              Text(
                                _blockingResult,
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF00D4AA), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: const Color(0xFF00D4AA),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'All FFI Functions Working',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: const Color(0xFF00D4AA),
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'This app demonstrates:\n'
                    '• Math operations (sum, multiply)\n'
                    '• String manipulation (reverse, uppercase, concat)\n'
                    '• Async operations (isolated ports)\n'
                    '• Blocking operations (isolates)\n'
                    '• Cross-platform support',
                    style: TextStyle(
                      color: Colors.grey[300],
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
