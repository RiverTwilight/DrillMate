import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import 'package:hgeology_app/constants.dart';
import 'package:hgeology_app/widget/custom_bottomsheet.dart';
import 'package:hgeology_app/widget/tip_text.dart';
import 'package:url_launcher/url_launcher.dart';

void contactViaEmail() async {
  const email = 'yungeeker@gmail.com';
  final subject = Uri.encodeComponent('Feedback for the app');
  final body = Uri.encodeComponent('Dear developer:');

  final url = 'mailto:$email?subject=$subject&body=$body';

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    await launchUrl(Uri.parse(supportWebsite));
  }
}

void contactViaBlog() async {
  await launch("https://rene.wang");
}

void rateApp() async {
  if (Platform.isIOS) {
    await launchUrl(Uri.parse(appStoreLink));
  } else if (Platform.isAndroid) {
    await launchUrl(Uri.parse(playStoreLink));
  }
}

void visitBrochure() async {
  await launchUrl(Uri.parse(brochureSiteLink));
}

void checkPrivacyPolicy() async {
  await launchUrl(Uri.parse(t.links.root + t.links.privacy));
}

void checkTermOfUse() async {
  await launchUrl(Uri.parse(t.links.root + t.links.term));
}

void check101() async {
  await launchUrl(Uri.parse(t.links.root + t.links.tips));
}

void openFeedbackSite() async {
  await launchUrl(Uri.parse(t.links.root + t.links.privacy));
}

void contactViaTwitter() async {
  await launchUrl(Uri.parse(twitterLink));
}

void visitDiscord() async {
  await launchUrl(Uri.parse(discordLink));
}

void visitReddit() async {
  await launchUrl(Uri.parse(redditLink));
}

void contactViaWeChat(BuildContext context) async {
  Clipboard.setData(const ClipboardData(text: supportWeChat));
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(t.dialog.contact.wechatCopied)));
}

void contactViaRED(BuildContext context) async {
  Clipboard.setData(const ClipboardData(text: officialRED));
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(t.dialog.contact.redCopied)));
}

void contactViaEmailAddress(BuildContext context) async {
  Clipboard.setData(const ClipboardData(text: supportEmail));
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(t.dialog.contact.emailCopied)));
}

void support(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return CustomBottomSheet(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TipCard(
              variant: 'info',
              text: t.dialog.contact.replayTime,
            ),
            ListTile(
              title: Text(t.dialog.contact.wechat),
              onTap: () {
                contactViaWeChat(context);
                Navigator.pop(context);
              },
              subtitle: const Text("ID: $supportWeChat"),
              trailing: const FaIcon(
                FontAwesomeIcons.weixin,
                color: Colors.green,
              ),
            ),
            ListTile(
              title: Text(t.dialog.contact.red),
              onTap: () {
                contactViaRED(context);
                Navigator.pop(context);
              },
              subtitle: const Text("ID: $officialRED"),
              trailing: const FaIcon(
                FontAwesomeIcons.link,
                color: Colors.red,
              ),
            ),
            ListTile(
              title: Text(t.general.email),
              subtitle: const Text(supportEmail),
              onTap: () {
                contactViaEmailAddress(context);
                Navigator.pop(context);
              },
              trailing: const Icon(Icons.email),
            ),
          ],
        ),
      );
    },
  );
}
