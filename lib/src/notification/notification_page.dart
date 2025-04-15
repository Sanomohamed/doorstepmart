import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final userId = FirebaseAuth.instance.currentUser;

  Stream<QuerySnapshot> _notificationsStream() {
    if (userId == null) return const Stream.empty();

    final uid = userId!.uid;

    return FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> _markAsRead(String docId) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(docId)
        .update({'read': true});
  }

  Future<void> _deleteNotification(String docId) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(docId)
        .delete();
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    // ✅ FIXED: Use 'targetId' instead of 'orderId'
    final String? orderId = notification['targetId'];
    if (orderId != null) {
      Navigator.pushNamed(context, '/orderDetails', arguments: orderId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      backgroundColor: const Color(0xFFF8F8F8),
      body: StreamBuilder<QuerySnapshot>(
        stream: _notificationsStream(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notifications found'));
          }
          final notifications = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final doc = notifications[index];
              final data = doc.data() as Map<String, dynamic>;
              final isRead = data['read'] == true;
              final timestamp = data['timestamp'] as Timestamp?;
              final dateTime = timestamp?.toDate();
              final formattedTime = dateTime != null ? DateFormat('MMM dd, yyyy | hh:mm a').format(dateTime) : '';

              return Dismissible(
                key: Key(doc.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white, size: 28),
                ),
                onDismissed: (_) => _deleteNotification(doc.id),
                child: GestureDetector(
                  onTap: () {
                    _markAsRead(doc.id);
                    _handleNotificationTap(data);
                  },

                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),

                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            isRead ? Icons.notifications : Icons.notifications_active,
                            size: 28,
                            color: isRead ? Colors.grey : Colors.green,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['title'] ?? 'No Title',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  data['message'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                    const SizedBox(width: 5),
                                    Text(
                                      formattedTime,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.more_vert, color: Colors.grey),
                            onPressed: () {
                              //future implementation for more options
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
