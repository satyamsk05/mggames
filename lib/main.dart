import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'webview_helper/webview_helper_stub.dart'
    if (dart.library.html) 'webview_helper/webview_helper_web.dart'
    if (dart.library.io) 'webview_helper/webview_helper_mobile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BC.Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF2F4F7),
        useMaterial3: true,
      ),
      home: const VirtualMobileFrame(
        child: BcGameDashboard(),
      ),
    );
  }
}

class VirtualMobileFrame extends StatelessWidget {
  final Widget child;

  const VirtualMobileFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 500) {
          return Scaffold(
            backgroundColor: const Color(0xFF191A1E), // Sleek dark canvas background
            body: Center(
              child: Container(
                width: 360,
                height: 804,
                margin: const EdgeInsets.symmetric(vertical: 24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(44.0),
                  border: Border.all(
                    color: const Color(0xFF2C2F36),
                    width: 12.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 40,
                      spreadRadius: 2,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32.0),
                  child: Stack(
                    children: [
                      // Main Screen content with custom padding injected
                      Positioned.fill(
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                            padding: const EdgeInsets.only(top: 36.0, bottom: 24.0),
                          ),
                          child: child,
                        ),
                      ),
                      
                      // Top Bar/Status Area
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0),
                          color: const Color(0xFFF2F4F7), // Match scaffoldBackgroundColor
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '9:41',
                                style: GoogleFonts.sourceSans3(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const Row(
                                children: [
                                  Icon(Icons.signal_cellular_4_bar, size: 13, color: Colors.black),
                                  SizedBox(width: 4),
                                  Icon(Icons.wifi, size: 13, color: Colors.black),
                                  SizedBox(width: 4),
                                  Icon(Icons.battery_full, size: 13, color: Colors.black),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Top Notch (Speaker/Camera notch)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: 130,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2C2F36),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(14),
                                bottomRight: Radius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Bottom Home Indicator
                      Positioned(
                        bottom: 6,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 120,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return child;
      },
    );
  }
}

class BcGameDashboard extends StatefulWidget {
  const BcGameDashboard({super.key});

  @override
  State<BcGameDashboard> createState() => _BcGameDashboardState();
}

class _BcGameDashboardState extends State<BcGameDashboard> {
  int _currentTabIndex = 0;
  late final TextEditingController _searchController;
  String _searchQuery = '';
  double _balance = 150.57;

  int _currentPromoPage = 0;
  late final PageController _promoPageController;
  Timer? _promoTimer;

  final List<Map<String, String>> _promoCards = [
    {
      'badge': 'DEPOSIT',
      'title': 'DEPOSIT BONUS\n180% BONUS',
      'subtitle': 'DEPOSIT -> GET BONUS',
      'image': 'assets/dashboard/banner.png',
      'buttonText': 'DEPOSIT NOW',
      'showCheck': 'true',
    },
    {
      'badge': 'EXCLUSIVE',
      'title': 'FREE SPINS\nGIVEAWAY',
      'subtitle': 'BET €10 · GET 20\nFREE SPINS',
      'image': 'assets/dashboard/promo_free_spins.png',
    },
    {
      'badge': 'NEW',
      'title': 'AFTERMATH',
      'subtitle': 'EXCLUSIVE NEW RELEASE',
      'image': 'assets/dashboard/promo_aftermath.png',
    },
    {
      'badge': 'NEW',
      'title': 'OOPS! ALL\nBURGER',
      'subtitle': 'EXCLUSIVE NEW RELEASE',
      'image': 'assets/dashboard/promo_all_burger.png',
    },
    {
      'badge': 'NEW',
      'title': 'PLAYNGO',
      'subtitle': 'NEW PROVIDER RELEASE',
      'image': 'assets/dashboard/promo_playngo.png',
    },
    {
      'badge': 'NEW',
      'title': 'TOOTHROT\nTILLY',
      'subtitle': 'EXCLUSIVE EARLY RELEASE',
      'image': 'assets/dashboard/promo_toothrot_tilly.png',
    },
  ];

  final List<String> _allGames = [
    'assets/images/DOUBLE.png',
    'assets/images/MINES.png',
    'assets/images/CRASH_OLD.png',
    'assets/images/CRASH.png',
    'assets/images/PLINKO.png',
    'assets/images/KENO.png',
    'assets/images/HILO.png',
    'assets/images/COINFLIP.png',
    'assets/images/DIAMONDS.png',
    'assets/images/BLACKJACK.png',
    'assets/images/ROULETTE.png',
    'assets/images/SLOTS.png',
    'assets/images/GAME_5B6E.png',
    'assets/images/GAME_5D92.png',
    'assets/images/GAME_62D1.png',
    'assets/images/GAME_67C3.png',
    'assets/images/GAME_6B95.png',
    'assets/images/GAME_7B00.png',
    'assets/images/GAME_804C.png',
    'assets/images/GAME_82A8.png',
    'assets/images/WHEEL.png',
    'assets/images/SICBO.png',
    'assets/images/GAME_9DCB.png',
    'assets/images/GAME_A08F.png',
    'assets/images/GAME_A7DB.png',
    'assets/images/GAME_AB5A.png',
    'assets/images/GAME_ABDF.png',
    'assets/images/GAME_ACF7.png',
    'assets/images/GAME_AFAD.png',
    'assets/images/GAME_B5D2.png',
    'assets/images/GAME_BDE5.png',
    'assets/images/GAME_D9E8.png',
    'assets/images/GAME_DC46.png',
    'assets/images/GAME_DC87.png',
    'assets/images/GAME_E13B.png',
    'assets/images/GAME_E73E.png',
    'assets/images/FAST_PARITY.png',
    'assets/images/GAME_F044.png',
    'assets/images/TOWER_LEGEND.png',
    'assets/images/GAME_FDBE.png',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _promoPageController = PageController();
    _promoTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_promoPageController.hasClients) {
        final nextPage = (_currentPromoPage + 1) % _promoCards.length;
        _promoPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _promoPageController.dispose();
    _promoTimer?.cancel();
    super.dispose();
  }

  String _getGameTitle(String path) {
    final filename = path.split('/').last.replaceAll('.png', '');
    if (filename == 'CRASH_OLD') return 'CRASH';
    if (filename == 'FAST_PARITY') return 'AVIATOR';
    return filename.replaceAll('_', ' ').toUpperCase();
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Promo banner card
          _buildPromoBanner(),
          
          // Page indicator dots under promo
          const SizedBox(height: 8),
          _buildPageIndicators(),
          
          // "Continue Playing" section header
          const SizedBox(height: 12),
          _buildContinuePlayingHeader(),
          
          // 3x2 Games Grid
          _buildGamesGrid(),
          
          // Horizontal Categories Row
          _buildCategoriesRow(),
          
          // Extra spacer at bottom
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBankTab() {
    final List<Map<String, dynamic>> transactions = [
      {'title': 'Game Bet (Double)', 'amount': -10.0, 'time': '10 minutes ago', 'type': 'bet'},
      {'title': 'Game Win (Plinko)', 'amount': 45.5, 'time': '32 minutes ago', 'type': 'win'},
      {'title': 'UPI Deposit Approved', 'amount': 100.0, 'time': '2 hours ago', 'type': 'deposit'},
      {'title': 'Game Bet (Wheel)', 'amount': -5.0, 'time': 'Yesterday', 'type': 'bet'},
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Secure Bank Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E2024), Color(0xFF2D3037)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL BALANCE',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF8A8F95),
                      ),
                    ),
                    const Icon(Icons.security, color: Color(0xFF2CD97E), size: 18),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '₹ ${_balance.toStringAsFixed(2)}',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    // Deposit Button
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2CD97E),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'DEPOSIT',
                            style: GoogleFonts.sourceSans3(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Withdraw Button
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const WithdrawScreen()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF4A4E5A), width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'WITHDRAW',
                            style: GoogleFonts.sourceSans3(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 2. SSL Security info banner
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E9EC), width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock, color: Color(0xFF595F67), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '256-Bit SSL Encrypted Transactions',
                    style: GoogleFonts.sourceSans3(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF595F67),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Transactions Header
          const SizedBox(height: 24),
          Text(
            'Recent Transactions',
            style: GoogleFonts.sourceSans3(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          
          // 4. Transaction List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              final bool isNegative = tx['amount'] < 0;
              final Color amountColor = isNegative ? Colors.black : const Color(0xFF2CD97E);
              final String sign = isNegative ? '-' : '+';
              final double absVal = (tx['amount'] as double).abs();
              
              IconData txIcon;
              Color iconBg;
              switch (tx['type']) {
                case 'win':
                  txIcon = Icons.arrow_downward;
                  iconBg = const Color(0xFFE8F9F0);
                  break;
                case 'deposit':
                  txIcon = Icons.add;
                  iconBg = const Color(0xFFE8F9F0);
                  break;
                default:
                  txIcon = Icons.arrow_upward;
                  iconBg = const Color(0xFFF2F4F7);
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E9EC), width: 1.0),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: iconBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(txIcon, size: 16, color: isNegative ? Colors.black : const Color(0xFF2CD97E)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx['title'],
                            style: GoogleFonts.sourceSans3(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            tx['time'],
                            style: GoogleFonts.sourceSans3(
                              fontSize: 11,
                              color: const Color(0xFF8A8F95),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '$sign₹${absVal.toStringAsFixed(2)}',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: amountColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGamesTab() {
    final List<String> filteredGames = _allGames.where((game) {
      final title = _getGameTitle(game);
      return title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        // Search Input container
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E9EC), width: 1.5),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.search, color: Color(0xFF595F67), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search games...',
                      hintStyle: GoogleFonts.sourceSans3(
                        fontSize: 14,
                        color: const Color(0xFF8A8F95),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: GoogleFonts.sourceSans3(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 18, color: Colors.black),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
        
        // Filter Category Chips (Pills)
        SizedBox(
          height: 32,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              _buildFilterChip('All Games', true),
              _buildFilterChip('Slots', false),
              _buildFilterChip('Live Casino', false),
              _buildFilterChip('BC Originals', false),
              _buildFilterChip('Table Games', false),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Games Grid
        Expanded(
          child: filteredGames.isEmpty
              ? Center(
                  child: Text(
                    'No games found',
                    style: GoogleFonts.sourceSans3(
                      fontSize: 16,
                      color: const Color(0xFF8A8F95),
                    ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 323 / 429,
                  ),
                  itemCount: filteredGames.length,
                  itemBuilder: (context, index) {
                    final double delayFraction = (index % 12) * 0.05; // Staggered delay wave
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 350 + (delayFraction * 800).toInt()),
                      curve: Curves.easeOutCubic,
                      builder: (context, animValue, animChild) {
                        return Opacity(
                          opacity: animValue,
                          child: Transform.translate(
                            offset: Offset(0.0, 40.0 * (1.0 - animValue)), // Slide up animation
                            child: animChild,
                          ),
                        );
                      },
                      child: GestureDetector(
                        onTap: () {
                          final String title = _getGameTitle(filteredGames[index]);
                          if (title == 'MINES') {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MinesGameScreen(
                                  currentBalance: _balance,
                                  onBalanceUpdated: (newBal) {
                                    setState(() {
                                      _balance = newBal;
                                    });
                                  },
                                ),
                              ),
                            );
                          } else if (title == 'CRASH') {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CrashGameScreen(
                                  currentBalance: _balance,
                                  onBalanceUpdated: (newBal) {
                                    setState(() {
                                      _balance = newBal;
                                    });
                                  },
                                ),
                              ),
                            );
                          } else if (title == 'AVIATOR') {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AviatorGameScreen(
                                  currentBalance: _balance,
                                  onBalanceUpdated: (newBal) {
                                    setState(() {
                                      _balance = newBal;
                                    });
                                  },
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Starting $title...'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              filteredGames[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2CD97E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.transparent : const Color(0xFFE5E9EC),
          width: 1.5,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.sourceSans3(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.black : const Color(0xFF595F67),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Account Security', 'subtitle': 'Password, 2FA, Security logs', 'icon': Icons.security},
      {'title': 'KYC Verification', 'subtitle': 'Verified successfully', 'icon': Icons.verified_user, 'badge': 'VERIFIED'},
      {'title': 'Refer & Earn', 'subtitle': 'Invite friends, earn passive income', 'icon': Icons.people},
      {'title': 'VIP Center', 'subtitle': 'Level 2 privileges', 'icon': Icons.emoji_events},
      {'title': 'Bet History', 'subtitle': 'Detailed log of your bets', 'icon': Icons.history},
      {'title': 'Customer Support', 'subtitle': '24/7 Live chat assistant', 'icon': Icons.headset_mic},
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 1. Profile Header
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF2CD97E), width: 2.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(
                    'assets/dashboard/avatar.png',
                    height: 64,
                    width: 64,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Satyam Kumar',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'UID: 84920194',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 12,
                        color: const Color(0xFF8A8F95),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF2CD97E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'VIP 2',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          
          // 2. VIP Progress Banner
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E9EC), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'VIP Level Progress',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF595F67),
                      ),
                    ),
                    Text(
                      '75%',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF2CD97E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: LinearProgressIndicator(
                    value: 0.75,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFF2F4F7),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2CD97E)),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '₹2,500.00 more to unlock VIP 3 privileges!',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 10,
                    color: const Color(0xFF8A8F95),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // 3. Action Menu list
          const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E9EC), width: 1.0),
                ),
                child: ListTile(
                  leading: Icon(item['icon'], color: const Color(0xFF595F67)),
                  title: Text(
                    item['title'],
                    style: GoogleFonts.sourceSans3(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    item['subtitle'],
                    style: GoogleFonts.sourceSans3(
                      fontSize: 11,
                      color: const Color(0xFF8A8F95),
                    ),
                  ),
                  trailing: item.containsKey('badge')
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F9F0),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            item['badge'],
                            style: GoogleFonts.sourceSans3(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2CD97E),
                            ),
                          ),
                        )
                      : const Icon(Icons.chevron_right, color: Color(0xFF8A8F95), size: 20),
                  onTap: () {
                    if (item['title'] == 'Bet History') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BetHistoryScreen()),
                      );
                    }
                  },
                ),
              );
            },
          ),
          
          // 4. Logout Button
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFF4D4D), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                foregroundColor: const Color(0xFFFF4D4D),
              ),
              child: Text(
                'LOG OUT',
                style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Custom AppBar/Header
            _buildHeader(),
            
            // Horizontal separator line under header (rectangle-8f9acf8bf923)
            Container(
              height: 1.5,
              color: const Color(0xFFDCDCDC),
            ),
            
            // Body Area (dynamically changes based on tab)
            Expanded(
              child: _buildBody(),
            ),
            
            // Custom Bottom Navigation Bar
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentTabIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildBankTab();
      case 2:
        return _buildGamesTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHeader() {
    return BcGameHeader(
      balance: _balance,
    );
  }

  Widget _buildPromoBanner() {
    return SizedBox(
      height: 170,
      child: PageView.builder(
        controller: _promoPageController,
        onPageChanged: (index) {
          setState(() {
            _currentPromoPage = index;
          });
        },
        itemCount: _promoCards.length,
        itemBuilder: (context, index) {
          final card = _promoCards[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E9EC), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // 1. Right side character artwork
                  Positioned(
                    right: 12,
                    top: 10,
                    bottom: 10,
                    width: 155,
                    child: Image.asset(
                      card['image']!,
                      fit: BoxFit.contain,
                      alignment: Alignment.centerRight,
                    ),
                  ),
                  // 2. Optional "Check >" overlay badge
                  if (card['showCheck'] == 'true')
                    Positioned(
                      right: 20,
                      bottom: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF133622).withValues(alpha: 0.75), // Translucent dark green
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Check',
                              style: GoogleFonts.sourceSans3(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  // 3. Left side text metadata & button
                  Positioned(
                    left: 16,
                    top: 12,
                    bottom: 12,
                    right: 175,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E9EC),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            card['badge']!,
                            style: GoogleFonts.sourceSans3(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Title
                        Text(
                          card['title']!,
                          style: GoogleFonts.sourceSans3(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Subtitle
                        Text(
                          card['subtitle']!,
                          style: GoogleFonts.sourceSans3(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF595F67),
                            height: 1.1,
                          ),
                        ),
                        const Spacer(),
                        // Dynamic Button
                        Container(
                          height: 28,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFE5E9EC), width: 1.5),
                          ),
                          child: Text(
                            card['buttonText'] ?? 'PLAY NOW',
                            style: GoogleFonts.sourceSans3(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF595F67),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_promoCards.length, (index) {
        final bool isActive = _currentPromoPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: isActive ? 16 : 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF2CD97E) : const Color(0xFFE5E9EC),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }

  Widget _buildContinuePlayingHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Continue Playing',
                style: GoogleFonts.sourceSans3(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              // Green underline indicator
              Container(
                height: 3,
                width: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF2CD97E),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            ],
          ),
          // "All" button (square layout matching Penpot CSS rectangle-8fbb38126532)
          GestureDetector(
            onTap: () {
              setState(() {
                _currentTabIndex = 2; // Switch to Games Tab
              });
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                'All',
                style: GoogleFonts.lalezar(
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamesGrid() {
    final List<String> gameAssets = [
      'assets/images/DOUBLE.png', // DOUBLE
      'assets/images/PLINKO.png', // PLINKO
      'assets/images/WHEEL.png', // WHEEL
      'assets/images/TOWER_LEGEND.png', // TOWER LEGEND
      'assets/images/SICBO.png', // SICBO
      'assets/images/FAST_PARITY.png', // FAST PARITY
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 323 / 429, // Mockup layout aspect ratio
        ),
        itemCount: gameAssets.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              final String title = _getGameTitle(gameAssets[index]);
              if (title == 'MINES') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MinesGameScreen(
                      currentBalance: _balance,
                      onBalanceUpdated: (newBal) {
                        setState(() {
                          _balance = newBal;
                        });
                      },
                    ),
                  ),
                );
              } else if (title == 'CRASH') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CrashGameScreen(
                      currentBalance: _balance,
                      onBalanceUpdated: (newBal) {
                        setState(() {
                          _balance = newBal;
                        });
                      },
                    ),
                  ),
                );
              } else if (title == 'AVIATOR') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AviatorGameScreen(
                      currentBalance: _balance,
                      onBalanceUpdated: (newBal) {
                        setState(() {
                          _balance = newBal;
                        });
                      },
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Starting $title...'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                   gameAssets[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoriesRow() {
    final List<Map<String, String>> categories = [
      {
        'image': 'assets/dashboard/poker.png',
        'label': 'POKER',
      },
      {
        'image': 'assets/dashboard/racing.png',
        'label': 'RACING',
      },
      {
        'image': 'assets/dashboard/lottery.png',
        'label': 'LOTTERY',
      },
      {
        'image': 'assets/dashboard/updown.png',
        'label': 'UPDOWN',
      },
      {
        'image': 'assets/dashboard/bingo.png',
        'label': 'BINGO',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(categories.length, (index) {
          final cat = categories[index];
          // Remove left margin from the first item, and right margin from the last item
          // to align perfectly with the left/right screen padding (16.0) of other cards/grids.
          final double leftMargin = index == 0 ? 0.0 : 4.0;
          final double rightMargin = index == categories.length - 1 ? 0.0 : 4.0;

          return Expanded(
            child: Container(
              margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
              // Height increased to 114 to accommodate larger layout
              height: 114,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 3D Category Image (Scaled up by 15%)
                  Image.asset(
                    cat['image']!,
                    height: 64,
                    width: 64,
                    fit: BoxFit.contain,
                  ),
                  // Category label (Scaled up by 15%)
                  Text(
                    cat['label']!,
                    style: GoogleFonts.sourceSans3(
                      fontWeight: FontWeight.w700,
                      fontSize: 10.5,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      // Height increased to 88 to avoid safe area layout overflows
      height: 88,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              label: 'Home',
              index: 0,
              customIcon: (color) => HomeSvgIcon(color: color),
            ),
            _buildNavItem(
              label: 'Bank',
              index: 1,
              customIcon: (color) => BankSvgIcon(color: color),
            ),
            _buildNavItem(
              label: 'Games',
              index: 2,
              customIcon: (color) => GameSvgIcon(color: color),
            ),
            _buildNavItem(
              label: 'Profile',
              index: 3,
              customIcon: (color) => ProfileSvgIcon(color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    String? assetPath,
    Widget Function(Color)? customIcon,
    required String label,
    required int index,
  }) {
    final bool isActive = _currentTabIndex == index;
    final Color color = isActive ? const Color(0xFF2CD97E) : Colors.black;
    return Bounceable(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 32,
              width: 32,
              child: customIcon != null
                  ? customIcon(color)
                  : Image.asset(
                      assetPath!,
                      height: 32,
                      width: 32,
                      color: color,
                    ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.lalezar(
                fontSize: 11,
                color: color,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Bounceable widget that scales down slightly when pressed (gives physical tap feedback)
class Bounceable extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const Bounceable({super.key, required this.child, required this.onTap});

  @override
  State<Bounceable> createState() => _BounceableState();
}

class _BounceableState extends State<Bounceable> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.92).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        ),
        child: widget.child,
      ),
    );
  }
}

class HomeSvgIcon extends StatelessWidget {
  final Color color;
  final double size;

  const HomeSvgIcon({
    super.key,
    required this.color,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _HomeSvgPainter(color: color),
    );
  }
}

class _HomeSvgPainter extends CustomPainter {
  final Color color;

  _HomeSvgPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / 24.0;
    final double scaleY = size.height / 24.0;
    
    canvas.save();
    canvas.scale(scaleX, scaleY);

    // Path 1: Outline/Roof (opacity 0.4)
    final Paint paint1 = Paint()
      ..color = color.withValues(alpha: 0.4 * color.a)
      ..style = PaintingStyle.fill;
    
    final Path path1 = Path()
      ..fillType = PathFillType.evenOdd
      ..moveTo(19.4991, 6.158)
      ..cubicTo(19.1361, 5.838, 18.7231, 5.476, 18.2311, 5.021)
      ..cubicTo(18.0081, 4.841, 17.7641, 4.635, 17.5051, 4.417)
      ..cubicTo(16.0451, 3.186, 14.0451, 1.5, 12.2221, 1.5)
      ..cubicTo(10.4201, 1.5, 8.54906, 3.092, 7.04606, 4.371)
      ..cubicTo(6.76806, 4.607, 6.50806, 4.829, 6.24306, 5.044)
      ..cubicTo(5.77706, 5.476, 5.36406, 5.839, 5.00006, 6.16)
      ..cubicTo(2.61306, 8.261, 2.16406, 8.812, 2.16406, 13.713)
      ..cubicTo(2.16406, 22.5, 4.70506, 22.5, 12.2501, 22.5)
      ..cubicTo(19.7941, 22.5, 22.3361, 22.5, 22.3361, 13.713)
      ..cubicTo(22.3361, 8.811, 21.8871, 8.26, 19.4991, 6.158)
      ..close();
    
    canvas.drawPath(path1, paint1);

    // Path 2: Inner horizontal bar (opacity 1.0)
    final Paint paint2 = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final Path path2 = Path()
      ..fillType = PathFillType.evenOdd
      ..moveTo(9.34277, 16.8848)
      ..lineTo(15.1578, 16.8848)
      ..cubicTo(15.5718, 16.8848, 15.9078, 16.5488, 15.9078, 16.1348)
      ..cubicTo(15.9078, 15.7208, 15.5718, 15.3848, 15.1578, 15.3848)
      ..lineTo(9.34277, 15.3848)
      ..cubicTo(8.92877, 15.3848, 8.59277, 15.7208, 8.59277, 16.1348)
      ..cubicTo(8.59277, 16.5488, 8.92877, 16.8848, 9.34277, 16.8848)
      ..close();
      
    canvas.drawPath(path2, paint2);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HomeSvgPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class ProfileSvgIcon extends StatelessWidget {
  final Color color;
  final double size;

  const ProfileSvgIcon({
    super.key,
    required this.color,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ProfileSvgPainter(color: color),
    );
  }
}

class _ProfileSvgPainter extends CustomPainter {
  final Color color;

  _ProfileSvgPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / 24.0;
    final double scaleY = size.height / 24.0;
    
    canvas.save();
    canvas.scale(scaleX, scaleY);
    
    // Apply translate(4, 2)
    canvas.translate(4.0, 2.0);

    // Path 1: Body/Shoulders (fill: color, opacity 1.0)
    // translated by (0, 13.175)
    canvas.save();
    canvas.translate(0.0, 13.175);
    final Paint paint1 = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    final Path path1 = Path()
      ..moveTo(8.0, 0.0)
      ..cubicTo(3.684, 0.0, 0.0, 0.68, 0.0, 3.4)
      ..cubicTo(0.0, 6.12, 3.661, 6.825, 8.0, 6.825)
      ..cubicTo(12.313, 6.825, 16.0, 6.146, 16.0, 3.4)
      ..cubicTo(16.0, 0.654, 12.334, 0.0, 8.0, 0.0)
      ..close();
      
    canvas.drawPath(path1, paint1);
    canvas.restore();

    // Path 2: Head (fill: color, opacity 0.4)
    // translated by (2.705, 0)
    canvas.save();
    canvas.translate(2.705, 0.0);
    final Paint paint2 = Paint()
      ..color = color.withValues(alpha: 0.4 * color.a)
      ..style = PaintingStyle.fill;
      
    final Path path2 = Path()
      ..addOval(Rect.fromLTWH(0, 0, 10.584, 10.584));
      
    canvas.drawPath(path2, paint2);
    canvas.restore();

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ProfileSvgPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class BankSvgIcon extends StatelessWidget {
  final Color color;
  final double size;

  const BankSvgIcon({
    super.key,
    required this.color,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _BankSvgPainter(color: color),
    );
  }
}

class _BankSvgPainter extends CustomPainter {
  final Color color;

  _BankSvgPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / 24.0;
    final double scaleY = size.height / 24.0;
    
    canvas.save();
    canvas.scale(scaleX, scaleY);

    // Path 1: Lid (solid color, opacity 1.0) - width set to 19.0 to align exactly with body
    final Paint lidPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    final RRect lidRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(2.5, 2.0, 19.0, 4.5),
      const Radius.circular(2.0),
    );
    canvas.drawRRect(lidRect, lidPaint);

    // Path 2: Body (opacity 0.4) with cutout handle slot
    final Paint bodyPaint = Paint()
      ..color = color.withValues(alpha: 0.4 * color.a)
      ..style = PaintingStyle.fill;
      
    final Path bodyPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(2.5, 8.0, 19.0, 14.0),
        const Radius.circular(3.5),
      ))
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(9.0, 12.0, 6.0, 2.5),
        const Radius.circular(1.25),
      ));
      
    canvas.drawPath(bodyPath, bodyPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BankSvgPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class GameSvgIcon extends StatelessWidget {
  final Color color;
  final double size;

  const GameSvgIcon({
    super.key,
    required this.color,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GameSvgPainter(color: color),
    );
  }
}

class _GameSvgPainter extends CustomPainter {
  final Color color;

  _GameSvgPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / 25.0;
    final double scaleY = size.height / 25.0;
    
    canvas.save();
    canvas.scale(scaleX, scaleY);

    // Path 1: Gamepad Body (opacity 0.4)
    final Paint bodyPaint = Paint()
      ..color = color.withValues(alpha: 0.4 * color.a)
      ..style = PaintingStyle.fill;
      
    final Path bodyPath = Path()
      ..moveTo(11.5322, 6.8893)
      ..cubicTo(4.66545, 7.02395, 2.2019, 9.14353, 2.2019, 14.7928)
      ..cubicTo(2.2019, 20.6348, 4.8319, 22.7068, 12.2509, 22.7068)
      ..cubicTo(19.6689, 22.7068, 22.2979, 20.6348, 22.2979, 14.7928)
      ..cubicTo(22.2979, 9.66871, 20.2766, 7.44581, 14.7773, 6.97644)
      ..cubicTo(13.661, 6.89936, 12.3561, 6.88476, 11.5322, 6.8893)
      ..close();
      
    canvas.drawPath(bodyPath, bodyPaint);

    // Path 2, 3, 4, 5: Wire, D-Pad, and Buttons (solid color, opacity 1.0)
    final Paint accentPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Wire Loop
    final Path wirePath = Path()
      ..moveTo(13.5843, 6.90392)
      ..lineTo(13.5843, 6.36092)
      ..cubicTo(13.5643, 4.85192, 12.3403, 3.59692, 10.8143, 3.64392)
      ..lineTo(9.79328, 3.64392)
      ..cubicTo(9.65028, 3.64392, 9.51528, 3.58892, 9.41328, 3.48892)
      ..cubicTo(9.30928, 3.38692, 9.25228, 3.25192, 9.25028, 3.10692)
      ..cubicTo(9.24628, 2.69192, 8.89028, 2.33892, 8.49328, 2.36392)
      ..cubicTo(8.07928, 2.36792, 7.74628, 2.70692, 7.75028, 3.12092)
      ..cubicTo(7.76128, 4.24092, 8.67528, 5.14392, 9.78628, 5.14392)
      ..lineTo(10.8283, 5.14392)
      ..cubicTo(11.5123, 5.14392, 12.0753, 5.69792, 12.0843, 6.37192)
      ..lineTo(12.0843, 6.88292)
      ..cubicTo(11.5631, 6.88521, 13.5843, 6.90392, 13.5843, 6.90392)
      ..close();
    canvas.drawPath(wirePath, accentPaint);

    // D-Pad
    final Path dpadPath = Path()
      ..moveTo(11.0652, 15.4978)
      ..lineTo(9.99124, 15.4978)
      ..lineTo(9.99124, 16.5358)
      ..cubicTo(9.99124, 16.9498, 9.65524, 17.2858, 9.24124, 17.2858)
      ..cubicTo(8.82724, 17.2858, 8.49124, 16.9498, 8.49124, 16.5358)
      ..lineTo(8.49124, 15.4978)
      ..lineTo(7.41724, 15.4978)
      ..cubicTo(7.00324, 15.4978, 6.66724, 15.1618, 6.66724, 14.7478)
      ..cubicTo(6.66724, 14.3338, 7.00324, 13.9978, 7.41724, 13.9978)
      ..lineTo(8.49124, 13.9978)
      ..lineTo(8.49124, 12.9598)
      ..cubicTo(8.49124, 12.5458, 8.82724, 12.2098, 9.24124, 12.2098)
      ..cubicTo(9.65524, 12.2098, 9.99124, 12.5458, 9.99124, 12.9598)
      ..lineTo(9.99124, 13.9978)
      ..lineTo(11.0652, 13.9978)
      ..cubicTo(11.4792, 13.9978, 11.8152, 14.3338, 11.8152, 14.7478)
      ..cubicTo(11.8152, 15.1618, 11.4792, 15.4978, 11.0652, 15.4978)
      ..close();
    canvas.drawPath(dpadPath, accentPaint);

    // Button 1
    final Path btn1Path = Path()
      ..moveTo(15.3612, 13.8188)
      ..lineTo(15.4632, 13.8188)
      ..cubicTo(15.8772, 13.8188, 16.2132, 13.4828, 16.2132, 13.0688)
      ..cubicTo(16.2132, 12.6548, 15.8772, 12.3188, 15.4632, 12.3188)
      ..lineTo(15.3612, 12.3188)
      ..cubicTo(14.9472, 12.3188, 14.6112, 12.6548, 14.6112, 13.0688)
      ..cubicTo(14.6112, 13.4828, 14.9472, 13.8188, 15.3612, 13.8188)
      ..close();
    canvas.drawPath(btn1Path, accentPaint);

    // Button 2
    final Path btn2Path = Path()
      ..moveTo(17.0922, 17.2308)
      ..lineTo(17.1942, 17.2308)
      ..cubicTo(17.6082, 17.2308, 17.9442, 16.8948, 17.9442, 16.4808)
      ..cubicTo(17.9442, 16.0668, 17.6082, 15.7308, 17.1942, 15.7308)
      ..lineTo(17.0922, 15.7308)
      ..cubicTo(16.6782, 15.7308, 16.3422, 16.0668, 16.3422, 16.4808)
      ..cubicTo(16.3422, 16.8948, 16.6782, 17.2308, 17.0922, 17.2308)
      ..close();
    canvas.drawPath(btn2Path, accentPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GameSvgPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

// -----------------------------------------------------------------------------
// MINES GAME SCREEN (HTML5 Webview Integration)
// -----------------------------------------------------------------------------
class MinesGameScreen extends StatefulWidget {
  final double currentBalance;
  final ValueChanged<double> onBalanceUpdated;

  const MinesGameScreen({
    super.key,
    required this.currentBalance,
    required this.onBalanceUpdated,
  });

  @override
  State<MinesGameScreen> createState() => _MinesGameScreenState();
}

class _MinesGameScreenState extends State<MinesGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF313738),
      body: SafeArea(
        child: buildMinesWebView(
          context,
          widget.currentBalance,
          widget.onBalanceUpdated,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// CRASH GAME SCREEN (HTML5 Webview Integration)
// -----------------------------------------------------------------------------
class CrashGameScreen extends StatefulWidget {
  final double currentBalance;
  final ValueChanged<double> onBalanceUpdated;

  const CrashGameScreen({
    super.key,
    required this.currentBalance,
    required this.onBalanceUpdated,
  });

  @override
  State<CrashGameScreen> createState() => _CrashGameScreenState();
}

class _CrashGameScreenState extends State<CrashGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2024),
      body: SafeArea(
        child: buildCrashWebView(
          context,
          widget.currentBalance,
          widget.onBalanceUpdated,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// AVIATOR GAME SCREEN (HTML5 Webview Integration)
// -----------------------------------------------------------------------------
class AviatorGameScreen extends StatefulWidget {
  final double currentBalance;
  final ValueChanged<double> onBalanceUpdated;

  const AviatorGameScreen({
    super.key,
    required this.currentBalance,
    required this.onBalanceUpdated,
  });

  @override
  State<AviatorGameScreen> createState() => _AviatorGameScreenState();
}

class _AviatorGameScreenState extends State<AviatorGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0B0C),
      body: SafeArea(
        child: buildAviatorWebView(
          context,
          widget.currentBalance,
          widget.onBalanceUpdated,
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// New Screens for Withdrawal and Bet History
// ----------------------------------------------------

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  int _selectedMethodIndex = 2; // UPI is selected by default in screenshot (index 2)
  final TextEditingController _upiIdController = TextEditingController(text: '7088800480-6.wallet@phonepe');
  final TextEditingController _nameController = TextEditingController(text: 'Satyam kumar');
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _amountController = TextEditingController(text: '0');

  final double _balance = 150.57;

  final List<Map<String, dynamic>> _methods = [
    {
      'name': 'Bank Transfer',
      'sub': 'ETA: 30 min',
      'logo': Icons.account_balance,
      'isBank': true,
    },
    {
      'name': 'BANK TRAN...',
      'sub': 'ETA: 30 min',
      'logo': Icons.account_balance,
      'isBank': true,
    },
    {
      'name': 'UPI',
      'sub': 'ETA: 30 min',
      'logo': Icons.payments,
      'isBank': false,
    },
    {
      'name': 'iCash.one',
      'sub': 'ETA: 1 min',
      'logo': Icons.wallet,
      'isBank': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selectedMethod = _methods[_selectedMethodIndex];
    final bool isUpi = selectedMethod['name'] == 'UPI';
    final bool isBank = selectedMethod['isBank'] == true;

    return VirtualMobileFrame(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F4F7),
        body: SafeArea(
          child: Column(
            children: [
              // Home-screen style header: balance pill + back button
              BcGameHeader(
                balance: _balance,
                isDark: false,
                hasBackButton: true,
                onBackTap: () => Navigator.pop(context),
              ),
              // Scrollable body
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E9EC), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                // 1. Currency
                Text(
                  'Currency',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF8A8F95),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E9EC), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE05C1F),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '₹',
                          style: GoogleFonts.sourceSans3(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'INR',
                        style: GoogleFonts.sourceSans3(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down, color: Colors.black),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                // 2. Withdraw Method
                Text(
                  'Withdraw Method',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF8A8F95),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Wrap Grid
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(_methods.length, (index) {
                    final method = _methods[index];
                    final isSelected = _selectedMethodIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMethodIndex = index;
                        });
                      },
                      child: Container(
                        width: (MediaQuery.of(context).size.width > 500 ? 328 - 32 - 20 : MediaQuery.of(context).size.width - 64 - 20) / 3,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFE8F9F0) : const Color(0xFFF2F4F7),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF2CD97E) : const Color(0xFFE5E9EC),
                            width: 1.5,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Logo icon box
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.02),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(method['logo'], size: 12, color: Colors.black),
                                      const SizedBox(width: 4),
                                      Text(
                                        method['name'] == 'UPI' ? 'UPI' : (method['name'] == 'iCash.one' ? 'ic' : 'BANK'),
                                        style: GoogleFonts.sourceSans3(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  method['name'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.sourceSans3(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  method['sub'],
                                  style: GoogleFonts.sourceSans3(
                                    fontSize: 9,
                                    color: const Color(0xFF8A8F95),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            if (isSelected)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2CD97E),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: const Icon(Icons.check, size: 8, color: Colors.black),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 20),
                
                // 3. Form fields dynamically based on selection
                if (isUpi) ...[
                  _buildLabel('UPI ID *'),
                  _buildInput(_upiIdController, 'Enter UPI ID'),
                  const SizedBox(height: 16),
                  _buildLabel('Account Holder Name *'),
                  _buildInput(_nameController, 'Enter name'),
                ] else if (isBank) ...[
                  _buildLabel('Account Holder Name *'),
                  _buildInput(_nameController, 'Enter name'),
                  const SizedBox(height: 16),
                  _buildLabel('Account *'),
                  _buildInput(_accountController, 'Enter Account Number'),
                  const SizedBox(height: 16),
                  _buildLabel('IFSC Code *'),
                  _buildInput(_ifscController, 'Enter IFSC Code'),
                ] else ...[
                  // iCash.one or other
                  _buildLabel('Account ID *'),
                  _buildInput(_accountController, 'Enter account ID'),
                ],

                const SizedBox(height: 20),
                
                // 4. Withdraw Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Withdraw Amount',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF8A8F95),
                      ),
                    ),
                    Text(
                      'Min: ₹420.00',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFF4D4D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildInput(_amountController, '0', keyboardType: TextInputType.number),
                
                const SizedBox(height: 12),
                
                // Min, 25%, 50%, Max buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPercentButton('Min', () {
                      _amountController.text = '420.00';
                    }),
                    _buildPercentButton('25%', () {
                      _amountController.text = (_balance * 0.25).toStringAsFixed(2);
                    }),
                    _buildPercentButton('50%', () {
                      _amountController.text = (_balance * 0.50).toStringAsFixed(2);
                    }),
                    _buildPercentButton('Max', () {
                      _amountController.text = _balance.toStringAsFixed(2);
                    }),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Available Balance
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Available: ₹${_balance.toStringAsFixed(2)}',
                    style: GoogleFonts.sourceSans3(
                      fontSize: 12,
                      color: const Color(0xFF595F67),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 5. Withdraw Submit button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2CD97E).withValues(alpha: 0.5), // Match screenshot light green
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Withdraw',
                      style: GoogleFonts.sourceSans3(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
              ],       // Column children (inside Container)
            ),         // Column
          ),           // Container
        ),             // SingleChildScrollView
      ),               // Expanded
    ],                 // outer Column children
  ),                   // outer Column
),                     // SafeArea
      ),               // Scaffold
    );                 // VirtualMobileFrame return
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.sourceSans3(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF8A8F95),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint, {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E9EC), width: 1.5),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.sourceSans3(color: const Color(0xFF8A8F95), fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: InputBorder.none,
          isDense: true,
        ),
        style: GoogleFonts.sourceSans3(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildPercentButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Text(
          label,
          style: GoogleFonts.sourceSans3(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF595F67),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    final double amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount < 420.00) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimum withdrawal amount is ₹420.00'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (amount > _balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insufficient balance'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Success Modal
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Request Submitted',
            style: GoogleFonts.sourceSans3(fontWeight: FontWeight.w900),
          ),
          content: Text(
            'Your withdrawal request of ₹$amount has been submitted successfully.\nETA: 30 minutes.',
            style: GoogleFonts.sourceSans3(fontWeight: FontWeight.w600),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Pop dialog
                Navigator.pop(context); // Pop screen
              },
              child: Text(
                'OK',
                style: GoogleFonts.sourceSans3(color: const Color(0xFF2CD97E), fontWeight: FontWeight.w900),
              ),
            ),
          ],
        );
      },
    );
  }
}

