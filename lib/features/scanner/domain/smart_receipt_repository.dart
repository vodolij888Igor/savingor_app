import 'package:savingor_app/features/scanner/domain/models/smart_receipt.dart';

abstract interface class SmartReceiptRepository {
  Future<SmartReceiptData> extract(SmartReceiptRequest request);
}
