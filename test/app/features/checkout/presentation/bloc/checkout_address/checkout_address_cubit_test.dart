import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/checkout/presentation/bloc/checkout_address/checkout_address_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../utils/test_utils.dart';

void main() {
  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  blocTest<CheckoutAddressCubit, CheckoutAddressState>(
    'getAddresses emits loading then loaded with sample data',
    build: CheckoutAddressCubit.new,
    act: (cubit) => cubit.getAddresses(),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      isA<CheckoutAddressLoading>(),
      isA<CheckoutAddressLoaded>().having(
        (state) => state.addresses.length,
        'addresses',
        2,
      ),
    ],
  );
}
