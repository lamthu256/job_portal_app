import 'package:flutter/material.dart';
import 'package:job_portal_app/models/job.dart';
import 'package:job_portal_app/models/recruiter.dart';
import 'package:job_portal_app/screens/candidate/company_screen.dart';
import 'package:job_portal_app/screens/candidate/job_detail_screen.dart';
import 'package:job_portal_app/screens/candidate/profile_screen.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/common/parse_location.dart';
import 'package:job_portal_app/widgets/home/company_card.dart';
import 'package:job_portal_app/widgets/home/lasted_job_card.dart';
import 'package:job_portal_app/widgets/home/featured_job_card.dart';
import 'package:job_portal_app/widgets/home/home_banner.dart';

class HomeScreen extends StatefulWidget {
  final String? avatarUrl;
  final String name;
  final List<Recruiter> recruiterList;
  final List<Job> featuredJobList;
  final List<Job> latestJobList;
  final VoidCallback onProfileUpdated;

  const HomeScreen({
    super.key,
    this.avatarUrl,
    required this.name,
    required this.recruiterList,
    required this.featuredJobList,
    required this.latestJobList,
    required this.onProfileUpdated,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            children: [
              // Greeting
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, ${widget.name}",
                          style: textTheme.headlineLarge,
                          maxLines: 1,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "We bring the best for you",
                          style: textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                            onProfileUpdated: widget.onProfileUpdated,
                          ),
                        ),
                      );

                      if (updated) {
                        widget.onProfileUpdated();
                      }
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: widget.avatarUrl != ""
                          ? NetworkImage(widget.avatarUrl!)
                          : AssetImage("assets/default_avatar.png"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Home Banner
              HomeBanner(),
              SizedBox(height: 24),

              // Top Companies
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Top Companies", style: textTheme.headlineMedium),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
              SizedBox(height: 24),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.recruiterList.map((recruiter) {
                    return GestureDetector(
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CompanyScreen(recruiterId: recruiter.userId),
                          ),
                        );
                        if (updated) {
                          widget.onProfileUpdated();
                        }
                      },
                      child: CompanyCard(
                        image: recruiter.logoUrl != ""
                            ? NetworkImage(recruiter.logoUrl!)
                            : AssetImage("assets/default_avatar.png"),
                        name: recruiter.companyName,
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 24),

              // Featured Job
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Featured Job", style: textTheme.headlineMedium),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
              SizedBox(height: 24),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.featuredJobList.map((job) {
                    return FeaturedJobCard(
                      logo: job.logoUrl != ""
                          ? NetworkImage(job.logoUrl!)
                          : AssetImage("assets/default_avatar.png"),
                      title: job.title,
                      company: job.companyName!,
                      rating: job.avgRating!,
                      location: parseLocation(job.workLocation!)['province']!,
                      jobType: job.jobType,
                      salary: job.salary!,
                      isSaved: job.isSaved,
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => JobDetailScreen(
                              jobId: job.id,
                              recruiterId: job.recruiterId,
                            ),
                          ),
                        );

                        if (updated) {
                          widget.onProfileUpdated();
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 24),

              // Latest Job
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Latest Job", style: textTheme.headlineMedium),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
              SizedBox(height: 24),

              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: widget.latestJobList.map((job) {
                    return LastedJobCard(
                      logo: job.logoUrl != ""
                          ? NetworkImage(job.logoUrl!)
                          : AssetImage("assets/default_avatar.png"),
                      title: job.title,
                      rating: job.avgRating!,
                      location: parseLocation(job.workLocation!)['province']!,
                      jobType: job.jobType,
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => JobDetailScreen(
                              jobId: job.id,
                              recruiterId: job.recruiterId,
                            ),
                          ),
                        );

                        if (updated) {
                          widget.onProfileUpdated();
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
