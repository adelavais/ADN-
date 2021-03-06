import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Appointments(
        title: "Appointments")
    );
  }

}

List<Appointment> apList = [];
int id=0;

List<Widget> wApList(List<Appointment> l, context){
  List<Widget> newL = [];
  for(var i=0; i<l.length; i++){
    newL.add(l[i].toWidget(context));
  }
  return newL;
}

class Appointments extends StatefulWidget{
  Appointments({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _Appointments createState() => _Appointments();
}

class _Appointments extends State<Appointments>{
  void _addAppointment(){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => AddAppointment()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: wApList(apList, context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAppointment,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

}

class SeeAppointmentDetails extends StatefulWidget{
  
  String name;
  String place;
  String other;
  DateTime time;

  SeeAppointmentDetails(this.name, this.place, this.other, this.time);

  @override
  _SeeAppointmentDetails createState() => _SeeAppointmentDetails(name, place , other, time);
}

class _SeeAppointmentDetails extends State<SeeAppointmentDetails>{
  String name;
  String place;
  String other;
  DateTime time;

  _SeeAppointmentDetails(this.name, this.place, this.other, this.time);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 15.0),
            Text(
              'Location:',
              style: TextStyle(
                fontSize: 20.0),
            ),
            Text(
              '$place',
              style: TextStyle(
                fontSize: 17.0),
            ),
            SizedBox(height: 15.0),
            Text(
              'On: $time',
              style: TextStyle(
                fontSize: 20.0),
            ),
            SizedBox(height: 15.0),
            Text(
              'Details:',
              style: TextStyle(
                fontSize: 20.0),
            ),
            Text(
              '$other',
              style: TextStyle(
                fontSize: 17.0),
            ),
          ],
        ),
        ),
      );
  }

}

class Appointment{
  String name;
  String place;
  String other;
  DateTime time;
  int id;

  Appointment(this.name, this.place, this.other, this.time, this.id);

  Widget toWidget(BuildContext context){
    return FlatButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => SeeAppointmentDetails(name, place, other, time)));
      },
      child: Text('$name'),
      );
  }
}

class AddAppointment extends StatefulWidget{
  @override
  _AddAppointment createState() => _AddAppointment();
}

class _AddAppointment extends State<AddAppointment>{

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  DateFormat _dateFormat = DateFormat("yyyy-MM-dd");
  TextEditingController _textControllerName = TextEditingController();
  TextEditingController _textControllerPlace = TextEditingController();
  TextEditingController _textControllerOther = TextEditingController();

  String _dateStr=' ', _timeStr=' ';

Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
	  print("""found local path\n\n\n""");
    return File('$path/appointments.txt');
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
	  
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }

  Future<File> writeCounter(String list) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(list);
  }

  Future<Null> _selectDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: new DateTime(2000),
      lastDate: new DateTime(2022));

      if(picked != null){
        print('Selected: ${_date.toString()}');
        setState((){
          _date = picked;
          _dateStr = _dateFormat.format(_date);
        });
      }
  }

  Future<Null> _selectTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
      );

      if(picked != null){
        print('Selected: ${_time.toString()}');
        setState((){
          _time = picked;
          _timeStr = picked.toString().substring(10,15);
        });
      }
  }

  void _save(){
    String name = _textControllerName.text;
    String place = _textControllerPlace.text;
    String other = _textControllerOther.text;
    DateTime time = new DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);
  
    if (name=='' || name==null)
      name = 'Appointment';
    if (place=='')
      place = '';
    if (other == '')
      other = '';

    Appointment ap = new Appointment(name, place, other, time, id);
    id = id+1;
    apList.add(ap);
    Navigator.pop(context);
    print(apList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text('New Appointment'),
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 15.0),
            Text(
              'Appointment name:',
              style: TextStyle(
                fontSize: 17.0),
            ),
            SizedBox(height: 5.0),
            TextField(
              controller: _textControllerName,
              decoration: InputDecoration(
                hintText: 'Enter name',
              )
            ),

            SizedBox(height: 20.0),
            Text(
              'Where?',
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
            SizedBox(height: 5.0),
            TextField(
              controller: _textControllerPlace,
              decoration: InputDecoration(
                hintText: 'Enter address',
              )
            ),

            SizedBox(height: 20.0),
            Text(
              'When?',
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
            SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {_selectDate(context);},
                  child: new Text('Select date'),
                  ),
                SizedBox(width: 10.0),
                Text('$_dateStr'),
              ]
            ),

            SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {_selectTime(context);},
                  child: new Text('Select time'),
                  ),
                SizedBox(width: 10.0),
                Text('$_timeStr'),
              ]
            ),

           SizedBox(height: 20.0),
            Text(
              'Other information',
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
            SizedBox(height: 5.0),
            TextField(
              controller: _textControllerOther,
            ), 

            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                RaisedButton(
                      onPressed: () {_save();},
                      child: new Text('Save'),
                      ),
              ],
            ),
            ],
            ),
      ),
    );
  }

}