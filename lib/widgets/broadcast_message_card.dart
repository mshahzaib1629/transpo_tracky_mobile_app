import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';
import 'package:transpo_tracky_mobile_app/providers/broadcast_model.dart';

class BroadCastMessageCard extends StatefulWidget {
  final BroadCastMessage message;
  BroadCastMessageCard(this.message);

  @override
  _BroadCastMessageCardState createState() => _BroadCastMessageCardState();
}

class _BroadCastMessageCardState extends State<BroadCastMessageCard> {
  Widget _buildLead() {
    return Center(
      heightFactor: 0.0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 2.22 * SizeConfig.widthMultiplier,
          vertical: 1.25 * SizeConfig.heightMultiplier,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius:
              BorderRadius.circular(8.33 * SizeConfig.imageSizeMultiplier),
        ),
        width: 36.11 * SizeConfig.widthMultiplier,
        alignment: Alignment.center,
        child: Text(
          widget.message.sender.firstName +
              ' ' +
              widget.message.sender.lastName,
          style:
              Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      margin: EdgeInsets.only(
          top: 3.75 * SizeConfig.heightMultiplier,
          left: 2.23 * SizeConfig.widthMultiplier,
          right: 2.23 * SizeConfig.widthMultiplier,
          bottom: 1.25 * SizeConfig.heightMultiplier),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Center(
            child: Text('"${widget.message.messageData}"',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontStyle: FontStyle.italic)),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(DateFormat.jm().format(widget.message.datetime)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 3.98 * SizeConfig.heightMultiplier,
        left: 3.18 * SizeConfig.widthMultiplier,
        right: 3.18 * SizeConfig.widthMultiplier,
        bottom: 1.18 * SizeConfig.heightMultiplier,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius:
            BorderRadius.circular(2.78 * SizeConfig.imageSizeMultiplier),
      ),
      child: Stack(
        children: [
          _buildBody(),
          _buildLead(),
        ],
      ),
    );
  }
}
