import 'package:flutter/material.dart';
import 'dashboard_content.dart';
import 'placeholder_pages.dart';

class DashboardLayout extends StatefulWidget {
  const DashboardLayout({super.key});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardContent(),
    PracticePage(),
    AssessmentsPage(),
    ResourcesPage(),
    ProfilePage(),
  ];

  final List<String> _titles = const [
    'Dashboard',
    'Practice',
    'Assessments',
    'Resources',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            _buildSidebar(context),
          Expanded(
            child: Column(
              children: [
                _buildHeader(context, !isDesktop),
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: isDesktop ? null : Drawer(child: _buildSidebarContent(context)),
    );
  }

  Widget _buildHeader(BuildContext context, bool showMenuButton) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          if (showMenuButton)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          if (showMenuButton) const SizedBox(width: 8),
          Text(
            'Placement Prep',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          const Spacer(),
          const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: _buildSidebarContent(context),
    );
  }

  Widget _buildSidebarContent(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 64,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Icon(Icons.school, color: Theme.of(context).primaryColor, size: 28),
              const SizedBox(width: 12),
              Text(
                'PrepPlatform',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        const SizedBox(height: 16),
        _buildNavItem(0, 'Dashboard', Icons.dashboard_outlined),
        _buildNavItem(1, 'Practice', Icons.code),
        _buildNavItem(2, 'Assessments', Icons.assignment_outlined),
        _buildNavItem(3, 'Resources', Icons.library_books_outlined),
        _buildNavItem(4, 'Profile', Icons.person_outline),
      ],
    );
  }

  Widget _buildNavItem(int index, String title, IconData icon) {
    final isSelected = _selectedIndex == index;
    final primaryColor = Theme.of(context).primaryColor;

    return InkWell(
      onTap: () {
        setState(() => _selectedIndex = index);
        if (Scaffold.of(context).hasDrawer && Scaffold.of(context).isDrawerOpen) {
          Navigator.pop(context);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : Colors.grey[600],
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? primaryColor : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
