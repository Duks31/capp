  class Message {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final String timestamp;

  Message({
    required this.senderEmail, 
    required this.senderID,
    required this.receiverID, 
    required this.message, 
    required this.timestamp,
    });

  // convert to map

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
