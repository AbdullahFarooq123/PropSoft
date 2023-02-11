import 'package:flashchat/Classes/AwesomeDialogue.dart';
import 'package:flashchat/Constants.dart';
import 'package:flashchat/Widgets/CircularContainer.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class LeadsBubble extends StatefulWidget {
  final Map<dynamic, dynamic> leadData;
  final String tokenId;

  const LeadsBubble({
    Key? key,
    required this.leadData,
    required this.tokenId,
  }) : super(key: key);

  @override
  State<LeadsBubble> createState() => _LeadsBubbleState();
}

class _LeadsBubbleState extends State<LeadsBubble> {
  bool visible = false;
  late final String leadId;
  late final String leadName;
  late final String leadContact;
  late final String leadProject;
  late final String leadProduct;
  late final String leadDate;
  late final String followUpDate;
  late final String assignedDate;
  late final String communicationDate;
  late final List<Widget> hiddenData;

  @override
  initState() {
    super.initState();
    leadId = widget.leadData['leadID'].toString();
    leadName = widget.leadData['client'].toString();
    leadContact = widget.leadData['contact'].toString();
    leadProject = widget.leadData['project'].toString();
    leadProduct = widget.leadData['product'].toString();
    leadDate = getDate(DateTime.parse(widget.leadData['leadDate']));
    followUpDate = widget.leadData['followUpOn'] == null
        ? 'None'
        : getDate(DateTime.parse(widget.leadData['followUpOn']));
    assignedDate = getDate(DateTime.parse(widget.leadData['assignedAT']));
    communicationDate = widget.leadData['communicationAT'] == null
        ? 'None'
        : getDate(DateTime.parse(widget.leadData['communicationAT']));
    hiddenData = [
      getField(fieldTitle: 'Lead Date', fieldDescription: leadDate),
      getField(fieldTitle: 'Follow up', fieldDescription: followUpDate),
      getField(fieldTitle: 'Assigned at', fieldDescription: assignedDate),
      getField(
          fieldTitle: 'Communication at', fieldDescription: communicationDate),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 3, color: foregroundColor2),
      ),
      child: TextButton(
        onPressed: () async {
          String? response = await Navigator.pushNamed(
              context, 'communication screen',
              arguments: {
                'Token Id': widget.tokenId,
                'Lead Id': leadId,
                'Assigned By': widget.leadData['by'],
                'Team Id': widget.leadData['teamID'],
              }) as String;
          if (response == ('Server timed out')) {
            AwesomeDialogueBox.showDialogueWithoutCancel(
              title: 'Server timed out!',
              dialogType: DialogType.ERROR,
              context: context,
              btnColor: Colors.red,
              btnText: 'Ok',
              btnIcon: Icons.cancel,
              duration: errorMsgDuration,
            );
          }
        },
        child: IntrinsicHeight(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black, width: 1))),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 12),
                      decoration: const BoxDecoration(
                        color: foregroundColor2,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Text(
                        leadId,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        leadName,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(leadContact),
                  CircularContainer(
                      containerColor: appBarColor,
                      child: Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 15,
                      ),
                  ),
                ],
              ),
              Container(
                width: mediaSize.width * 0.95,
                margin: const EdgeInsets.only(top: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: const BoxDecoration(
                    color: foregroundColor2,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                        getField(
                            fieldTitle: 'Contact',
                            fieldDescription: leadContact),
                        getField(
                            fieldTitle: 'Product',
                            fieldDescription: leadProduct),
                        getField(
                            fieldTitle: 'Project',
                            fieldDescription: leadProject),
                      ] +
                      (visible ? hiddenData : []),
                ),
              ),
              IconButton(
                icon: Icon(
                  !visible
                      ? Icons.arrow_drop_down_outlined
                      : Icons.arrow_drop_up_outlined,
                  color: foregroundColor2,
                ),
                onPressed: () {
                  setState(() {
                    visible = !visible;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getField(
      {required final String fieldTitle,
      required final String fieldDescription}) {
    const Color borderColor = Colors.grey;
    const Color textColor = Colors.white;
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
              child: Text(
            fieldTitle,
            style: const TextStyle(color: textColor),
          )),
          Expanded(
              child: Text(
            fieldDescription,
            style: const TextStyle(color: textColor),
          )),
        ],
      ),
    );
  }
}
