import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
 // FTile, FDivider etc.
import 'package:lucide_icons/lucide_icons.dart'; // Icons pack


class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  Widget buildExpandableTile({
    required IconData icon,
    required String text,
    required BuildContext context,
  }) {
    const int maxLines = 5;

  
    final double maxWidth = MediaQuery.of(context).size.width - 72; // padding আর icon স্পেস বাদ

    final span = TextSpan(
      text: text,
      style: const TextStyle(fontSize: 15, color: Colors.white),
    );

    final tp = TextPainter(
      text: span,
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: maxWidth);
    final isOverflowing = tp.didExceedMaxLines;

    if (!isOverflowing) {

      return ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          text,
          style: const TextStyle(fontSize: 15, color: Colors.white),
        ),
      );
    } else {
     
      return ListTile(
        leading: Icon(icon, color: Colors.white),
        title: RichText(
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            style: const TextStyle(fontSize: 15, color: Colors.white),
            children: [
              TextSpan(text: text),
              TextSpan(text: '... '),
              TextSpan(
                text: 'See more',
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Details"),
                        content: SingleChildScrollView(
                          child: Text(
                            text,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Close"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  },
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      backgroundColor: Colors.black87, // কালো background দিলে text সাদা সুন্দর লাগে
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Privacy Policy",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 16),
              buildExpandableTile(
                icon: LucideIcons.shield,
                text:
                    "Your privacy is very important to us. This Privacy Policy explains how we collect, use, and safeguard your information when you visit our mobile application.",
                context: context,
              ),
              const Divider(color: Colors.white54),
              buildExpandableTile(
                icon: LucideIcons.info,
                text:
                    "We collect information such as name, email, and usage data to improve your experience. We do not share your information with third parties without your consent.",
                context: context,
              ),
              const Divider(color: Colors.white54),
              buildExpandableTile(
                icon: LucideIcons.lock,
                text:
                    "We implement security measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction.",
                context: context,
              ),
              const Divider(color: Colors.white54),
              buildExpandableTile(
                icon: LucideIcons.refreshCw,
                text:
                    "This policy may be updated from time to time. We encourage you to review this Privacy Policy periodically to stay informed about how we are protecting your information.",
                context: context,
              ),
              const Divider(color: Colors.white54),
              buildExpandableTile(
                icon: LucideIcons.mail,
                text:
                    "If you have any questions or concerns about this Privacy Policy, please contact us at jakiajerin67@gmail.com.",
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}