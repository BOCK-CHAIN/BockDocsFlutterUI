import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme_provider.dart';
import '../widgets/custom_widgets.dart'; // assuming you have DocumentCard and TemplateCard here

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // You can keep your existing documents list or replace with your service call

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.description, color: Theme.of(context).primaryColor, size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'BockDocs',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Theme.of(context).colorScheme.secondary),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.settings_outlined, color: Theme.of(context).colorScheme.secondary),
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.pushNamed(context, '/settings');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
            ],
          ),
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Text('U', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushReplacementNamed(context, '/login');
              } else if (value == 'profile') {
                Navigator.pushNamed(context, '/settings');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Text('Profile')),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: const Text('BockDocs', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: themeProvider.isDarkMode,
              onChanged: (val) => themeProvider.toggleTheme(),
              secondary: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Start a new document', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      TemplateCard(
                        icon: Icons.add,
                        label: 'Blank',
                        color: Theme.of(context).primaryColor,
                        onTap: () {
                          Navigator.pushNamed(context, '/editor', arguments: {'template': 'blank'});
                        },
                      ),
                      const SizedBox(width: 16),
                      TemplateCard(
                        icon: Icons.description_outlined,
                        label: 'Resume',
                        color: Colors.blue,
                        onTap: () {
                          Navigator.pushNamed(context, '/editor', arguments: {'template': 'resume'});
                        },
                      ),
                      const SizedBox(width: 16),
                      TemplateCard(
                        icon: Icons.article_outlined,
                        label: 'Letter',
                        color: Colors.green,
                        onTap: () {
                          Navigator.pushNamed(context, '/editor', arguments: {'template': 'letter'});
                        },
                      ),
                      const SizedBox(width: 16),
                      TemplateCard(
                        icon: Icons.file_present_outlined,
                        label: 'Report',
                        color: Colors.orange,
                        onTap: () {
                          Navigator.pushNamed(context, '/editor', arguments: {'template': 'report'});
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text('Recent documents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                // Add your DocumentCard list here or reuse your existing document list with updated widget
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/editor', arguments: {'template': 'blank'});
        },
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}