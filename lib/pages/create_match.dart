import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

class CreateMatch extends StatefulWidget {
  const CreateMatch({Key? key, required this.matchType}) : super(key: key);

  final String matchType;

  @override
  State<CreateMatch> createState() => _CreateMatchState();
}

class _CreateMatchState extends State<CreateMatch> {
  final _formKey = GlobalKey<FormState>();

  DateTime? initvalue;

  void validate() {
    if (_formKey.currentState!.validate()) {
      print("done!");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Text Controllers
    TextEditingController matchNameController = TextEditingController();

    // Tournament Entry
    TextFormField matchName = TextFormField(
      controller: matchNameController,
      decoration: const InputDecoration(
        labelText: "Tournament Name",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.align_horizontal_left),
      ),
      validator: (value) => value!.isEmpty ? "This field cannot be empty" : null,
    );

    // Dropdowns

    // --------------- Return is Here --------------- //
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text("Fill Details"),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // match name
                    Padding(padding: const EdgeInsets.all(10.0), child: matchName),

                    // dropdowns

                    // select date
                    const Padding(padding: EdgeInsets.all(10.0), child: PickDate()),

                    // submit button
                    ElevatedButton(
                        onPressed: () {
                          validate();
                        },
                        child: const Text("Submit"))
                  ],
                ))),
      ),
    );
  }
}

// Pick Date Widget
class PickDate extends StatelessWidget {
  const PickDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = DateTime.now();

    String currentYear = selectedDate.toString().split("-")[0];
    String currentMonth = selectedDate.toString().split("-")[1];
    String currentDay = selectedDate.toString().split("-")[2].split(" ")[0];
    String matchStartDay = (int.parse(currentDay) + 2).toString();
    DateTime matchTime = DateTime.parse(currentYear + currentMonth + matchStartDay);

    // select date function
    void selectDate() async {
      DateTime? pickedDate = await showDatePicker(
          context: context, initialDate: matchTime, firstDate: matchTime, lastDate: DateTime(2100));
      context.read<DateProvider>().setDate(pickedDate);
    }

    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Expanded(
        child: InputDatePickerFormField(
          firstDate: matchTime,
          lastDate: DateTime(2100),
          fieldLabelText: "Enter Date or Pick from Calendar",
          errorFormatText: "Invalid Date Format (mm/dd/yyyy)",
          errorInvalidText: "Schedule matches atleast 2 days from now",
          initialDate: context.watch<DateProvider>().initvalue,
        ),
      ),
      const SizedBox(width: 20),
      GestureDetector(
          onTap: () {
            selectDate();
          },
          child: const Icon(Icons.calendar_today))
    ]);
  }
}

// Date Provider
class DateProvider with ChangeNotifier {
  DateTime? _initvalue;

  DateTime? get initvalue => _initvalue;

  void setDate(DateTime? value) {
    _initvalue = value;
    notifyListeners();
  }
}
