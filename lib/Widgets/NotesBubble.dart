import 'package:flashchat/Constants.dart';
import 'package:flashchat/Widgets/CircularContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotesBubble extends StatelessWidget {
  final String communicationDate;
  final String leadCommunication;
  final String leadStatus;
  final String leadFollowUp;
  final String comments;
  final TextEditingController notes = TextEditingController();
  final int leadIndex;

  NotesBubble({
    Key? key,
    required this.communicationDate,
    required this.leadStatus,
    required this.leadCommunication,
    required this.leadFollowUp,
    required this.comments,
    required this.leadIndex,
  }) : super(key: key) {
    notes.text = comments;
  }

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    final double mediaFont = MediaQuery.of(context).textScaleFactor;
    final double iconSize = 15 * mediaFont;
    return IntrinsicHeight(
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: appBarColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            CircularContainer(
              margin: const EdgeInsets.only(top: 5, bottom: 10),
              containerColor: Colors.blueGrey,
              child: Row(
                children: [
                  CircularContainer(
                    containerColor: appBarColor,
                    margin: const EdgeInsets.only(right: 5),
                    child:
                        getCommunicationTypeIcon(leadCommunication, iconSize),
                  ),
                  Flexible(
                    // flex: 2,
                    child: CircularContainer(
                      containerColor: appBarColor,
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: Colors.red,
                            size: iconSize,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(child: Text(leadStatus)),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    // flex: 2,
                    child: CircularContainer(
                      containerColor: appBarColor,
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications_on_sharp,
                            color: Colors.yellow,
                            size: iconSize,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(child: Text(leadFollowUp)),
                        ],
                      ),
                    ),
                  ),
                  // Flexible(child: Container())
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: IntrinsicWidth(child: Text(comments, textAlign: TextAlign.justify,))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  communicationDate,
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Icon getCommunicationTypeIcon(String communicationType, double iconSize) {
    final Icon phoneIcon =
        Icon(Icons.phone, color: Colors.blue, size: iconSize);
    final Icon emailIcon = Icon(Icons.email, color: Colors.red, size: iconSize);
    final Icon messageIcon =
        Icon(Icons.message, color: Colors.white, size: iconSize);
    final Icon whatsAppIcon =
        Icon(Icons.whatsapp, color: Colors.green, size: iconSize);
    final Icon othersIcon =
        Icon(Icons.more, color: Colors.deepPurple, size: iconSize);
    switch (communicationType) {
      case 'Phone':
        return phoneIcon;
      case 'Email':
        return emailIcon;
      case 'SMS':
        return messageIcon;
      case 'Whatsapp':
        return whatsAppIcon;
      default:
        return othersIcon;
    }
  }
}
