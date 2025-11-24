Map<String, String> parseLocation(String raw) {
  String province = '';
  String address = '';

  if (raw.contains(':')) {
    List<String> parts = raw.split(':');
    province = parts[0].trim();
    address = parts[1].trim();
  } else {
    // Nếu không có dấu ":", xem toàn bộ là city
    province = raw.trim();
  }

  return {
    'province': province,
    'address': address,
  };
}
