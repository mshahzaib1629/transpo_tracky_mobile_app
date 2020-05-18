import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';
import 'package:transpo_tracky_mobile_app/providers/broadcast_model.dart';
import 'package:transpo_tracky_mobile_app/providers/driver_model.dart';
import 'package:transpo_tracky_mobile_app/widgets/broadcast_message_card.dart';

class DriverBroadCastScreen extends StatefulWidget {
  @override
  _DriverBroadCastScreenState createState() => _DriverBroadCastScreenState();
}

class _DriverBroadCastScreenState extends State<DriverBroadCastScreen> {
  final _messageController = TextEditingController();

  Widget _bottomBar() {
    return Container(
      margin: EdgeInsets.only(
        top: 0.625 * SizeConfig.heightMultiplier,
        bottom: 0.9375 * SizeConfig.heightMultiplier,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 3.56 * SizeConfig.widthMultiplier,
                vertical: 0.56 * SizeConfig.widthMultiplier),
            decoration: BoxDecoration(
              border: Border.all(
                  width: 0.3125 * SizeConfig.imageSizeMultiplier,
                  color: Theme.of(context).accentColor),
              borderRadius:
                  BorderRadius.circular(6.5 * SizeConfig.imageSizeMultiplier),
            ),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              minLines: 1,
              controller: _messageController,
              decoration:
                  InputDecoration.collapsed(hintText: 'Enter message here'),
            ),
          )),
          IconButton(
            icon: Icon(
              Icons.send,
              size: 7.7 * SizeConfig.imageSizeMultiplier,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              var newMessage = BroadCastMessage(
                // ---------------------------------------------------------------
                // here current logged in driver's data will be send to the server
                sender: Driver(
                  id: 1,
                  registrationID: 'EMP-DR-1',
                  firstName: 'Mushtaq',
                  lastName: 'Ahmed',
                ),
                // ---------------------------------------------------------------
                datetime: DateTime.now(),
                messageData: _messageController.text,
              );
              Provider.of<BroadCastProvider>(context, listen: false)
                  .sendNewMessage(message: newMessage)
                  .then((_) {
                setState(() {
                  _messageController.text = '';
                });
              });
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final broadCastMessages =
        Provider.of<BroadCastProvider>(context).broadcastMessages;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notify Passengers'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                reverse: true,
                itemCount: broadCastMessages.length,
                itemBuilder: (context, index) {
                  BroadCastMessage msg = broadCastMessages[index];
                  return BroadCastMessageCard(msg);
                }),
          ),
          _bottomBar(),
        ],
      ),
    );
  }
}
