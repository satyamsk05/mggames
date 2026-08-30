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

  final List<String> _allGames = [
    'assets/images/01223589dc.png',
    'assets/images/0162b49865.png',
    'assets/images/288c627ac1.png',
    'assets/images/29d00e7a90.png',
    'assets/images/329847a6f1.png',
    'assets/images/33028991a5.png',
    'assets/images/35494eaa73.png',
    'assets/images/386dfafa24.png',
    'assets/images/3eb0992b2a.png',
    'assets/images/45d7b65e3b.png',
    'assets/images/4742cdf02e.png',
    'assets/images/4fc9f23427.png',
    'assets/images/5b6ef114f7.png',
    'assets/images/5d92e5b3fd.png',
    'assets/images/62d1118d59.png',
    'assets/images/67c3050209.png',
    'assets/images/6b95d47b98.png',
    'assets/images/7b00f807a6.png',
    'assets/images/804c78ad8e.png',
    'assets/images/82a8663c56.png',
    'assets/images/84ab11ed13.png',
    'assets/images/9d936aa67f.png',
    'assets/images/9dcbe909af.png',
    'assets/images/a08f537c90.png',
    'assets/images/a7dbc84cd4.png',
    'assets/images/ab5aef9177.png',
    'assets/images/abdf431e5b.png',
    'assets/images/acf7dad0dd.png',
    'assets/images/afadedf2e7.png',
    'assets/images/b5d25ed060.png',
    'assets/images/bde5e535a6.png',
    'assets/images/d9e8949bfe.png',
    'assets/images/dc463b0700.png',
    'assets/images/dc87252476.png',
    'assets/images/e13bba65c8.png',
    'assets/images/e73e8dc041.png',
    'assets/images/eadf095a9d.png',
    'assets/images/f0448b14ec.png',
    'assets/images/fa21392a55.png',
    'assets/images/fdbeb3e366.png',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getGameTitle(String path) {
    final filename = path.split('/').last.replaceAll('.png', '');
    switch (filename) {
      case '01223589dc': return 'DOUBLE';
      case '329847a6f1': return 'PLINKO';
      case '84ab11ed13': return 'WHEEL';
      case 'fa21392a55': return 'TOWER LEGEND';
      case '9d936aa67f': return 'SICBO';
      case 'eadf095a9d': return 'FAST PARITY';
      case '0162b49865': return 'MINES';
      case '288c627ac1': return 'CRASH';
      case '29d00e7a90': return 'LIMBO';
      case '33028991a5': return 'KENO';
      case '35494eaa73': return 'HILO';
      case '386dfafa24': return 'COINFLIP';
      case '3eb0992b2a': return 'DIAMONDS';
      case '45d7b65e3b': return 'BLACKJACK';
      case '4742cdf02e': return 'ROULETTE';
      case '4fc9f23427': return 'SLOTS';
      default:
        if (filename.length >= 4) {
          return 'GAME ${filename.substring(0, 4).toUpperCase()}';
        }
        return 'GAME';
    }
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
            padding: const EdgeInsets.all(20.0),
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
                          onPressed: () {},
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
                    'assets/33986f0f-8ac0-4fd9-b635-fc96293801b2.png',
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
                  onTap: () {},
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Row(
        children: [
          // BC.Game Logo (blob.png) (Smaller size to show white padding around it)
          Image.asset(
            'assets/blob.png',
            height: 28,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          // Currency Selector container (rectangle-8f978b99c3ab)
          Expanded(
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E9EC), width: 1.5),
                boxShadow: [
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
                  // Orange Rupee icon (INR.rect.png) (Centered and smaller to show the white layer behind it)
                  Image.asset(
                    'assets/INR.rect.png',
                    height: 20,
                    width: 20,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 5),
                  // Balance Text
                  Text(
                    '₹ ${_balance.toStringAsFixed(2)}',
                    style: GoogleFonts.sourceSans3(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  // Green Plus button (+) clickable with bounce/press animation
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
                          borderRadius: BorderRadius.circular(10),
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
          ),
          const SizedBox(width: 8),
          // Gift icon inside white square container (rectangle-8f990320e8ce) with bounce/press animation
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E9EC), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Image.asset('assets/svg-104.png', height: 24, width: 24),
            ),
          ),
          const SizedBox(width: 8),
          // Notification bell inside white square container (rectangle-8f99428e8ae4) with bounce/press animation
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E9EC), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Image.asset('assets/svg-106.png', height: 24, width: 24),
            ),
          ),
          const SizedBox(width: 8),
          // Circular Profile Avatar (33986f0f-8ac0-4fd9-b635-fc96293801b2.png)
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              'assets/33986f0f-8ac0-4fd9-b635-fc96293801b2.png',
              height: 36,
              width: 36,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      height: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 1. Vertical separator line in the middle
          Positioned(
            right: 180,
            top: 15,
            bottom: 15,
            width: 1.2,
            child: Container(
              color: const Color(0xFFE5E9EC),
            ),
          ),

          // 2. Right green wallet card illustration (floating with padding so the white card background is visible behind it)
          Positioned(
            right: 12,
            top: 10,
            bottom: 10,
            width: 160,
            child: Image.asset(
              'assets/bc-game-crypto-casino-games-casino-slot-games-crypto-gambling.image.monthly-CA-fqQod.Woblo.png',
              fit: BoxFit.contain,
            ),
          ),

          // 3. Left Column for text content and button (constrained to the left of the divider)
          Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            right: 195, // Guarantees spacing from the divider and image
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // DEPOSIT Badge (rectangle-8fb615257d24)
                Container(
                  width: 58,
                  height: 20, // Sized matching Penpot and increased 20%
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E9EC),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'DEPOSIT',
                    style: GoogleFonts.sourceSans3(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Banner Title
                Text(
                  'DEPOSIT BONUS',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    height: 1.15,
                  ),
                ),
                Text(
                  '180% BONUS',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 4),
                // Banner Subtitle
                Text(
                  'DEPOSIT -> GET BONUS',
                  style: GoogleFonts.sourceSans3(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF595F67),
                  ),
                ),
                const SizedBox(height: 12),
                // DEPOSIT NOW Button (rectangle-8fb59616114d)
                SizedBox(
                  width: 114,
                  height: 28, // Sized matching Penpot (87px raw -> 32px scaled)
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE7EEEF), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      'DEPOSIT NOW',
                      style: GoogleFonts.sourceSans3(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Active dot
        Container(
          width: 16,
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFF2CD97E),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        // Inactive dots
        ...List.generate(7, (index) => Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: const BoxDecoration(
            color: Color(0xFFE5E9EC),
            shape: BoxShape.circle,
          ),
        )),
      ],
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
      'assets/01223589dc.png', // DOUBLE
      'assets/329847a6f1.png', // PLINKO
      'assets/84ab11ed13.png', // WHEEL
      'assets/fa21392a55.png', // TOWER LEGEND
      'assets/9d936aa67f.png', // SICBO
      'assets/eadf095a9d.png', // FAST PARITY
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
            onTap: () {},
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
        'image': 'assets/image.png',
        'label': 'POKER',
      },
      {
        'image': 'assets/bc-game-crypto-casino-games-casino-slot-games-crypto-gambling.image.racing-DSbD1WV7.Woblo.png',
        'label': 'RACING',
      },
      {
        'image': 'assets/bc-game-crypto-casino-games-casino-slot-games-crypto-gambling.image.lottery-4fGTpStn.Woblo.png',
        'label': 'LOTTERY',
      },
      {
        'image': 'assets/bc-game-crypto-casino-games-casino-slot-games-crypto-gambling.image.updown-Cwd-AILh.Woblo.png',
        'label': 'UPDOWN',
      },
      {
        'image': 'assets/bc-game-crypto-casino-games-casino-slot-games-crypto-gambling.image.bingo-6_9NYc-6.Woblo.png',
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
              // Height increased by 20% to 104 (from 86)
              height: 104,
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
                  // 3D Category Image (Scaled proportionally to height)
                  Image.asset(
                    cat['image']!,
                    height: 56,
                    width: 56,
                    fit: BoxFit.contain,
                  ),
                  // Category label
                  Text(
                    cat['label']!,
                    style: GoogleFonts.sourceSans3(
                      fontWeight: FontWeight.w700,
                      fontSize: 9,
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
      backgroundColor: const Color(0xFF1E2024),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2024),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'MINES GAME',
          style: GoogleFonts.sourceSans3(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: buildMinesWebView(
        context,
        widget.currentBalance,
        widget.onBalanceUpdated,
      ),
    );
  }
}
