class DeliveryProcess {
  final String? processName;
  final String? processInfo;
  final String? processDate;
  final bool? isDone;
  final bool? inProgress;

  DeliveryProcess(
      {this.processDate,
      this.processName,
      this.processInfo,
      this.inProgress,
      this.isDone});

  static final List<DeliveryProcess> delivery = [
    DeliveryProcess(
      processName: 'Delivered',
      processInfo: 'Product has been delivered.',
      processDate: 'Mar 19 12.20',
      isDone: false,
      inProgress: false,
    ),
    DeliveryProcess(
      processName: 'Way to Deliver',
      processInfo: 'Product is currently out for delivery.',
      processDate: 'Mar 19 12.20',
      isDone: true,
      inProgress: true,
    ),
    DeliveryProcess(
      processName: 'Product Shipped',
      processInfo: 'Product has been shipped by Amazcart-BD',
      processDate: 'Mar 19 12.20',
      isDone: true,
      inProgress: false,
    ),
    DeliveryProcess(
      processName: 'Product Processing',
      processInfo: 'Product is processing as your order.',
      processDate: 'Mar 19 12.20',
      isDone: true,
      inProgress: false,
    ),
    DeliveryProcess(
      processName: 'Order Received',
      processInfo: 'We received your order.',
      processDate: 'Mar 19 12.20',
      isDone: true,
      inProgress: false,
    ),
  ];
}
