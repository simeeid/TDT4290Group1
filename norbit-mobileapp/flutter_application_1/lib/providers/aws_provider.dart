// providers/aws_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyAuthService {
  // Implement your AWS authentication methods here
}

class MyDataService {
  // Implement your AWS data service methods here
}

final awsAuthProvider = Provider<MyAuthService>((ref) {
  // Initialize and return your AWS authentication service
  return MyAuthService();
});

final awsDataService = Provider<MyDataService>((ref) {
  // Initialize and return your AWS data service
  return MyDataService();
});
