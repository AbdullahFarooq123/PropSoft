
import 'package:flashchat/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FlexibleBar extends StatelessWidget {
  final String leadId;
  final String leadName;
  final String leadContact;
  final String leadProject;
  final String leadProduct;
  final BuildContext parentContext;
  final List<Widget> children;
  final List<Widget> actions;

  const FlexibleBar(
      {Key? key,
      required this.leadName,
      required this.leadContact,
      required this.leadProject,
      required this.leadProduct,
      required this.leadId,
      required this.parentContext,
      required this.children, required this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    final double mediaFont = MediaQuery.of(context).textScaleFactor;
    const Color phoneColor = Colors.blue;
    const Color messageColor = Colors.blueGrey;
    const Color whatsAppColor = Colors.green;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: (mediaSize.height / 2) * mediaFont,
          collapsedHeight: kToolbarHeight,
          pinned: true,
          automaticallyImplyLeading: false,
          actions: actions,
          title: Container(
            height: kToolbarHeight,
            width: mediaSize.width,
            color: appBarColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 12),
                      decoration: const BoxDecoration(
                        color: foregroundColor2,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Text(
                        leadId,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Text(
                          leadName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20 * mediaFont,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          titleSpacing: 0,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            titlePadding: const EdgeInsets.only(left: 50),
            background: Container(
              color: appBarColor,
              padding: const EdgeInsets.only(top: kToolbarHeight * 1.5),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10 * mediaFont),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: leadId.length.toDouble() * 8 * mediaFont,
                          backgroundColor: foregroundColor2,
                          child: Text(
                            leadId,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20 * mediaFont,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        leadName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 5 * mediaFont),
                    child: const Divider(
                      color: foregroundColor2,
                      thickness: 3,
                      height: 10,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15 * mediaFont),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              leadProject,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15 * mediaFont),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              leadProduct,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15 * mediaFont),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      launchUrl(Uri.parse('tel:$leadContact'));
                                    },
                                    icon: Icon(
                                      Icons.phone,
                                      color: phoneColor,
                                      size: 24 * mediaFont,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    'Phone',
                                    style: TextStyle(color: phoneColor),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      launchUrl(Uri.parse('sms:$leadContact'));
                                    },
                                    icon: Icon(
                                      Icons.message,
                                      color: messageColor,
                                      size: 24 * mediaFont,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    'Message',
                                    style: TextStyle(color: messageColor),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      String formatContact =
                                          leadContact.replaceRange(0, 1, '+92');
                                      var whatsappURlAndroid =
                                          "whatsapp://send?phone=$formatContact&text=Alsalam-o-Alikum";
                                      await launchUrl(
                                          Uri.parse(whatsappURlAndroid));
                                    },
                                    icon: Icon(
                                      Icons.whatsapp,
                                      color: whatsAppColor,
                                      size: 24 * mediaFont,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    'Whatsapp',
                                    style: TextStyle(color: whatsAppColor),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: children,
              );
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }
}
