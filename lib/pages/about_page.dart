import 'package:flutter/material.dart';
import 'package:hgeology_app/widget/card_base.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import 'package:hgeology_app/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/utils/contact.dart';
import 'package:hgeology_app/widget/custom_constrained_box.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';

class Product {
  final String name;
  final String icon;
  final String url;

  Product(this.name, this.icon, this.url);
}

List<Product> products = [
  Product('Ygktool', 'assets/icons/products/ygktool.png',
      'https://www.ygktool.com'),
  Product('Balloner', 'assets/icons/products/balloner.png',
      'https://github.com/rivertwilight/balloner'),
  Product('I Didn\'t', 'assets/icons/products/i_didnt.png',
      'https://apps.apple.com/app/i-didn-t-not-a-habit-tracker/id6451407976?l=en-GB'),
];

final _body = '''
Welcome to ${t.appName},

Hello, I’m Rene, the founder of ClipMemo. I'm delighted you're here, joining a community dedicated to turning passive watching into active learning.

${t.appName} was born out of a simple realization: We consume hours of video content and podcasts every week, yet how much of it do we truly remember or understand? I envisioned an app that could make every minute count—whether you’re diving into professional courses, mastering a new language, or dissecting podcasts that spark your curiosity.

Why ClipMemo?

With ClipMemo, you can isolate the gems hidden in hours of media. Clip what matters, jot down your thoughts, and revisit them whenever you like. It’s designed to be as quick and straightforward as jotting a memo, yet robust enough to hold a wealth of insights.

What’s Next?

We’re constantly improving, guided by feedback from users like you. The Daily Review feature, for example, is a direct result of wanting to provide a structured learning journey for our community.

Join Us

This is just the beginning, and I’m thrilled to have you on this journey. Feel free to reach out with any thoughts, suggestions, or questions you might have.

To better learning and meaningful interactions,

Rene
Founder, ${t.appName}
'''
    .splitMapJoin(
  RegExp(r'^', multiLine: true),
  onMatch: (_) => '\n',
  onNonMatch: (n) => n.trim(),
);

class AboutPage extends ConsumerStatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends ConsumerState<AboutPage> {
  Widget _buildAboutCard() {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 60),
            const CircleAvatar(
              radius: 88.5, // For 177x177px size
              backgroundImage: AssetImage(
                  'assets/images/avatar.png'), // Put your avatar image in the assets/images folder
            ),
            const SizedBox(height: 20),
            Text(t.aboutPage.tagline, style: TextStyle(fontSize: 14)),
            Text(t.aboutPage.author,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.home_rounded,
                    size: 30,
                  ),
                  onPressed: () {
                    contactViaBlog();
                  },
                ),
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.twitter,
                  ), // Website icon
                  onPressed: () {
                    contactViaTwitter();
                  },
                ),
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.weixin,
                  ), // Website icon
                  onPressed: () {
                    contactViaWeChat(context);
                  }, // Add your website link here
                ),
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.github,
                  ), // Website icon
                  onPressed: () {
                    contactViaBlog();
                  }, // Add your website link here
                ),
                // IconButton(
                //   icon: const Icon(Icons.email_rounded), // Email icon
                //   onPressed: () {
                //     contactViaEmail();
                //   }, // Add your email action here
                // )
              ],
            ),
            const SizedBox(height: 20),
            Text(_body),
            const SizedBox(height: 20),
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("More Hand-crafted Apps & Games"),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: products
                              .map((product) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: InkWell(
                                    onTap: () => launch(product.url),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              15), // adjust radius as needed
                                          child: Image(
                                            image: AssetImage(product.icon),
                                            height: 50,
                                          ),
                                        )

                                        // Text(product.name),
                                      ],
                                    ),
                                  )))
                              .toList(),
                        ),
                      )
                    ]),
              ),
            ),
            const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const LeadingBackButton(),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(t.aboutPage.title),
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: CustomConstrainedBox(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: SingleChildScrollView(
            child: Wrap(
              children: <Widget>[
                _buildAboutCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
