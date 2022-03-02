
/// Расширение, позволяющее получить символ валюты по ее коду
extension SymbolByCodeRetriever on List<CurrencyStaticInfo> {
  String getSymbolByCode(String code) {
    final index = indexWhere((e) => e.abbreviation == code);

    return index == -1 ? '' : this[index].symbol;
  }
}

/// Класс, содержащий неизменную информацию о всех доступных валютах 
abstract class CurrenciesStaticInfo {
  static const list = <CurrencyStaticInfo>[
    CurrencyStaticInfo(
      currency: 'Albania Lek',
      abbreviation: 'ALL',
      symbol: 'Lek',
    ),
    CurrencyStaticInfo(
      currency: 'Afghanistan Afghani',
      abbreviation: 'AFN',
      symbol: '؋',
    ),
    CurrencyStaticInfo(
      currency: 'Argentina Peso',
      abbreviation: 'ARS',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Aruba Guilder',
      abbreviation: 'AWG',
      symbol: 'ƒ',
    ),
    CurrencyStaticInfo(
      currency: 'Australia Dollar',
      abbreviation: 'AUD',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Azerbaijan New Manat',
      abbreviation: 'AZN',
      symbol: 'ман',
    ),
    CurrencyStaticInfo(
      currency: 'Bahamas Dollar',
      abbreviation: 'BSD',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Barbados Dollar',
      abbreviation: 'BBD',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Belarus Ruble',
      abbreviation: 'BYR',
      symbol: 'p.,',
    ),
    CurrencyStaticInfo(
      currency: 'Belize Dollar',
      abbreviation: 'BZD',
      symbol: r'BZ$,',
    ),
    CurrencyStaticInfo(
      currency: 'Bermuda Dollar',
      abbreviation: 'BMD',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Bolivia Boliviano',
      abbreviation: 'BOB',
      symbol: r'$b,',
    ),
    CurrencyStaticInfo(
      currency: 'Bosnia and Herzegovina Convertible Marka',
      abbreviation: 'BAM',
      symbol: 'KM',
    ),
    CurrencyStaticInfo(
      currency: 'Botswana Pula',
      abbreviation: 'BWP',
      symbol: 'P',
    ),
    CurrencyStaticInfo(
      currency: 'Bulgaria Lev',
      abbreviation: 'BGN',
      symbol: 'лв',
    ),
    CurrencyStaticInfo(
      currency: 'Brazil Real',
      abbreviation: 'BRL',
      symbol: r'R$,',
    ),
    CurrencyStaticInfo(
      currency: 'Brunei Darussalam Dollar',
      abbreviation: 'BND',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Cambodia Riel',
      abbreviation: 'KHR',
      symbol: '៛',
    ),
    CurrencyStaticInfo(
      currency: 'Canada Dollar',
      abbreviation: 'CAD',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Cayman Islands Dollar',
      abbreviation: 'KYD',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Chile Peso',
      abbreviation: 'CLP',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'China Yuan Renminbi',
      abbreviation: 'CNY',
      symbol: '¥',
    ),
    CurrencyStaticInfo(
      currency: 'Colombia Peso',
      abbreviation: 'COP',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Costa Rica Colon',
      abbreviation: 'CRC',
      symbol: '₡',
    ),
    CurrencyStaticInfo(
      currency: 'Croatia Kuna',
      abbreviation: 'HRK',
      symbol: 'kn',
    ),
    CurrencyStaticInfo(
      currency: 'Cuba Peso',
      abbreviation: 'CUP',
      symbol: '₱',
    ),
    CurrencyStaticInfo(
      currency: 'Czech Republic Koruna',
      abbreviation: 'CZK',
      symbol: 'Kč',
    ),
    CurrencyStaticInfo(
      currency: 'Denmark Krone',
      abbreviation: 'DKK',
      symbol: 'kr',
    ),
    CurrencyStaticInfo(
      currency: 'Dominican Republic Peso',
      abbreviation: 'DOP',
      symbol: r'RD$,',
    ),
    CurrencyStaticInfo(
      currency: 'East Caribbean Dollar',
      abbreviation: 'XCD',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Egypt Pound',
      abbreviation: 'EGP',
      symbol: '£',
    ),
    CurrencyStaticInfo(
      currency: 'El Salvador Colon',
      abbreviation: 'SVC',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Estonia Kroon',
      abbreviation: 'EEK',
      symbol: 'kr',
    ),
    CurrencyStaticInfo(
      currency: 'Euro Member Countries',
      abbreviation: 'EUR',
      symbol: '€',
    ),
    CurrencyStaticInfo(
      currency: 'Falkland Islands (Malvinas) Pound',
      abbreviation: 'FKP',
      symbol: '£',
    ),
    CurrencyStaticInfo(
      currency: 'Fiji Dollar',
      abbreviation: 'FJD',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Ghana Cedis',
      abbreviation: 'GHC',
      symbol: '¢',
    ),
    CurrencyStaticInfo(
      currency: 'Gibraltar Pound',
      abbreviation: 'GIP',
      symbol: '£',
    ),
    CurrencyStaticInfo(
      currency: 'Guatemala Quetzal',
      abbreviation: 'GTQ',
      symbol: 'Q',
    ),
    CurrencyStaticInfo(
      currency: 'Guernsey Pound',
      abbreviation: 'GGP',
      symbol: '£',
    ),
    CurrencyStaticInfo(
      currency: 'Guyana Dollar',
      abbreviation: 'GYD',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Honduras Lempira',
      abbreviation: 'HNL',
      symbol: 'L',
    ),
    CurrencyStaticInfo(
      currency: 'Hong Kong Dollar',
      abbreviation: 'HKD',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Hungary Forint',
      abbreviation: 'HUF',
      symbol: 'Ft',
    ),
    CurrencyStaticInfo(
      currency: 'Iceland Krona',
      abbreviation: 'ISK',
      symbol: 'kr',
    ),
    CurrencyStaticInfo(
      currency: 'India Rupee',
      abbreviation: 'INR',
      symbol: '',
    ),
    CurrencyStaticInfo(
      currency: 'Indonesia Rupiah',
      abbreviation: 'IDR',
      symbol: 'Rp',
    ),
    CurrencyStaticInfo(
      currency: 'Iran Rial',
      abbreviation: 'IRR',
      symbol: '﷼',
    ),
    CurrencyStaticInfo(
      currency: 'Isle of Man Pound',
      abbreviation: 'IMP',
      symbol: '£',
    ),
    CurrencyStaticInfo(
      currency: 'Israel Shekel',
      abbreviation: 'ILS',
      symbol: '₪',
    ),
    CurrencyStaticInfo(
      currency: 'Jamaica Dollar',
      abbreviation: 'JMD',
      symbol: r'J$,',
    ),
    CurrencyStaticInfo(
      currency: 'Japan Yen',
      abbreviation: 'JPY',
      symbol: '¥',
    ),
    CurrencyStaticInfo(
      currency: 'Jersey Pound',
      abbreviation: 'JEP',
      symbol: '£',
    ),
    CurrencyStaticInfo(
      currency: 'Kazakhstan Tenge',
      abbreviation: 'KZT',
      symbol: 'лв',
    ),
    CurrencyStaticInfo(
      currency: 'Korea (North) Won',
      abbreviation: 'KPW',
      symbol: '₩',
    ),
    CurrencyStaticInfo(
      currency: 'Korea (South) Won',
      abbreviation: 'KRW',
      symbol: '₩',
    ),
    CurrencyStaticInfo(
      currency: 'Kyrgyzstan Som',
      abbreviation: 'KGS',
      symbol: 'лв',
    ),
    CurrencyStaticInfo(
      currency: 'Laos Kip',
      abbreviation: 'LAK',
      symbol: '₭',
    ),
    CurrencyStaticInfo(
      currency: 'Latvia Lat',
      abbreviation: 'LVL',
      symbol: 'Ls',
    ),
    CurrencyStaticInfo(
      currency: 'Lebanon Pound',
      abbreviation: 'LBP',
      symbol: '£',
    ),
    CurrencyStaticInfo(
      currency: 'Liberia Dollar',
      abbreviation: 'LRD',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Lithuania Litas',
      abbreviation: 'LTL',
      symbol: 'Lt',
    ),
    CurrencyStaticInfo(
      currency: 'Macedonia Denar',
      abbreviation: 'MKD',
      symbol: 'ден',
    ),
    CurrencyStaticInfo(
      currency: 'Malaysia Ringgit',
      abbreviation: 'MYR',
      symbol: 'RM',
    ),
    CurrencyStaticInfo(
      currency: 'Mauritius Rupee',
      abbreviation: 'MUR',
      symbol: '₨',
    ),
    CurrencyStaticInfo(
      currency: 'Mexico Peso',
      abbreviation: 'MXN',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Mongolia Tughrik',
      abbreviation: 'MNT',
      symbol: '₮',
    ),
    CurrencyStaticInfo(
      currency: 'Mozambique Metical',
      abbreviation: 'MZN',
      symbol: 'MT',
    ),
    CurrencyStaticInfo(
      currency: 'Namibia Dollar',
      abbreviation: 'NAD',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Nepal Rupee',
      abbreviation: 'NPR',
      symbol: '₨',
    ),
    CurrencyStaticInfo(
      currency: 'Netherlands Antilles Guilder',
      abbreviation: 'ANG',
      symbol: 'ƒ',
    ),
    CurrencyStaticInfo(
      currency: 'New Zealand Dollar',
      abbreviation: 'NZD',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Nicaragua Cordoba',
      abbreviation: 'NIO',
      symbol: r'C$,',
    ),
    CurrencyStaticInfo(
      currency: 'Nigeria Naira',
      abbreviation: 'NGN',
      symbol: '₦',
    ),
    CurrencyStaticInfo(
      currency: 'Korea (North) Won',
      abbreviation: 'KPW',
      symbol: '₩',
    ),
    CurrencyStaticInfo(
      currency: 'Norway Krone',
      abbreviation: 'NOK',
      symbol: 'kr',
    ),
    CurrencyStaticInfo(
      currency: 'Oman Rial',
      abbreviation: 'OMR',
      symbol: '﷼',
    ),
    CurrencyStaticInfo(
      currency: 'Pakistan Rupee',
      abbreviation: 'PKR',
      symbol: '₨',
    ),
    CurrencyStaticInfo(
      currency: 'Panama Balboa',
      abbreviation: 'PAB',
      symbol: 'B/,.',
    ),
    CurrencyStaticInfo(
      currency: 'Paraguay Guarani',
      abbreviation: 'PYG',
      symbol: 'Gs',
    ),
    CurrencyStaticInfo(
      currency: 'Peru Nuevo Sol',
      abbreviation: 'PEN',
      symbol: 'S/,.',
    ),
    CurrencyStaticInfo(
      currency: 'Philippines Peso',
      abbreviation: 'PHP',
      symbol: '₱',
    ),
    CurrencyStaticInfo(
      currency: 'Poland Zloty',
      abbreviation: 'PLN',
      symbol: 'zł',
    ),
    CurrencyStaticInfo(
      currency: 'Qatar Riyal',
      abbreviation: 'QAR',
      symbol: '﷼',
    ),
    CurrencyStaticInfo(
      currency: 'Romania New Leu',
      abbreviation: 'RON',
      symbol: 'lei',
    ),
    CurrencyStaticInfo(
      currency: 'Russia Ruble',
      abbreviation: 'RUB',
      symbol: '₽',
    ),
    CurrencyStaticInfo(
      currency: 'Saint Helena Pound',
      abbreviation: 'SHP',
      symbol: '£',
    ),
    CurrencyStaticInfo(
      currency: 'Saudi Arabia Riyal',
      abbreviation: 'SAR',
      symbol: '﷼',
    ),
    CurrencyStaticInfo(
      currency: 'Serbia Dinar',
      abbreviation: 'RSD',
      symbol: 'Дин.,',
    ),
    CurrencyStaticInfo(
      currency: 'Seychelles Rupee',
      abbreviation: 'SCR',
      symbol: '₨',
    ),
    CurrencyStaticInfo(
      currency: 'Singapore Dollar',
      abbreviation: 'SGD',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Solomon Islands Dollar',
      abbreviation: 'SBD',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Somalia Shilling',
      abbreviation: 'SOS',
      symbol: 'S',
    ),
    CurrencyStaticInfo(
      currency: 'South Africa Rand',
      abbreviation: 'ZAR',
      symbol: 'R',
    ),
    CurrencyStaticInfo(
      currency: 'Korea (South) Won',
      abbreviation: 'KRW',
      symbol: '₩',
    ),
    CurrencyStaticInfo(
      currency: 'Sri Lanka Rupee',
      abbreviation: 'LKR',
      symbol: '₨',
    ),
    CurrencyStaticInfo(
      currency: 'Sweden Krona',
      abbreviation: 'SEK',
      symbol: 'kr',
    ),
    CurrencyStaticInfo(
      currency: 'Switzerland Franc',
      abbreviation: 'CHF',
      symbol: 'CHF',
    ),
    CurrencyStaticInfo(
      currency: 'Suriname Dollar',
      abbreviation: 'SRD',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Syria Pound',
      abbreviation: 'SYP',
      symbol: '£',
    ),
    CurrencyStaticInfo(
      currency: 'Taiwan New Dollar',
      abbreviation: 'TWD',
      symbol: r'NT$,',
    ),
    CurrencyStaticInfo(
      currency: 'Thailand Baht',
      abbreviation: 'THB',
      symbol: '฿',
    ),
    CurrencyStaticInfo(
      currency: 'Trinidad and Tobago Dollar',
      abbreviation: 'TTD',
      symbol: r'TT$,',
    ),
    CurrencyStaticInfo(
      currency: 'Turkey Lira',
      abbreviation: 'TRY',
      symbol: '',
    ),
    CurrencyStaticInfo(
      currency: 'Turkey Lira',
      abbreviation: 'TRL',
      symbol: '₤',
    ),
    CurrencyStaticInfo(
      currency: 'Tuvalu Dollar',
      abbreviation: 'TVD',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Ukraine Hryvna',
      abbreviation: 'UAH',
      symbol: '₴',
    ),
    CurrencyStaticInfo(
      currency: 'United Kingdom Pound',
      abbreviation: 'GBP',
      symbol: '£',
    ),
    CurrencyStaticInfo(
      currency: 'United States Dollar',
      abbreviation: 'USD',
      symbol: r'$',
    ),
    CurrencyStaticInfo(
      currency: 'Uruguay Peso',
      abbreviation: 'UYU',
      symbol: r'$U,',
    ),
    CurrencyStaticInfo(
      currency: 'Uzbekistan Som',
      abbreviation: 'UZS',
      symbol: 'лв',
    ),
    CurrencyStaticInfo(
      currency: 'Venezuela Bolivar',
      abbreviation: 'VEF',
      symbol: 'Bs',
    ),
    CurrencyStaticInfo(
      currency: 'Viet Nam Dong',
      abbreviation: 'VND',
      symbol: '₫',
    ),
    CurrencyStaticInfo(
      currency: 'Yemen Rial',
      abbreviation: 'YER',
      symbol: '﷼',
    ),
    CurrencyStaticInfo(
      currency: 'Zimbabwe Dollar',
      abbreviation: 'ZWD',
      symbol: r'Z$,',
    ),
  ];
}

/// Дата-класс, содержащий неизменную информацию о валюте
class CurrencyStaticInfo {
  final String currency;
  final String abbreviation;
  final String symbol;

  const CurrencyStaticInfo({
    required this.currency,
    required this.abbreviation,
    required this.symbol,
  });
}
