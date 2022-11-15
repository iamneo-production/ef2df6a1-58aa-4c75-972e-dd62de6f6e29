import 'package:firebase_auth/firebase_auth.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

class StellarFunctions {
  static Future<String> createStellarAccount() async {
    KeyPair acc = KeyPair.random();
    KeyPair issuer = KeyPair.fromSecretSeed(
        "SADPSHZQT5KPEQDVSWJH44BJJEMM5VJRNPVLONV4HQGISCTRILPHC66R");
    KeyPair neobank = KeyPair.fromSecretSeed(
        "SB5O3DDMGUHDZ4IQJO6D4TYBMPH3QTDXGO3MRTEW7JOH3GZIBK34JELV");

    final StellarSDK sdk = StellarSDK.TESTNET;
    await FriendBot.fundTestAccount(acc.accountId);

    Asset iomAsset = AssetTypeCreditAlphaNum4("INR", issuer.accountId);
    ChangeTrustOperationBuilder chOp =
        ChangeTrustOperationBuilder(iomAsset, "10000");
    AccountResponse receiver = await sdk.accounts.account(acc.accountId);
    Transaction transaction =
        new TransactionBuilder(receiver).addOperation(chOp.build()).build();
    transaction.sign(acc, Network.TESTNET);
    await sdk.submitTransaction(transaction);
    return (acc.secretSeed);
  }

  static Future<String> transferMoney(String amt, String sKey) async {
    try {
      StellarSDK sdk = StellarSDK.TESTNET;
      KeyPair issuer = KeyPair.fromSecretSeed(
          "SADPSHZQT5KPEQDVSWJH44BJJEMM5VJRNPVLONV4HQGISCTRILPHC66R");
      KeyPair neobank = KeyPair.fromSecretSeed(
          "SB5O3DDMGUHDZ4IQJO6D4TYBMPH3QTDXGO3MRTEW7JOH3GZIBK34JELV");
      KeyPair cust = KeyPair.fromSecretSeed(sKey);
      Asset iomAsset = AssetTypeCreditAlphaNum4("IOM", issuer.accountId);
      AccountResponse nb = await sdk.accounts.account(neobank.accountId);
      Transaction transaction = new TransactionBuilder(nb)
          .addOperation(
              PaymentOperationBuilder(cust.accountId, iomAsset, amt).build())
          .build();
      transaction.sign(neobank, Network.TESTNET);

      final resp = await sdk.submitTransaction(transaction);
      return resp.hash!;
    } catch (e) {
      return 'Error';
    }
  }

  static Future<String> checkBalance(String sKey) async {
    StellarSDK sdk = StellarSDK.TESTNET;
    KeyPair cust = KeyPair.fromSecretSeed(sKey);
    AccountResponse receiver = await sdk.accounts.account(cust.accountId);
    String bal = '';
    receiver.balances?.forEach((element) {
      if (element!.assetCode == 'INR') bal = element.balance!;
    });
    return bal;
  }
}