class BetHistoryScreen extends StatefulWidget {
  const BetHistoryScreen({super.key});

  @override
  State<BetHistoryScreen> createState() => _BetHistoryScreenState();
}

class _BetHistoryScreenState extends State<BetHistoryScreen> {
  String _selectedFilter1 = 'All';
  String _selectedFilter2 = 'All Assets';
  String _selectedFilter3 = 'Past 24 hours';

  final List<Map<String, dynamic>> _bets = [
    {'game': 'Plinko', 'time': '31/08/2026, 00:20:36', 'multiplier': '0.2x', 'wager': 10.0, 'win': false},
    {'game': 'Plinko', 'time': '31/08/2026, 00:20:36', 'multiplier': '0.2x', 'wager': 10.0, 'win': false},
    {'game': 'Plinko', 'time': '31/08/2026, 00:20:35', 'multiplier': '4x', 'wager': 20.0, 'win': true},
    {'game': 'Plinko', 'time': '31/08/2026, 00:20:35', 'multiplier': '0.2x', 'wager': 10.0, 'win': false},
    {'game': 'Plinko', 'time': '31/08/2026, 00:20:35', 'multiplier': '0.2x', 'wager': 15.0, 'win': false},
    {'game': 'Plinko', 'time': '31/08/2026, 00:20:35', 'multiplier': '0.2x', 'wager': 10.0, 'win': false},
    {'game': 'Plinko', 'time': '31/08/2026, 00:20:34', 'multiplier': '0.2x', 'wager': 10.0, 'win': false},
    {'game': 'Plinko', 'time': '31/08/2026, 00:20:34', 'multiplier': '0.2x', 'wager': 10.0, 'win': false},
    {'game': 'Plinko', 'time': '31/08/2026, 00:20:33', 'multiplier': '1.5x', 'wager': 30.0, 'win': true},
    {'game': 'Plinko', 'time': '31/08/2026, 00:20:32', 'multiplier': '0.2x', 'wager': 10.0, 'win': false},
  ];

