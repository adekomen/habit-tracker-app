import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/habit_controller.dart';
import '../../models/habit.dart';
import '../../widgets/habit_card.dart';
import 'today_screen.dart';
import 'habits_screen.dart';
import 'tasks_screen.dart';
import 'categories_screen.dart';
import 'timer_screen.dart';
import 'progress_screen.dart';
import '../../controllers/category_controller.dart';
import 'category_selection_screen.dart';
import 'evaluation_type_screen.dart';
import 'habit_form_screen.dart';
import 'frequency_selection_screen.dart';
import 'date_and_reminder_screen.dart';
import 'setting_screen.dart';
import 'contact_sreen.dart';
import '../../services/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay = DateTime.now();
  int _selectedIndex = 0;
  late Future<List<Habit>> _habits;

  @override
  void initState() {
    super.initState();
    _refreshHabits();
  }

  Future<void> _refreshHabits() async {
    final habitController = Provider.of<HabitController>(context, listen: false);
    setState(() {
      _habits = habitController.getHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final habitController = Provider.of<HabitController>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        title: Text(
          _getFormattedDate(_selectedDay),
          style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.tune, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.brightness_6, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.calendar_today, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
            onPressed: () => _showCalendarDialog(context),
          ),
        ],
      ),
      drawer: _buildDrawer(themeProvider),
      body: Column(
        children: [
          _buildCalendarHeader(themeProvider),
          Expanded(
            child: FutureBuilder<List<Habit>>(
              future: _habits,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState(themeProvider);
                } else {
                  return _buildHabitList(snapshot.data!, themeProvider, _selectedDay);
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () => _showFloatingMenu(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(themeProvider),
    );
  }

  Widget _buildDrawer(ThemeProvider themeProvider) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.pink,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
            title: Text('Accueil', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              Navigator.pop(context); // Fermer le tiroir
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.timer, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
            title: Text('Timer', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              Navigator.pop(context); // Fermer le tiroir
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TimerScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.category, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
            title: Text('Catégories', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              Navigator.pop(context); // Fermer le tiroir
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
            title: Text('Paramètres', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              Navigator.pop(context); // Fermer le tiroir
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_support, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
            title: Text('Nous contacter', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              Navigator.pop(context); // Fermer le tiroir
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactScreen()));
            },
          ),
        ],
      ),
    );
  }

  String _getFormattedDate(DateTime date) {
    return "${['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'][date.weekday - 1]} ${date.day} ${['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'][date.month - 1]}";
  }

  Widget _buildCalendarHeader(ThemeProvider themeProvider) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          DateTime day = DateTime.now().add(Duration(days: index - 3));
          bool isSelected = isSameDay(_selectedDay, day);
          return GestureDetector(
            onTap: () => setState(() => _selectedDay = day),
            child: Container(
              width: 50,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.pink : (themeProvider.isDarkMode ? Colors.black : Colors.white),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: themeProvider.isDarkMode ? Colors.grey : Colors.black),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'][day.weekday - 1]}",
                    style: TextStyle(
                      color: isSelected ? Colors.white : (themeProvider.isDarkMode ? Colors.grey : Colors.black),
                    ),
                  ),
                  Text(
                    "${day.day}",
                    style: TextStyle(
                      color: isSelected ? Colors.white : (themeProvider.isDarkMode ? Colors.grey : Colors.black),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(ThemeProvider themeProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 100, color: themeProvider.isDarkMode ? Colors.grey : Colors.black),
          const SizedBox(height: 10),
          Text(
            "Aucune activité programmée",
            style: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Ajouter de nouvelles activités",
            style: TextStyle(
              color: themeProvider.isDarkMode ? Colors.grey : Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitList(List<Habit> habits, ThemeProvider themeProvider, DateTime selectedDate) {
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        Habit habit = habits[index];
        return HabitCard(
          habit: habit,
          date: selectedDate,
          onTap: () async {
            final habitController = Provider.of<HabitController>(context, listen: false);
            await habitController.toggleHabitCompletion(habit, selectedDate);
            _refreshHabits(); // Rafraîchir la liste des habitudes
          },
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(ThemeProvider themeProvider) {
    return BottomNavigationBar(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      selectedItemColor: Colors.pink,
      unselectedItemColor: themeProvider.isDarkMode ? Colors.grey : Colors.black,
      currentIndex: _selectedIndex,
      showUnselectedLabels: true,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Aujourd\'hui'),
        BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Habitudes'),
        BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tâches'),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Catégories'),
        BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TodayScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HabitsScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TasksScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CategoriesScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TimerScreen()),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProgressScreen()),
        );
        break;
    }
  }

  void _showCalendarDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Fuji 95% | 19:49',
                  style: TextStyle(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TableCalendar(
                  firstDay: DateTime.utc(2020, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _selectedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() => _selectedDay = selectedDay);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'FERMER',
                  style: TextStyle(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'AUJOURD\'HUI',
                  style: TextStyle(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFloatingMenu(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.add_circle, color: Colors.pink),
                title: Text(
                  'Ajouter une habitude',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Fermer le menu
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategorySelectionScreen(),
                    ),
                  ).then((_) {
                    _refreshHabits(); // Rafraîchir la liste des habitudes
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_box, color: Colors.blue),
                title: Text(
                  'Ajouter une tâche',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  // Ajouter une tâche
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.category, color: Colors.green),
                title: Text(
                  'Ajouter une catégorie',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  // Ajouter une catégorie
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}