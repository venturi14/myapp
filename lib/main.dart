import 'package:flutter/material.dart';

void main() {
  runApp(MeetingOrganizerApp());
}

class MeetingOrganizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organizador de Reuniões',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MeetingListScreen(),
    );
  }
}

class MeetingListScreen extends StatefulWidget {
  @override
  _MeetingListScreenState createState() => _MeetingListScreenState();
}

class _MeetingListScreenState extends State<MeetingListScreen> {
  Map<String, Meeting> meetings = {};

  TextEditingController _meetingTitleController = TextEditingController();
  TextEditingController _meetingTopicController = TextEditingController();
  TextEditingController _meetingLocationController = TextEditingController();

  void _addMeeting(String title, String topic, String location) {
    if (title.isNotEmpty && topic.isNotEmpty && location.isNotEmpty) {
      setState(() {
        meetings[title] = Meeting(topic: topic, location: location);
      });
      _clearControllers();
      Navigator.pop(context);
    }
  }

  void _editMeeting(String title) {
    Meeting meeting = meetings[title]!;
    _meetingTitleController.text = title;
    _meetingTopicController.text = meeting.topic;
    _meetingLocationController.text = meeting.location;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Reunião'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _meetingTitleController,
                decoration: InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: _meetingTopicController,
                decoration: InputDecoration(labelText: 'Tópico'),
              ),
              TextField(
                controller: _meetingLocationController,
                decoration: InputDecoration(labelText: 'Local'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  meetings.remove(title);
                  meetings[_meetingTitleController.text] = Meeting(
                    topic: _meetingTopicController.text,
                    location: _meetingLocationController.text,
                  );
                });
                _clearControllers();
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMeeting(String title) {
    setState(() {
      meetings.remove(title);
    });
  }

  void _showAddMeetingDialog() {
    _clearControllers();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Reunião'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _meetingTitleController,
                decoration: InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: _meetingTopicController,
                decoration: InputDecoration(labelText: 'Tópico'),
              ),
              TextField(
                controller: _meetingLocationController,
                decoration: InputDecoration(labelText: 'Local'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addMeeting(
                  _meetingTitleController.text,
                  _meetingTopicController.text,
                  _meetingLocationController.text,
                );
              },
              child: Text('Adicionar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _clearControllers() {
    _meetingTitleController.clear();
    _meetingTopicController.clear();
    _meetingLocationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organizador de Reuniões'),
      ),
      body: ListView.builder(
        itemCount: meetings.length,
        itemBuilder: (context, index) {
          String title = meetings.keys.elementAt(index);
          Meeting meeting = meetings[title]!;
          return Card(
            child: ListTile(
              title: Text(title),
              subtitle: Text('Tópico: ${meeting.topic}\nLocal: ${meeting.location}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _editMeeting(title),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteMeeting(title),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMeetingDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

class Meeting {
  String topic;
  String location;

  Meeting({required this.topic, required this.location});
}
