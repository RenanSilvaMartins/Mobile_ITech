import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> serviceData;

  const PaymentScreen({Key? key, required this.serviceData}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = 'credit_card';
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Pagamento',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumo do pedido
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumo do Pedido',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Serviço:', style: TextStyle(color: Colors.grey[600])),
                      Text(widget.serviceData['service'] ?? 'N/A'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Técnico:', style: TextStyle(color: Colors.grey[600])),
                      Text(widget.serviceData['technician'] ?? 'N/A'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Urgência:', style: TextStyle(color: Colors.grey[600])),
                      Text(widget.serviceData['urgency'] ?? 'N/A'),
                    ],
                  ),
                  Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      Text(
                        'R\$ ${widget.serviceData['total']?.toStringAsFixed(2) ?? '0.00'}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Métodos de pagamento
            Text(
              'Método de Pagamento',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12),
            _PaymentMethodOption(
              title: 'Cartão de Crédito',
              subtitle: 'Visa, Mastercard, Elo',
              icon: Icons.credit_card,
              value: 'credit_card',
              groupValue: selectedPaymentMethod,
              onChanged: (value) => setState(() => selectedPaymentMethod = value!),
            ),
            _PaymentMethodOption(
              title: 'PIX',
              subtitle: 'Pagamento instantâneo',
              icon: Icons.qr_code,
              value: 'pix',
              groupValue: selectedPaymentMethod,
              onChanged: (value) => setState(() => selectedPaymentMethod = value!),
            ),
            _PaymentMethodOption(
              title: 'Dinheiro',
              subtitle: 'Pagamento na entrega',
              icon: Icons.money,
              value: 'cash',
              groupValue: selectedPaymentMethod,
              onChanged: (value) => setState(() => selectedPaymentMethod = value!),
            ),
            SizedBox(height: 24),

            // Formulário do cartão (se selecionado)
            if (selectedPaymentMethod == 'credit_card') ...[
              Text(
                'Dados do Cartão',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _cardHolderController,
                decoration: InputDecoration(
                  labelText: 'Nome no Cartão',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Número do Cartão',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _expiryController,
                      decoration: InputDecoration(
                        labelText: 'MM/AA',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _cvvController,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
            ],

            // QR Code PIX (se selecionado)
            if (selectedPaymentMethod == 'pix') ...[
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.qr_code, size: 120, color: Colors.grey[400]),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Escaneie o QR Code com seu app de pagamento',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
            ],

            // Informação sobre pagamento em dinheiro
            if (selectedPaymentMethod == 'cash') ...[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.orange[600]),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'O pagamento será realizado diretamente com o técnico no momento do atendimento.',
                        style: TextStyle(color: Colors.orange[800]),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _processPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPurple,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            selectedPaymentMethod == 'cash' 
                ? 'Confirmar Pedido' 
                : 'Processar Pagamento',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _processPayment() {
    // Validações básicas
    if (selectedPaymentMethod == 'credit_card') {
      if (_cardNumberController.text.isEmpty ||
          _expiryController.text.isEmpty ||
          _cvvController.text.isEmpty ||
          _cardHolderController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Preencha todos os dados do cartão')),
        );
        return;
      }
    }

    // Simular processamento
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Processando pagamento...'),
          ],
        ),
      ),
    );

    // Simular delay de processamento
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Fechar dialog de loading
      
      // Mostrar sucesso
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Sucesso!'),
            ],
          ),
          content: Text('Pagamento processado com sucesso. Seu pedido foi confirmado!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }
}

class _PaymentMethodOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _PaymentMethodOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value == groupValue ? AppColors.primaryPurple : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: RadioListTile<String>(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        secondary: Icon(icon, color: AppColors.primaryPurple),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: AppColors.primaryPurple,
      ),
    );
  }
}