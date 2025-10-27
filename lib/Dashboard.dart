import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For loading assets
import 'package:file_picker/file_picker.dart';
import 'DetailScreen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Uint8List? selectedImageBytes;
  String selectedEventType = 'Wedding';
  final TextEditingController organizerNameController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  // Storage for uploaded images - in production this would be Firebase Storage
  static final Map<String, Uint8List> _uploadedImages = {};

  @override
  void initState() {
    super.initState();
  }

  // Show confirmation dialog before clearing events
  void _showClearConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Clear All Events'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete all existing events? This action cannot be undone.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllEvents();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Clear All'),
          ),
        ],
      ),
    );
  }

  // Method to clear all existing events
  Future<void> _clearAllEvents() async {
    try {
      // Get all events
      final QuerySnapshot snapshot = await firestore.collection('events').get();
      
      // Delete each event
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      
      // Clear uploaded images cache
      _uploadedImages.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All events cleared successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      setState(() {}); // Refresh the UI
    } catch (e) {
      print('Error clearing events: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to clear events: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to open the dialog to add a new event
  Future<void> _showAddEventDialog() async {
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedEventType,
                  items: <String>[
                    'Wedding',
                    'Birthday',
                    'Engagement',
                    'Graduation Party',
                    'Farewell'
                  ].map((String eventType) {
                    return DropdownMenuItem<String>(
                      value: eventType,
                      child: Text(eventType),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedEventType = value!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Event Type'),
                ),
                TextField(
                  controller: organizerNameController,
                  decoration:
                      const InputDecoration(labelText: 'Organizer Name'),
                ),
                SizedBox(height: 16),
                // Image upload section
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(Icons.image),
                        label: Text('Upload Image'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple.shade100,
                          foregroundColor: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
                if (selectedImageBytes !=
                    null) // Display the selected image preview
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        Text('Selected Image:', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Container(
                          constraints: BoxConstraints(maxHeight: 150),
                          child: Image.memory(selectedImageBytes!, fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (organizerNameController.text.isNotEmpty) {
                  // Add event to Firestore
                  final docRef = await firestore.collection('events').add({
                    'eventType': selectedEventType,
                    'organizer': organizerNameController.text,
                    'createdAt': DateTime.now(),
                  });
                  
                  // Store uploaded image if one was selected
                  if (selectedImageBytes != null) {
                    _uploadedImages[docRef.id] = selectedImageBytes!;
                  }
                  
                  // Clear form
                  organizerNameController.clear();
                  selectedImageBytes = null;
                  
                  Navigator.pop(context);
                  setState(() {}); // Update UI after adding
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  // Method to pick and upload image
  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // Important for web to get bytes
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          selectedImageBytes = result.files.single.bytes;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  // Helper function to get image bytes for each event - checks uploaded images first
  Future<Uint8List?> _getImageBytesForEvent(String eventId, String eventType) async {
    // First check if we have an uploaded image for this specific event
    if (_uploadedImages.containsKey(eventId)) {
      return _uploadedImages[eventId];
    }
    
    // If no uploaded image, return null to show placeholder
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Dashboard'),
        backgroundColor: Colors.deepPurple,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear') {
                _showClearConfirmationDialog();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Clear All Events'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('events')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: const Text('No events added yet!'));
          }

          final events = snapshot.data!.docs;

          return GridView.builder(
            itemCount: events.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final eventData = events[index].data() as Map<String, dynamic>;
              final eventId = events[index].id;
              return FutureBuilder<Uint8List?>(
                future: _getImageBytesForEvent(eventId, eventData['eventType'] ?? 'Wedding'),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return _buildEventCard(
                      eventData['eventType'] ?? 'Unknown',
                      eventData['organizer'] ?? 'Organizer',
                      snapshot.data!,
                    );
                  } else {
                    return _buildPlaceholderCard(
                      eventData['eventType'] ?? 'Unknown',
                      eventData['organizer'] ?? 'Organizer',
                    );
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  Widget _buildEventCard(
      String eventName, String organizer, Uint8List imageBytes) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(
              eventName: eventName,
              imageBytes: imageBytes,
              eventDate: '2024-10-22',
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.memory(
                imageBytes,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: Text(
                eventName,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard(String eventName, String organizer) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Icon(
              Icons.event,
              size: 40,
              color: Colors.grey[500],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Text(
              eventName,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
