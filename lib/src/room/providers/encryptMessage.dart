import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:tuple/tuple.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:convert/convert.dart' as convert;
import 'dart:developer' as developer;

String encryptAESCryptoJS(String plainText, String passphrase) {
  try {
    final salt = genRandomWithNonZero(8);
    var keyndIV = deriveKeyAndIV(passphrase, salt);
    final key = encrypt.Key(keyndIV.item1);
    final iv = encrypt.IV(keyndIV.item2);

    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    /*
      Uint8List encryptedBytesWithSalt = Uint8List.fromList(
        createUint8ListFromString("Salted__") + salt + encrypted.bytes);
    */

    developer.log('ct: ${base64.encode(encrypted.bytes)}');
    developer.log('salt: ${convert.hex.encode(salt)}');
    developer.log('iv: ${convert.hex.encode(iv.bytes)}');
    return jsonEncode({
      'ct': base64.encode(encrypted.bytes),
      'iv': convert.hex.encode(iv.bytes),
      's': convert.hex.encode(salt)
    });
    //  return base64.encode(encryptedBytesWithSalt);
  } on Exception catch (_) {
    rethrow;
  }
}

String decryptAESCryptoJS(String encrypted, String passphrase) {
  developer.log('decryptAESCryptoJS');
  var json = jsonDecode(encrypted);
  var salt = convert.hex.decode(json['s']);

  // final salt = encryptedBytesWithSalt.sublist(8, 16);
  var keyndIV = deriveKeyAndIV(passphrase, salt);
  final key = encrypt.Key(keyndIV.item1);
  final iv = encrypt.IV(keyndIV.item2);

  final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
  final decrypted = encrypter.decrypt64(json["ct"], iv: iv);
  //FUNIONA!!!!
  return decrypted;
}

Tuple2<Uint8List, Uint8List> deriveKeyAndIV(String passphrase, List<int> salt) {
  var password = createUint8ListFromString(passphrase);
  Uint8List concatenatedHashes = Uint8List(0);
  Uint8List currentHash = Uint8List(0);
  bool enoughBytesForKey = false;
  Uint8List preHash = Uint8List(0);

  while (!enoughBytesForKey) {
    //int preHashLength = currentHash.length + password.length + salt.length;
    if (currentHash.isNotEmpty) {
      preHash = Uint8List.fromList(currentHash! + password + salt);
    } else {
      preHash = Uint8List.fromList(password + salt);
    }
    currentHash = md5.convert(preHash).bytes as Uint8List;
    concatenatedHashes = Uint8List.fromList(concatenatedHashes + currentHash!);
    if (concatenatedHashes.length >= 48) enoughBytesForKey = true;
  }

  var keyBtyes = concatenatedHashes.sublist(0, 32);
  var ivBtyes = concatenatedHashes.sublist(32, 48);
  return Tuple2(keyBtyes, ivBtyes);
}

Uint8List createUint8ListFromString(String s) {
  var ret = Uint8List(s.length);
  for (var i = 0; i < s.length; i++) {
    ret[i] = s.codeUnitAt(i);
  }
  return ret;
}

Uint8List genRandomWithNonZero(int seedLength) {
  final random = Random.secure();
  const int randomMax = 245;
  final Uint8List uint8list = Uint8List(seedLength);
  for (int i = 0; i < seedLength; i++) {
    uint8list[i] = random.nextInt(randomMax) + 1;
  }
  return uint8list;
}
