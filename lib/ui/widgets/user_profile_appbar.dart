import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app4/data/models/auth_utility.dart';
import 'package:mobile_app4/ui/screens/auth/login_screen.dart';
import 'package:mobile_app4/ui/screens/update_profile.dart';

class UserProfileAppBar extends StatefulWidget {
  final bool? isUpdateScreen;

  const UserProfileAppBar({
    super.key,
    this.isUpdateScreen,
  });

  @override
  State<UserProfileAppBar> createState() => _UserProfileAppBarState();
}

class _UserProfileAppBarState extends State<UserProfileAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: () {
          if ((widget.isUpdateScreen ?? false) == false) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UpdateProfileScreen()));
          }
        },
        child: Row(
          children: [
        Row(
        children: [
        ClipOval(
        child: Container(
          color: Colors.white,
          child: CachedNetworkImage(
            placeholder: (_, __) =>
                Image.asset('assets/images/1916172.jpg', width: 30),
            imageUrl: AuthUtility.userInfo.data?.photo ?? '',
            errorWidget: (_, __, ___) =>
                Image.asset('assets/images/1916172.jpg', width: 30),
          ),
        ),
      ),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AuthUtility.userInfo.data?.firstName ?? ''} ${AuthUtility.userInfo.data?.lastName ?? ''}',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                Text(
                  AuthUtility.userInfo.data?.email ?? 'Unknown',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            await AuthUtility.clearUserInfo();
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false);
            }
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }
}