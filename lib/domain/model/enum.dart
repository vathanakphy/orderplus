enum OrderStatus {
  queued,
  ready,
  cancelled,
}

enum PaymentStatus {
  unpaid,
  paid,
}

PaymentStatus? paymentStatusFromString(String value) {
  try {
    return PaymentStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase()
    );
  } catch (e) {
    return null;
  }
}
