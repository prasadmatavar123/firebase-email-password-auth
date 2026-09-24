import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'sign_in_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ============================================================
  // SIGN OUT
  // ============================================================

  Future<void> _signOut(BuildContext context) async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text(
            'Are you sure you want to sign out of your account?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );

    if (shouldSignOut != true) {
      return;
    }

    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
          (route) => false,
    );
  }

  // ============================================================
  // GET USER NAME
  // ============================================================

  String _getUserName(User? user) {
    if (user?.displayName != null &&
        user!.displayName!.trim().isNotEmpty) {
      return user.displayName!.trim();
    }

    if (user?.email != null && user!.email!.isNotEmpty) {
      return user.email!.split('@').first;
    }

    return 'User';
  }

  // ============================================================
  // GET AUTH PROVIDER
  // ============================================================

  String _getProvider(User? user) {
    if (user == null) {
      return 'Unknown';
    }

    for (final provider in user.providerData) {
      if (provider.providerId == 'google.com') {
        return 'Google Account';
      }

      if (provider.providerId == 'password') {
        return 'Email & Password';
      }
    }

    return 'Firebase Account';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    final String userName = _getUserName(user);
    final String userEmail = user?.email ?? 'No email available';
    final String provider = _getProvider(user);

    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 24,

        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            tooltip: 'Sign Out',
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout_rounded),
          ),

          const SizedBox(width: 12),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 900,
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,

                children: [

                  // ==================================================
                  // WELCOME SECTION
                  // ==================================================

                  Text(
                    'Welcome back, $userName 👋',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Here is an overview of your account.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                      color: colorScheme
                          .onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // PROFILE CARD
                  // ==================================================

                  Card(
                    elevation: 0,
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(20),

                      child: Row(
                        children: [

                          // USER AVATAR
                          CircleAvatar(
                            radius: 32,
                            backgroundColor:
                            colorScheme.primaryContainer,

                            backgroundImage:
                            user?.photoURL != null
                                ? NetworkImage(
                              user!.photoURL!,
                            )
                                : null,

                            child: user?.photoURL == null
                                ? Icon(
                              Icons.person_rounded,
                              size: 34,
                              color: colorScheme
                                  .onPrimaryContainer,
                            )
                                : null,
                          ),

                          const SizedBox(width: 16),

                          // USER DETAILS
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [

                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  userEmail,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Container(
                                  padding:
                                  const EdgeInsets
                                      .symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),

                                  decoration: BoxDecoration(
                                    color: colorScheme
                                        .secondaryContainer,
                                    borderRadius:
                                    BorderRadius.circular(
                                      20,
                                    ),
                                  ),

                                  child: Text(
                                    provider,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.w600,
                                      color: colorScheme
                                          .onSecondaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ==================================================
                  // ACCOUNT STATUS
                  // ==================================================

                  Card(
                    elevation: 0,

                    child: Padding(
                      padding: const EdgeInsets.all(20),

                      child: Row(
                        children: [

                          Container(
                            padding:
                            const EdgeInsets.all(12),

                            decoration: BoxDecoration(
                              color: Colors.green
                                  .withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.verified_user_rounded,
                              color: Colors.green,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [

                                const Text(
                                  'Account Status',
                                  style: TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  'Your account is active and secure.',
                                  style: TextStyle(
                                    color: colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // QUICK ACTIONS
                  // ==================================================

                  Text(
                    'Quick Actions',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  LayoutBuilder(
                    builder: (context, constraints) {

                      final bool isWide =
                          constraints.maxWidth >= 600;

                      return GridView.count(
                        crossAxisCount:
                        isWide ? 3 : 1,

                        shrinkWrap: true,

                        physics:
                        const NeverScrollableScrollPhysics(),

                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,

                        childAspectRatio:
                        isWide ? 1.5 : 3.5,

                        children: [

                          _QuickActionCard(
                            icon: Icons.person_outline_rounded,
                            title: 'Profile',
                            subtitle:
                            'View your profile',
                            onTap: () {},
                          ),

                          _QuickActionCard(
                            icon: Icons.security_rounded,
                            title: 'Security',
                            subtitle:
                            'Manage your account',
                            onTap: () {},
                          ),

                          _QuickActionCard(
                            icon: Icons.settings_outlined,
                            title: 'Settings',
                            subtitle:
                            'Application settings',
                            onTap: () {},
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // ==================================================
                  // ACCOUNT INFORMATION
                  // ==================================================

                  Text(
                    'Account Information',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Card(
                    elevation: 0,

                    child: Column(
                      children: [

                        _InfoTile(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          value: userEmail,
                        ),

                        const Divider(height: 1),

                        _InfoTile(
                          icon: Icons.login_rounded,
                          title: 'Login Method',
                          value: provider,
                        ),

                        const Divider(height: 1),

                        _InfoTile(
                          icon: Icons.verified_outlined,
                          title: 'Email Verified',
                          value: user?.emailVerified == true
                              ? 'Verified'
                              : 'Not Verified',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ==================================================
                  // SIGN OUT BUTTON
                  // ==================================================

                  SizedBox(
                    height: 52,

                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _signOut(context),

                      icon: const Icon(
                        Icons.logout_rounded,
                      ),

                      label: const Text(
                        'Sign Out',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // FOOTER
                  // ==================================================

                  Text(
                    'Firebase Auth App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme
                          .onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Secure authentication powered by Firebase',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// QUICK ACTION CARD
// ================================================================

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Card(
      elevation: 0,

      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: onTap,

        child: Padding(
          padding: const EdgeInsets.all(18),

          child: Row(
            children: [

              Container(
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius:
                  BorderRadius.circular(14),
                ),

                child: Icon(
                  icon,
                  color: colorScheme
                      .onPrimaryContainer,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// INFORMATION TILE
// ================================================================

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 6,
      ),

      leading: Container(
        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Icon(
          icon,
          size: 20,
        ),
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),

      subtitle: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}