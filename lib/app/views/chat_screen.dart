import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  @override
  Widget build(BuildContext context) {
    return Chat(
      l10n: const ChatL10nEn(
        inputPlaceholder: 'Mensagem',
      ),
      theme: const DarkChatTheme(
        primaryColor: Color.fromARGB(197, 52, 39, 194),
        secondaryColor: Color.fromARGB(255, 68, 68, 68),
        backgroundColor: Color.fromARGB(255, 46, 46, 46),
        inputBackgroundColor: Color.fromARGB(255, 68, 68, 68),
        inputTextStyle: TextStyle(fontFamily: 'Inter'),
        // customizar o resto do tema do chat
        inputBorderRadius: BorderRadius.all(Radius.circular(10)),
        inputMargin: EdgeInsets.only(left: 6, right: 6, bottom: 6),
      ),
      messages: _messages,
      onSendPressed: _handleSendPressed,
      user: _user,
    );
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: "id",
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }
}
