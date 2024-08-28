import 'package:flutter/material.dart';
import 'package:todo_list_app/components/app_bar_component.dart';
import 'package:todo_list_app/components/detail_row_component.dart';
import 'package:todo_list_app/models/user.dart';

class ProfilePage extends StatelessWidget {
  final User? user;

  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Página de perfil', leading: false),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[100],
              radius: 50,
              child: user != null
                  ? Image.network(user!.image)
                  : const Icon(Icons.person),
            ),
            Text(
              '${user!.firstName} ${user!.lastName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              user!.email,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detalhes do Perfil',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  detailRow(label: 'ID: ', value: user!.id.toString()),
                  detailRow(label: 'Nome: ', value: user!.firstName),
                  detailRow(label: 'Email: ', value: user!.email),
                  detailRow(label: 'Sobrenome: ', value: user!.lastName),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
