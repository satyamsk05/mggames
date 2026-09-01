import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WithdrawScreen extends StatefulWidget {
  final double currentBalance;
  final ValueChanged<double>? onBalanceUpdated;

  const WithdrawScreen({
    super.key,
    this.currentBalance = 150.57,
    this.onBalanceUpdated,
  });

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  late double _balance;
  int _selectedMethodIndex = 0; // 0: UPI, 1: Bank Transfer

  final TextEditingController _amountController = TextEditingController(text: '500');
  final TextEditingController _upiIdController = TextEditingController(text: '7088800480-6.wallet@phonepe');
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _nameController = TextEditingController(text: 'Satyam Kumar');
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _methods = [
    {
      'name': 'UPI',
      'sub': 'ETA: 15-30 min',
      'logo': Icons.payments_rounded,
      'isBank': false,
    },
    {
      'name': 'Bank Transfer',
      'sub': 'ETA: 30 min',
      'logo': Icons.account_balance_rounded,
      'isBank': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _balance = widget.currentBalance;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _upiIdController.dispose();
    _accountController.dispose();
    _ifscController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _handleWithdrawal() {
    final double? amt = double.tryParse(_amountController.text.trim());
    if (amt == null || amt < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Minimum withdrawal amount is ₹100.00',
            style: GoogleFonts.sourceSans3(fontWeight: FontWeight.w700),
          ),
          backgroundColor: const Color(0xFFE53935),
        ),
      );
      return;
    }

    if (amt > _balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Insufficient balance for withdrawal',
            style: GoogleFonts.sourceSans3(fontWeight: FontWeight.w700),
          ),
          backgroundColor: const Color(0xFFE53935),
        ),
      );
      return;
    }

    final bool isBank = _methods[_selectedMethodIndex]['isBank'] == true;
    if (isBank) {
      if (_accountController.text.trim().isEmpty || _ifscController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please enter your Bank Account & IFSC Code',
              style: GoogleFonts.sourceSans3(fontWeight: FontWeight.w700),
            ),
            backgroundColor: const Color(0xFFE53935),
          ),
        );
        return;
      }
    } else {
      if (_upiIdController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please enter a valid UPI ID',
              style: GoogleFonts.sourceSans3(fontWeight: FontWeight.w700),
            ),
            backgroundColor: const Color(0xFFE53935),
          ),
        );
        return;
      }
    }

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _balance -= amt;
        _isSubmitting = false;
      });

      widget.onBalanceUpdated?.call(_balance);

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF2CD97E), size: 28),
              const SizedBox(width: 10),
              Text(
                'Withdrawal Requested',
                style: GoogleFonts.sourceSans3(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            'Your request to withdraw ₹${amt.toStringAsFixed(2)} has been submitted successfully.\nETA: 15-30 minutes.',
            style: GoogleFonts.sourceSans3(
              color: const Color(0xFF595F67),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2CD97E),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'OK',
                style: GoogleFonts.sourceSans3(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isBank = _methods[_selectedMethodIndex]['isBank'] == true;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F4F7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Withdrawal',
          style: GoogleFonts.sourceSans3(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        actions: [
          // Clean Balance Pill WITHOUT '+' Button (Right Aligned)
          Container(
            margin: const EdgeInsets.only(right: 14, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE5E9EC), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/dashboard/rupee.png',
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, err, stack) => const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Color(0xFF2CD97E),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _balance.toStringAsFixed(2),
                  style: GoogleFonts.sourceSans3(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Withdrawal Method Header
            Text(
              'WITHDRAWAL METHOD',
              style: GoogleFonts.sourceSans3(
                color: const Color(0xFF595F67),
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),

            // 50/50 Optimized Method Cards
            Row(
              children: List.generate(_methods.length, (idx) {
                final m = _methods[idx];
                final bool isSelected = idx == _selectedMethodIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedMethodIndex = idx),
                    child: Container(
                      margin: EdgeInsets.only(right: idx == 0 ? 10.0 : 0.0),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFE8F9F0) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF2CD97E) : const Color(0xFFE5E9EC),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            m['logo'] as IconData,
                            color: isSelected ? const Color(0xFF2CD97E) : Colors.black,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m['name'] as String,
                                  style: GoogleFonts.sourceSans3(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  m['sub'] as String,
                                  style: GoogleFonts.sourceSans3(
                                    color: const Color(0xFF8A8F95),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 18),

            // 2. Withdrawal Amount Section
            Text(
              'WITHDRAWAL AMOUNT',
              style: GoogleFonts.sourceSans3(
                color: const Color(0xFF595F67),
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),

            // Input Field Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E9EC), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Row(
                children: [
                  Text(
                    '₹',
                    style: GoogleFonts.sourceSans3(
                      color: const Color(0xFF2CD97E),
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.sourceSans3(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter amount',
                        hintStyle: TextStyle(color: Color(0xFF8A8F95)),
                      ),
                    ),
                  ),
                  // Max button on the right inside input box
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _amountController.text = _balance.toStringAsFixed(2);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F9F0),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF2CD97E), width: 1.5),
                      ),
                      child: Text(
                        'Max',
                        style: GoogleFonts.sourceSans3(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 3. Account Details Section
            Text(
              isBank ? 'BANK ACCOUNT DETAILS' : 'UPI DETAILS',
              style: GoogleFonts.sourceSans3(
                color: const Color(0xFF595F67),
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E9EC), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isBank) ...[
                    _buildLabel('Account Holder Name'),
                    _buildInputField(_nameController, 'e.g. Satyam Kumar'),
                    const SizedBox(height: 12),
                    _buildLabel('Bank Account Number'),
                    _buildInputField(_accountController, 'Enter Account Number', isNumber: true),
                    const SizedBox(height: 12),
                    _buildLabel('IFSC Code'),
                    _buildInputField(_ifscController, 'e.g. SBIN0001234'),
                  ] else ...[
                    _buildLabel('UPI ID'),
                    _buildInputField(_upiIdController, 'e.g. 7088800480@paytm'),
                    const SizedBox(height: 12),
                    _buildLabel('Account Holder Name'),
                    _buildInputField(_nameController, 'e.g. Satyam Kumar'),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4. Withdraw Action Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleWithdrawal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2CD97E),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 2,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5),
                      )
                    : Text(
                        'WITHDRAW NOW',
                        style: GoogleFonts.sourceSans3(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Security Badge Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_rounded, color: Color(0xFF595F67), size: 14),
                const SizedBox(width: 4),
                Text(
                  '256-Bit Encrypted Instant Withdrawal Guarantee',
                  style: GoogleFonts.sourceSans3(
                    color: const Color(0xFF595F67),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: GoogleFonts.sourceSans3(
          color: const Color(0xFF595F67),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint, {bool isNumber = false}) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E9EC)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: GoogleFonts.sourceSans3(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF8A8F95), fontSize: 13),
        ),
      ),
    );
  }
}
