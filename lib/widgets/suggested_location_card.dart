import 'package:flutter/material.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';

class SuggestedLocationCard extends StatelessWidget {
  final prediction;
  final Function fetchTripsByLocationId;

  SuggestedLocationCard({this.prediction, this.fetchTripsByLocationId});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        fetchTripsByLocationId(prediction['id']);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 1.0 * SizeConfig.heightMultiplier),
        padding: EdgeInsets.symmetric(
          vertical: 2.56 * SizeConfig.heightMultiplier,
          horizontal: 2.78 * SizeConfig.widthMultiplier,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius:
              BorderRadius.circular(2.78 * SizeConfig.imageSizeMultiplier),
        ),
        child: Container(
          width: 61.1 * SizeConfig.widthMultiplier,
          child: Text(
            prediction['name'],
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(fontSize: 2.4 * SizeConfig.textMultiplier),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
