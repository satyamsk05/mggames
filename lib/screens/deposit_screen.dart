import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DepositScreen extends StatefulWidget {
  final double currentBalance;
  final ValueChanged<double>? onBalanceUpdated;

  const DepositScreen({
    super.key,
    this.currentBalance = 150.57,
    this.onBalanceUpdated,
  });

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  late double _balance;
  int _selectedPreset = 500;
  final TextEditingController _amountController = TextEditingController(text: '500');
  bool _isSubmitting = false;

  final List<int> _presetAmounts = [100, 500, 1000, 2000, 5000, 10000];

  @override
  void initState() {
    super.initState();
    _balance = widget.currentBalance;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handleDeposit() {
    final double? amt = double.tryParse(_amountController.text.trim());
    if (amt == null || amt < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Minimum deposit amount is ₹100.00',
            style: GoogleFonts.sourceSans3(fontWeight: FontWeight.w700),
          ),
          backgroundColor: const Color(0xFFE53935),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _balance += amt;
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
                'Deposit Successful',
                style: GoogleFonts.sourceSans3(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            '₹${amt.toStringAsFixed(2)} has been added to your wallet balance.',
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
          'Deposit Funds',
          style: GoogleFonts.sourceSans3(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        actions: [
          // Exact Home Screen Deposit Balance Pill Widget
          Container(
            margin: const EdgeInsets.only(right: 14, top: 8, bottom: 8),
            padding: const EdgeInsets.only(left: 8, right: 2, top: 2, bottom: 2),
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
                const SizedBox(width: 4),
                Text(
                  _balance.toStringAsFixed(2),
                  style: GoogleFonts.sourceSans3(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2CD97E),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 16,
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
            // Deposit Amount Header
            Text(
              'DEPOSIT AMOUNT',
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
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Quick Preset Amount Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.6,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _presetAmounts.length,
              itemBuilder: (ctx, idx) {
                final amt = _presetAmounts[idx];
                final bool isSelected = _selectedPreset == amt;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedPreset = amt;
                      _amountController.text = amt.toString();
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF2CD97E) : Colors.white,
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
                    alignment: Alignment.center,
                    child: Text(
                      '₹$amt',
                      style: GoogleFonts.sourceSans3(
                        color: isSelected ? Colors.black : const Color(0xFF1E2024),
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 28),

            // Deposit Action Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleDeposit,
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
                        'DEPOSIT NOW',
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
                  '256-Bit Encrypted Instant Deposit Guarantee',
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
}
