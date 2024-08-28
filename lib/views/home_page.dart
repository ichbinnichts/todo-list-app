import 'package:flutter/material.dart';
import 'package:todo_list_app/components/app_bar_component.dart';
import 'package:todo_list_app/controllers/access_controller.dart';
import 'package:todo_list_app/controllers/user_controller.dart';
import 'package:todo_list_app/models/user.dart';
import 'package:todo_list_app/views/profile_page.dart';
import 'package:todo_list_app/views/welcome_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  User? _loggedUser;

  @override
  void initState() {
    super.initState();
    _loadLoggedUser();
  }

  Future<void> _loadLoggedUser() async {
    User user = await UserController.instance.getUserByIdFromJwtToken();
    setState(() {
      _loggedUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Home',
        leading: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem(
                value: 'Perfil',
                child: Text('Perfil'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        user: _loggedUser,
                      ),
                    ),
                  );
                },
              ),
              PopupMenuItem(
                value: 'Sair',
                child: Text('Sair'),
                onTap: () {
                  AccessController.instance.logout().then((logout) {
                    if (logout) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomePage()));
                    }
                  });
                },
              )
            ],
            child: Padding(
              padding: const EdgeInsets.only(
                right: 8,
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: _loggedUser != null
                    ? Image.network(
                        _loggedUser!.image,
                      )
                    : const Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            label: 'Tarefas',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendário',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Configurações',
          ),
        ],
      ),
      body: [
        const Text('Tarefas'),
        const Text('Calendário'),
        const Text('Configurações')
      ][_selectedIndex],
    );
  }
}
