import 'package:url_launcher/url_launcher.dart';

/// Delivery Service - Handles deep links for external delivery platforms
/// DoorDash and Uber Eats integration for home delivery option
class DeliveryService {
  // 🔧 Configure your store IDs from merchant portals
  static const String _doordashStoreId = 'parkandpick-montreal';

  /// Open DoorDash app with Park&Pick store, fallback to web
  static Future<bool> openDoorDash() async {
    // Deep link format for DoorDash
    final deepLink = Uri.parse('doordash://store/$_doordashStoreId');
    final webUrl =
        Uri.parse('https://www.doordash.com/store/$_doordashStoreId');

    try {
      if (await canLaunchUrl(deepLink)) {
        await launchUrl(deepLink);
        return true;
      } else {
        // Fallback to web browser
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
        return true;
      }
    } catch (e) {
      print('Error launching DoorDash: $e');
      return false;
    }
  }

  /// Open Uber Eats app with Park&Pick store, fallback to web
  static Future<bool> openUberEats() async {
    // Deep link format for Uber Eats
    final deepLink = Uri.parse(
        'https://parkandpick.order-online.ai/#/?service=generic_1&restocode=production');
    final webUrl = Uri.parse(
        'https://parkandpick.order-online.ai/#/?service=generic_1&restocode=production');

    try {
      if (await canLaunchUrl(deepLink)) {
        await launchUrl(deepLink);
        return true;
      } else {
        // Fallback to web browser
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
        return true;
      }
    } catch (e) {
      print('Error launching Uber Eats: $e');
      return false;
    }
  }
}
