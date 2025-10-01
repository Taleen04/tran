import 'package:ai_transport/src/feature/home/domain/entities/location_status_entity.dart';
import 'package:flutter/material.dart';

class ServiceItem {
  final IconData icon;
  //final String label;
   bool isActive;
   final LocationStatusEnum status;
  final Color color;

  ServiceItem({
    required this.icon,
   // required this.label,
    required this.status,
    this.isActive = false,
    required this.color,
  });
}