  @override
  Widget build(BuildContext context) {
    return VirtualMobileFrame(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F4F7),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            'BetHistory',
            style: GoogleFonts.sourceSans3(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFF2F4F7),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.black, size: 18),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        body: Column(
          children: [
            // 1. Dropdown Filters
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // Row 1: All
                  _buildDropdownButton(_selectedFilter1, (val) {
                    setState(() {
                      _selectedFilter1 = val;
                    });
                  }, ['All', 'Wins', 'Losses', 'High Rollers']),
                  const SizedBox(height: 8),
                  // Row 2: All Assets & Past 24 hours
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownButton(_selectedFilter2, (val) {
                          setState(() {
                            _selectedFilter2 = val;
                          });
                        }, ['All Assets', 'INR', 'USDT']),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDropdownButton(_selectedFilter3, (val) {
                          setState(() {
                            _selectedFilter3 = val;
                          });
                        }, ['Past 24 hours', 'Past 7 days', 'All time']),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 2. Table Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Type',
                    style: GoogleFonts.sourceSans3(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8A8F95),
                    ),
                  ),
                  Text(
                    'Wager',
                    style: GoogleFonts.sourceSans3(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8A8F95),
                    ),
                  ),
                ],
              ),
            ),
            
            // Divider
            Container(
              height: 1.0,
              color: const Color(0xFFE5E9EC),
            ),
            
            // 3. Bets list
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: _bets.length,
                separatorBuilder: (context, index) => Container(
                  height: 1.0,
                  color: const Color(0xFFE5E9EC),
                ),
                itemBuilder: (context, index) {
                  final bet = _bets[index];


                  return Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left: Game & Timestamp
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bet['game'],
                              style: GoogleFonts.sourceSans3(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              bet['time'],
                              style: GoogleFonts.sourceSans3(
                                fontSize: 11,
                                color: const Color(0xFF8A8F95),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        // Right: Multiplier & Amount
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              bet['multiplier'],
                              style: GoogleFonts.sourceSans3(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '₹${(bet['wager'] as double).toStringAsFixed(2)}',
                                  style: GoogleFonts.sourceSans3(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFF4D4D), // All wagers are negative/lost or red in screenshots
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE05C1F),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '₹',
                                    style: GoogleFonts.sourceSans3(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownButton(String currentVal, ValueChanged<String> onChanged, List<String> options) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E9EC), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentVal,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 18),
          elevation: 4,
          style: GoogleFonts.sourceSans3(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class BcGameHeader extends StatelessWidget {
  final double balance;
  final bool isDark;
  final bool hasBackButton;
  final VoidCallback? onBackTap;

  const BcGameHeader({
    super.key,
    required this.balance,
    this.isDark = false,
    this.hasBackButton = false,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isDark ? const Color(0xFF1E2024) : Colors.transparent;
    final Color cardColor = isDark ? const Color(0xFF17181B) : Colors.white;
    final Color borderColor = isDark ? const Color(0xFF2F3136) : const Color(0xFFE5E9EC);
    final Color textColor = isDark ? Colors.white : Colors.black;

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Row(
        children: [
          if (hasBackButton) ...[
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black, size: 18),
              onPressed: onBackTap,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
          ],
          
          // Left logo/icon
          if (!isDark) ...[
            Image.asset(
              'assets/dashboard/logo.png',
              height: 28,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
          ],
          
          // Balance container
          Container(
            width: 181,
            height: 38,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor, width: 1.5),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 6),
                  Image.asset(
                    'assets/dashboard/rupee.png',
                    height: 20,
                    width: 20,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '₹ ${balance.toStringAsFixed(2)}',
                    style: GoogleFonts.sourceSans3(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  Bounceable(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Plus button clicked'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0, top: 3.0, bottom: 3.0),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2CD97E),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const Spacer(),
          
          // Gift button
          Bounceable(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gift button clicked'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor, width: 1.5),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              alignment: Alignment.center,
              child: Image.asset('assets/dashboard/gift.png', height: 24, width: 24, color: isDark ? const Color(0xFF8A8F95) : null),
            ),
          ),
          const SizedBox(width: 8),
          
          // Notification button
          Bounceable(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notification button clicked'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor, width: 1.5),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              alignment: Alignment.center,
              child: Image.asset('assets/dashboard/bell.png', height: 24, width: 24, color: isDark ? const Color(0xFF8A8F95) : null),
            ),
          ),
          const SizedBox(width: 8),
          
          // Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              'assets/dashboard/avatar.png',
              height: 36,
              width: 36,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class MineTile extends StatefulWidget {
  final bool isRevealed;
  final bool isMine;
  final VoidCallback onTap;
  final int index;

  const MineTile({
    super.key,
    required this.isRevealed,
    required this.isMine,
    required this.onTap,
    required this.index,
  });

  @override
  State<MineTile> createState() => _MineTileState();
}

class _MineTileState extends State<MineTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isRevealed) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: widget.isMine
            ? Image.asset(
                'assets/mine/Image.png',
                key: ValueKey('mine_${widget.index}'),
                fit: BoxFit.contain,
                errorBuilder: (ctx, err, stack) => const Icon(Icons.brightness_low, color: Colors.red),
              )
            : Container(
                key: ValueKey('gem_${widget.index}'),
                decoration: BoxDecoration(
                  color: const Color(0xFF5A3BC0), // Solid purple container box background
                  borderRadius: BorderRadius.circular(7.27),
                ),
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  'assets/mine/Container (1).png',
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, err, stack) => const Icon(Icons.diamond, color: Colors.white),
                ),
              ),
      );
    }

    // 3D Button style for unrevealed state
    final double offset = _isPressed ? 1.0 : 4.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Stack(
        children: [
          // 1. Shadow/Background layer (Bottom depth shadow)
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF202424), // Darker base shadow depth
              borderRadius: BorderRadius.circular(7.27),
            ),
          ),
          
          // 2. Front sliding layer
          AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            transform: Matrix4.translationValues(0, -offset, 0),
            decoration: BoxDecoration(
              color: const Color(0xFF444B4E), // Exact color from CSS style
              borderRadius: BorderRadius.circular(7.27),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 1,
                  offset: const Offset(0, 0.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
