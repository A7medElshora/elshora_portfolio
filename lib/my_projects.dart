import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'l10n/app_localizations.dart'; // تأكد من وجود ملف الترجمة

// تعريف نموذج Project المحدث
class Project {
  final String name;
  final String link;
  final List<String> imageAssets;

  Project({
    required this.name,
    this.link = '',
    required this.imageAssets,
  });

  String getDescription(AppLocalizations l10n) {
    switch (name) {
      case 'M3ahed.com':
        return l10n.m3ashedDescription;
      case 'El-Gahrib in Biology':
        return l10n.elGahribDescription;
      case 'CRM':
        return l10n.crmDescription;
      case 'Egy Health':
        return l10n.egyHealthDescription;
      default:
        return '';
    }
  }

  String getDetails(AppLocalizations l10n) {
    switch (name) {
      case 'M3ahed.com':
        return l10n.m3ashedDescription;
      case 'El-Gahrib in Biology':
        return l10n.elGahribDescription;
      case 'CRM':
        return l10n.crmDescription;
      case 'Egy Health':
        return l10n.egyHealthDescription;
      default:
        return '';
    }
  }
}

// قائمة المشاريع مع الصور
final projects = <Project>[
  Project(
    name: 'M3ahed.com',
    link: 'https://play.google.com/store/apps/details?id=com.muzamna.m3ahd&pli=1',
    imageAssets: [
      'assets/projects/m3ahed/img1.jpg',
      'assets/projects/m3ahed/img2.jpg',
      'assets/projects/m3ahed/img3.jpg',
    ],
  ),
  Project(
    name: 'El-Gahrib in Biology',
    imageAssets: [
      'assets/projects/elgahrib/img1.jpg',
      'assets/projects/elgahrib/img2.jpg',
    ],
  ),
  Project(
    name: 'CRM',
    imageAssets: [
      'assets/projects/crm/img1.jpg',
    ],
  ),
  Project(
    name: 'Egy Health',
    imageAssets: [
      'assets/projects/egyhealth/img1.jpg',
      'assets/projects/egyhealth/img2.jpg',
      'assets/projects/egyhealth/img3.jpg',
      'assets/projects/egyhealth/img4.jpg',
    ],
),
];

// الويدجت الرئيسي MyProjects
class MyProjects extends StatelessWidget {
  const MyProjects({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    int crossCount = screenWidth > 1200 ? 3 : screenWidth > 600 ? 2 : 1;

    return Container(
      padding: const EdgeInsets.all(32),
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF121212)
          : const Color(0xFFE8EAF6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.myProjectsTitle,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: screenWidth > 600 ? 32 : 24,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossCount,
              childAspectRatio: screenWidth > 600 ? 1.5 : 2.0,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: projects.length,
            itemBuilder: (context, i) => ProjectCard(project: projects[i]),
          ),
        ],
      ),
    );
  }
}

// ويدجت ProjectCard المحسنة
class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  void _showProjectDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProjectDetailsSheet(project: project),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => _showProjectDetails(context),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: screenWidth > 600 ? 24 : 20,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                project.getDescription(l10n),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth > 600 ? 18 : 16,
                      color: Colors.grey[700],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ويدجت Bottom Sheet الاحترافية
class ProjectDetailsSheet extends StatelessWidget {
  final Project project;

  const ProjectDetailsSheet({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: screenHeight * 0.8,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    project.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            if (project.imageAssets.isNotEmpty)
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                ),
                items: project.imageAssets.map((asset) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            asset,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                  child: Icon(Icons.broken_image, size: 50));
                            },
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                project.getDescription(l10n),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'projectDetails', // استخدم مفتاح الترجمة المناسب
                    // l10n.projectDetails,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ...project.getDetails(l10n).split('\n').map((line) => Text(line)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (project.link.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final uri = Uri.parse(project.link);
                    if (await canLaunchUrl(uri)) await launchUrl(uri);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l10n.viewProject),
                ),
              ),
          ],
        ),
      ),
    );
  }
}