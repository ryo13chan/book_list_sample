import 'package:book_list_sample/edit_profile/edit_profile_page.dart';
import 'package:book_list_sample/mypage/my_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyModel>(
      create: (_) => MyModel()..fetchUser(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('マイページ'),
          actions: [
            Consumer<MyModel>(builder: (context, model, child) {
              return IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        model.name!,
                        model.description!,
                      ),
                    ),
                  );
                  model.fetchUser();
                },
                icon: const Icon(Icons.edit),
              );
            }),
          ],
        ),
        body: Center(
          child: Consumer<MyModel>(
            builder: (context, model, child) {
              return Stack(
                children: [
                  Column(
                    children: [
                      Text(
                        model.name ?? '名前',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(model.email ?? 'メールアドレスなし'),
                      Text(model.description ?? '自己紹介なし'),
                      TextButton(
                        onPressed: () async {
                          await model.logout();
                          Navigator.of(context).pop();
                        },
                        child: const Text('ログアウト'),
                      ),
                    ],
                  ),
                  if (model.isLoading)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
