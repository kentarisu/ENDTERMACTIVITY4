import 'package:flutter/material.dart';

class ContactCardsPage extends StatelessWidget {
  const ContactCardsPage({super.key});

  final List<Map<String, String>> contacts = const [
    {
      'name': 'John Doe',
      'email': 'john.doe@email.com',
      'phone': '+1 (555) 123-4567'
    },
    {
      'name': 'Jane Smith',
      'email': 'jane.smith@email.com',
      'phone': '+1 (555) 234-5678'
    },
    {
      'name': 'Mike Johnson',
      'email': 'mike.johnson@email.com',
      'phone': '+1 (555) 345-6789'
    },
    {
      'name': 'Emily Brown',
      'email': 'emily.brown@email.com',
      'phone': '+1 (555) 456-7890'
    },
    {
      'name': 'David Wilson',
      'email': 'david.wilson@email.com',
      'phone': '+1 (555) 567-8901'
    },
    {
      'name': 'Sarah Davis',
      'email': 'sarah.davis@email.com',
      'phone': '+1 (555) 678-9012'
    },
    {
      'name': 'Robert Taylor',
      'email': 'robert.taylor@email.com',
      'phone': '+1 (555) 789-0123'
    },
    {
      'name': 'Lisa Anderson',
      'email': 'lisa.anderson@email.com',
      'phone': '+1 (555) 890-1234'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Cards'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.deepPurple,
                        child: Text(
                          contact['name']![0],
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contact['name']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.email, size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    contact['email']!,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  contact['phone']!,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

