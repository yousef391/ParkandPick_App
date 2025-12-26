import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:testtt/providers/user_provider.dart';

void main() {
  group('UserProvider', () {
    late UserProvider provider;

    setUp(() {
      provider = UserProvider();
    });

    test('updateProfile updates name and email', () async {
      await provider.updateProfile(name: 'Alice', email: 'alice@example.com');
      expect(provider.currentUser.name, 'Alice');
      expect(provider.currentUser.email, 'alice@example.com');
    });

    test('updateAvatar sets avatarPath', () async {
      const path = '/tmp/avatar.png';
      await provider.updateAvatar(path);
      expect(provider.currentUser.avatarPath, path);
    });

    test('uploadAvatar stores local file path', () async {
      final file = File('test.png');
      await provider.uploadAvatar(file);
      expect(provider.currentUser.avatarPath, file.path);
    });
  });
}
