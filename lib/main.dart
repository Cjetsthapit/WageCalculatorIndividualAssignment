import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Wage Calculator'),
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
  TextEditingController hourlyRate = TextEditingController();
  TextEditingController hoursWorked = TextEditingController();

  double regularPay = 0;
  double overtimePay = 0;
  double totalPay = 0;
  double tax = 0;
  bool hoursWorkedError = false;
  bool hourlyRateError = false;

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void calculations() {
    setState(() {
      // Validate hoursWorked
      if (hoursWorked.text.isEmpty ||
          double.tryParse(hoursWorked.text) == null) {
        hoursWorkedError = true;
        showSnackbar('Please enter a valid number for hours worked');
        return;
      } else {
        hoursWorkedError = false;
      }

      // Validate hourlyRate
      if (hourlyRate.text.isEmpty || double.tryParse(hourlyRate.text) == null) {
        hourlyRateError = true;
        showSnackbar('Please enter a valid hourly rate');
        return;
      } else {
        hourlyRateError = false;
      }

      double hours = double.parse(hoursWorked.text);
      double rate = double.parse(hourlyRate.text);

      // Validate hoursWorked

      if (hours > 40) {
        regularPay = 40 * rate;
        overtimePay = (hours - 40) * (rate * 1.5);
      } else {
        regularPay = hours * rate;
        overtimePay = 0;
      }

      totalPay = regularPay + overtimePay;
      tax = totalPay * 0.18;
    });
  }

  void clear() {
    setState(() {
      regularPay = 0;
      overtimePay = 0;
      totalPay = 0;
      tax = 0;
      hourlyRate.text = '';
      hoursWorked.text = '';
      hoursWorkedError = false;
      hourlyRateError = false;
    });
  }

  Widget buildTextField(
    TextEditingController controller,
    String hintText,
    bool showError,
    String? errorText,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          label: Text(hintText),
          border: const OutlineInputBorder(),
          errorText: showError ? errorText : null,
        ),
      ),
    );
  }

  Widget buildTextRow(IconData icon, String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Row(
          children: [
            Icon(icon),
            SizedBox(width: 5),
            Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
        Text(
          "${value.toStringAsFixed(1)}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  buildTextField(
                    hoursWorked,
                    'Number of Hours',
                    hoursWorkedError,
                    'Please enter a valid number for hours worked',
                  ),
                  SizedBox(height: 7),
                  buildTextField(
                    hourlyRate,
                    'Hourly Rate',
                    hourlyRateError,
                    'Please enter a valid hourly rate',
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: calculations,
                    style: ElevatedButton.styleFrom(
                      primary: Colors
                          .teal, // Set the background color to the primary color
                    ),
                    child: const Text("Calculate Wage",
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: clear,
                    child: const Text("Clear"),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildTextRow(
                          Icons.attach_money, "Regular Pay", regularPay),
                      buildTextRow(Icons.watch_later_outlined, "Overtime Pay",
                          overtimePay),
                      buildTextRow(
                          Icons.summarize_outlined, "Total Pay", totalPay),
                      buildTextRow(Icons.money_off, "Tax", tax),
                      // buildTextRow(Icons.attach_money, "Net Pay", netPay),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Srijeet Sthapit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Text color
                        ),
                      ),
                      SizedBox(height: 10),
                      // Add some spacing between the texts
                      Text(
                        '301365217',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white, // Text color
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
