import 'package:flutter/material.dart';
import 'package:taste_adda/services/notificaition.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {



    final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification Settings")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(
                labelText: "Body",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: "URL",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),



            
        
            ElevatedButton(
              onPressed: () {

              final title = titleController.text.trim();
                final body = bodyController.text.trim();
                final url = urlController.text.trim();

                if (title.isEmpty || body.isEmpty || url.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill all fields.")),
                  );
                  return;
                }

                sendNotification(
                  title: title,
                   body: body, 
                   url: url);

                   titleController.clear();
                    bodyController.clear();
                    urlController.clear();
              },
              child: Text('Send Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
