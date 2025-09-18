import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../core/constants/app_colors.dart';
import 'home_screen.dart';
import '../../data/models/service_request_model.dart';
import '../../data/services/service_request_service.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> technician;
  final String service;
  final String urgency;
  final double totalPrice;
  final DateTime date;
  final TimeOfDay time;
  final String address;
  final String description;
  final String? agendamentoId;

  const PaymentScreen({
    Key? key,
    required this.technician,
    required this.service,
    required this.urgency,
    required this.totalPrice,
    required this.date,
    required this.time,
    required this.address,
    required this.description,
    this.agendamentoId,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = 'credit_card';
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Pagamento',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
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
              padding: EdgeInsets.all(20),
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 16),
                  _OrderItem('Técnico', widget.technician['name']),
                  _OrderItem('Serviço', widget.service),
                  _OrderItem('Urgência', widget.urgency),
                  _OrderItem('Data', '${widget.date.day}/${widget.date.month}/${widget.date.year}'),
                  _OrderItem('Horário', '${widget.time.hour.toString().padLeft(2, '0')}:${widget.time.minute.toString().padLeft(2, '0')}'),
                  Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        'R\$ ${widget.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
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

            // Método de pagamento
            Text(
              'Método de Pagamento',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _nameController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
                decoration: InputDecoration(
                  labelText: 'Nome no cartão',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _cardNumberController,
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: '#### #### #### ####',
                    filter: {'#': RegExp(r'[0-9]')},
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Número do cartão',
                  hintText: '1234 5678 9012 3456',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
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
                      inputFormatters: [
                        MaskTextInputFormatter(
                          mask: '##/##',
                          filter: {'#': RegExp(r'[0-9]')},
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Validade',
                        hintText: 'MM/AA',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
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
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        hintText: '123',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
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
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: QrImageView(
                        data: _generatePixData(),
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Escaneie o código com seu app do banco',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
            ],

            // Informações sobre pagamento em dinheiro
            if (selectedPaymentMethod == 'cash') ...[
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(Icons.info, color: Colors.orange, size: 32),
                    SizedBox(height: 12),
                    Text(
                      'Pagamento em Dinheiro',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'O pagamento será realizado diretamente com o técnico no momento do atendimento.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
            ],

            SizedBox(height: 100),
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
          onPressed: () => _processPayment(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPurple,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            selectedPaymentMethod == 'cash' ? 'Confirmar Pedido' : 'Finalizar Pagamento',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  String _generatePixData() {
    return 'PIX|${widget.totalPrice.toStringAsFixed(2)}|${widget.technician['name']}|${DateTime.now().millisecondsSinceEpoch}';
  }

  void _processPayment() async {
    // Simular processamento
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(color: AppColors.primaryPurple),
      ),
    );

    await Future.delayed(Duration(seconds: 2));

    // Salvar serviço na lista
    final serviceRequest = ServiceRequestModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      technicianName: widget.technician['name'],
      service: widget.service,
      urgency: widget.urgency,
      totalPrice: widget.totalPrice,
      date: widget.date,
      time: '${widget.time.hour.toString().padLeft(2, '0')}:${widget.time.minute.toString().padLeft(2, '0')}',
      address: widget.address,
      description: widget.description,
      paymentMethod: selectedPaymentMethod,
      status: 'Confirmado',
      createdAt: DateTime.now(),
    );
    
    ServiceRequestService.addServiceRequest(serviceRequest);

    Navigator.pop(context); // Remove loading
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (route) => false,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pedido confirmado com sucesso!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final String label;
  final String value;

  const _OrderItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
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
    final isSelected = value == groupValue;
    
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primaryPurple),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: AppColors.primaryPurple,
            ),
          ],
        ),
      ),
    );
  }
}