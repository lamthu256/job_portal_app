import 'package:flutter/material.dart';
import 'package:job_portal_app/models/candidate.dart';
import 'package:job_portal_app/screens/recruiter/candidate_detail_screen.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/candidates/candidate_card.dart';

class CandidateListScreen extends StatefulWidget {
  final int totalCandidate;
  final List<Candidate> candidateList;
  final VoidCallback? onDataUpdated;

  const CandidateListScreen({
    super.key,
    required this.totalCandidate,
    required this.candidateList,
    this.onDataUpdated,
  });

  @override
  State<CandidateListScreen> createState() => _CandidateListScreenState();
}

class _CandidateListScreenState extends State<CandidateListScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // Fixed Header
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24, 4, 24, 18),
              child: Text(
                "Candidate List (${widget.totalCandidate})",
                style: textTheme.headlineSmall,
              ),
            ),
          ],
        ),
        // Scrollable List
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              widget.onDataUpdated?.call();
              await Future.delayed(Duration(seconds: 1));
            },
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
              children: [
                if (widget.candidateList.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text(
                        "No candidate found?",
                        style: textTheme.bodyLarge!.copyWith(
                          color: AppColors.hint,
                        ),
                      ),
                    ),
                  )
                else
                  ...widget.candidateList.map((can) {
                    return CandidateCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CandidateDetailScreen(candidateId: can.userId),
                          ),
                        );
                      },
                      avatar: can.avatarUrl != ""
                          ? NetworkImage(can.avatarUrl!)
                          : AssetImage("assets/default_avatar.png"),
                      name: can.fullName,
                      position: (can.jobTitle?.trim().isNotEmpty ?? false)
                          ? can.jobTitle!
                          : can.email ?? '',
                      location: can.location!,
                      applyCount: can.totalApplication!,
                    );
                  }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
