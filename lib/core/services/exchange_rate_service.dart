import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Cached FX quote for a currency pair.
class CachedExchangeRate {
  const CachedExchangeRate({
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.fetchedAt,
  });

  final String fromCurrency;
  final String toCurrency;
  final double rate;
  final DateTime fetchedAt;

  static CachedExchangeRate? fromPrefsJson(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final Map<String, dynamic> map =
          jsonDecode(raw) as Map<String, dynamic>;
      final double? rate = (map['rate'] as num?)?.toDouble();
      final String? fetchedAtRaw = map['fetchedAt'] as String?;
      if (rate == null || fetchedAtRaw == null) return null;
      final DateTime? fetchedAt = DateTime.tryParse(fetchedAtRaw);
      if (fetchedAt == null) return null;
      return CachedExchangeRate(
        fromCurrency: (map['from'] as String?) ?? '',
        toCurrency: (map['to'] as String?) ?? '',
        rate: rate,
        fetchedAt: fetchedAt,
      );
    } catch (_) {
      return null;
    }
  }

  String toPrefsJson() {
    return jsonEncode(<String, dynamic>{
      'from': fromCurrency,
      'to': toCurrency,
      'rate': rate,
      'fetchedAt': fetchedAt.toIso8601String(),
    });
  }
}

class ExchangeRateException implements Exception {
  const ExchangeRateException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Frankfurter v2 public exchange-rate API with local pair caching.
class ExchangeRateService {
  ExchangeRateService(this._prefs);

  final SharedPreferences _prefs;

  static const String _cacheKeyPrefix = 'savingor_fx_rate_';

  static String _pairKey(String from, String to) =>
      '${from.toUpperCase()}_${to.toUpperCase()}';

  CachedExchangeRate? getCachedRate({
    required String fromCurrency,
    required String toCurrency,
  }) {
    final String from = fromCurrency.toUpperCase();
    final String to = toCurrency.toUpperCase();
    if (from == to) {
      return CachedExchangeRate(
        fromCurrency: from,
        toCurrency: to,
        rate: 1.0,
        fetchedAt: DateTime.now(),
      );
    }
    final String? raw = _prefs.getString('$_cacheKeyPrefix${_pairKey(from, to)}');
    return CachedExchangeRate.fromPrefsJson(raw);
  }

  Future<double> getRate({
    required String fromCurrency,
    required String toCurrency,
  }) async {
    final String from = fromCurrency.toUpperCase();
    final String to = toCurrency.toUpperCase();
    if (from == to) return 1.0;

    try {
      final Uri uri = Uri.parse(
        'https://api.frankfurter.dev/v2/rate/$from/$to',
      );
      final http.Response response = await http.get(uri).timeout(
            const Duration(seconds: 12),
          );

      if (response.statusCode != 200) {
        throw ExchangeRateException(
          'Exchange rate request failed (${response.statusCode}).',
        );
      }

      final Object? decoded = jsonDecode(response.body);
      final double? rate = _parseRate(decoded);
      if (rate == null || !rate.isFinite || rate <= 0) {
        throw const ExchangeRateException('Invalid exchange rate response.');
      }

      await _cacheRate(
        fromCurrency: from,
        toCurrency: to,
        rate: rate,
        fetchedAt: DateTime.now(),
      );
      return rate;
    } catch (_) {
      final CachedExchangeRate? cached = getCachedRate(
        fromCurrency: from,
        toCurrency: to,
      );
      if (cached != null) {
        return cached.rate;
      }
      throw const ExchangeRateException(
        'Unable to update exchange rates. Please try again.',
      );
    }
  }

  Future<double> convert({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    final double rate = await getRate(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
    );
    return amount * rate;
  }

  Future<void> _cacheRate({
    required String fromCurrency,
    required String toCurrency,
    required double rate,
    required DateTime fetchedAt,
  }) async {
    final CachedExchangeRate cached = CachedExchangeRate(
      fromCurrency: fromCurrency.toUpperCase(),
      toCurrency: toCurrency.toUpperCase(),
      rate: rate,
      fetchedAt: fetchedAt,
    );
    await _prefs.setString(
      '$_cacheKeyPrefix${_pairKey(fromCurrency, toCurrency)}',
      cached.toPrefsJson(),
    );
  }

  static double? _parseRate(Object? decoded) {
    if (decoded is! Map<String, dynamic>) return null;

    final Object? direct = decoded['rate'];
    if (direct is num) return direct.toDouble();

    final Object? amount = decoded['amount'];
    final Object? rates = decoded['rates'];
    if (rates is Map<String, dynamic> && rates.length == 1) {
      final Object? quote = rates.values.first;
      if (quote is num) return quote.toDouble();
    }
    if (amount is num && rates is Map<String, dynamic> && rates.isNotEmpty) {
      final Object? quote = rates.values.first;
      if (quote is num) return quote.toDouble();
    }

    return null;
  }
}
