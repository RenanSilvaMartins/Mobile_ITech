import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class TechnicianChatScreen extends StatefulWidget {
  final String clientName;
  final String requestId;

  const TechnicianChatScreen({
    Key? key,
    required this.clientName,
    required this.requestId,
  }) : super(key: key);

  @override
  State<TechnicianChatScreen> createState() => _TechnicianChatScreenState();
}

class _TechnicianChatScreenState extends State<TechnicianChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'text': 'Olá! Recebi sua solicitação de reparo. Posso chegar aí em 30 minutos.',
      'isFromTechnician': true,
      'timestamp': DateTime.now().subtract(Duration(minutes: 15)),
    },
    {
      'id': '2',
      'text': 'Perfeito! Estarei esperando. O notebook está completamente sem energia.',
      'isFromTechnician': false,
      'timestamp': DateTime.now().subtract(Duration(minutes: 12)),
    },
    {
      'id': '3',
      'text': 'Entendi. Vou levar algumas fontes para teste. Qual é o modelo do notebook?',
      'isFromTechnician': true,
      'timestamp': DateTime.now().subtract(Duration(minutes: 10)),
    },
    {
      'id': '4',
      'text': 'É um Dell Inspiron 15 3000, comprei há 2 anos.',
      'isFromTechnician': false,
      'timestamp': DateTime.now().subtract(Duration(minutes: 8)),
    },
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': _messageController.text.trim(),
        'isFromTechnician': true,
        'timestamp': DateTime.now(),
      });
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.clientName),
            Text(
              'Online',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ligando para ${widget.clientName}...')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Iniciando videochamada...')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isFromTechnician = message['isFromTechnician'];
                
                return Align(
                  alignment: isFromTechnician 
                      ? Alignment.centerRight 
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isFromTechnician 
                          ? AppColors.primaryPurple 
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(18).copyWith(
                        bottomRight: isFromTechnician 
                            ? Radius.circular(4) 
                            : Radius.circular(18),
                        bottomLeft: !isFromTechnician 
                            ? Radius.circular(4) 
                            : Radius.circular(18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['text'],
                          style: TextStyle(
                            color: isFromTechnician ? Colors.white : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _formatTime(message['timestamp']),
                          style: TextStyle(
                            color: isFromTechnician 
                                ? Colors.white70 
                                : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Quick Actions
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickAction('Chegando em 10min', Icons.access_time),
                  _buildQuickAction('Preciso de mais info', Icons.info),
                  _buildQuickAction('Serviço concluído', Icons.check_circle),
                  _buildQuickAction('Enviar localização', Icons.location_on),
                ],
              ),
            ),
          ),
          // Message Input
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: AppColors.primaryPurple),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('Câmera'),
                              onTap: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Abrindo câmera...')),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo),
                              title: Text('Galeria'),
                              onTap: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Abrindo galeria...')),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.location_on),
                              title: Text('Localização'),
                              onTap: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Enviando localização...')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Digite sua mensagem...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String text, IconData icon) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _messages.add({
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'text': text,
              'isFromTechnician': true,
              'timestamp': DateTime.now(),
            });
          });
          _scrollToBottom();
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryPurple),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppColors.primaryPurple),
              SizedBox(width: 4),
              Text(
                text,
                style: TextStyle(
                  color: AppColors.primaryPurple,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}