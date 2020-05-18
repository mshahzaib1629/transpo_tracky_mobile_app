import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';
import 'package:transpo_tracky_mobile_app/providers/broadcast_model.dart';
import 'package:transpo_tracky_mobile_app/providers/driver_model.dart';
import 'package:transpo_tracky_mobile_app/widgets/broadcast_message_card.dart';

class PassengerBroadCastScreen extends StatefulWidget {
  @override
  _PassengerBroadCastScreenState createState() => _PassengerBroadCastScreenState();
}

class _PassengerBroadCastScreenState extends State<PassengerBroadCastScreen> {

  @override
  Widget build(BuildContext context) {
    final broadCastMessages =
        Provider.of<BroadCastProvider>(context).broadcastMessages;
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Updates'),
      ),
      body: ListView.builder(
          itemCount: broadCastMessages.length,
          itemBuilder: (context, index) {
            BroadCastMessage msg = broadCastMessages[index];
            return BroadCastMessageCard(msg);
          }),
    );
  }
}
