import 'package:flutter_test/flutter_test.dart';
import 'package:marche_yama_backoffice/main.dart';

void main() {
  test('le backoffice pointe sur le bon domaine', () {
    expect(Uri.parse(backofficeUrl).host, 'backoffice.marche2yama.com');
  });
}
