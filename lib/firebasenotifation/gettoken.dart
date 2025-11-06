import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import 'package:googleapis_auth/auth_io.dart';

Future<String> getAccessToken() async {
  try {
    // Define the JSON content directly in the code
    final Map<String, dynamic> serviceAccount = {
      "type": "service_account",
      "project_id": "chatapp-59ea9",
      "private_key_id": "340384fbb1700c00d3c64fb91fc6db281bf8d5a2",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQChVNKuSJK40kPj\nQfg6xhwDcCW7DJSerFeWxy3b4lVgPXw3/HEQ5V7tYLjrEqKgWj+3CS2Bmw+hMdue\nQ8KwTh+d/H9b4SF6qF4Vs59C9OpMlqI8esqYFv9KENyLWUB0e1+cVi+iI3oP6JH/\nDLnX9siEcbvwTU4+kX4lsquqIACOqorD0X6a7fIAV8NWns/fFyGlT+SfRdCSjzbT\n4r5DrPRwcHgxAF4T757f9y9Vw9RjsWf2iQcl1AC/MEYIbJhAQ8kNWjXLP/Hj00bs\nZWTLqbPHg6jvY9ovKpIKtcNPWaarmWjXjPRPuworMiBdH9AgyPyCS7HXrT23pVxG\nlJ+SoNTtAgMBAAECggEAHWFUKNcgmTX5lQZrjVCMw3eF94V3/1mFbfkB+fxC7g7k\nc1GuyZPr8LDfnDe9lBQ7bDropaS2ePWaeD0A1Ji1m1DjZLkgHrVQxQT8KPZvQNlh\n3D/Ea2Qsw7FEaMAtQ8lABTmQ3Sc20HTbOaZ4pcLUi4Im5sE9UZmvbnAWYRoI3/IW\n1B4pqoMhsMAs44nVMTyumYkEiO4BLG1njpflF8/PqLqBjtfDSvZfHo2N3bA+AyPA\nuiDBn5/gMjMlkqHYv2sI+7E3Z+2w+5/9G419PTL3bo8IHsYyTKgjcAi8ApunKRH3\nTl2up8c6HAleMibs+p2+PWw5vYSxWxoFVb3tL2OZJQKBgQDDEDkfUO4Oag/zQAQn\nR2K/jJvGYpWRsFMlphfDvDzXs7mAEi9dJzStPOSO01rPFO4294GbePpgswpWg23v\n7VHkf/y9wPdcy7vq2QZ/K7ZvOv9rydyikWs4Vlby1L9xGI4RO2XCOIWCfBL4umO6\nnlEKkVGdQi4lPuAGyDuGPqMt3wKBgQDTuvPb6vCMWrfUeFsGC/E3r6bs1wcSMfM5\nkYCDO64n1iD88GSNS9g4ggEt9rqJCtu7hQ6BGFgo5M1rGE0RnS+zobdnldT+KyOX\ndTBrmu06F3phA6yPLSDLJbo1tpqZr2tXmlSEnlf1en7sBC1gqDnEGaKbE/Qa/FsF\nUgGboIx+swKBgQCYBlvOqV9vgn/94CWci0lN6oM5oXnaeubCj+kzltCAeEUZqJKb\nckPexHeJTPYYMMLbuhicGDRjCwcCmBolhPtvL8TGCs9+1hYWGaCzmljr5bpNwpyf\nYuCCnt/TD7ZIqY+HpJhRP4XmRVbv3Sx+tIaKyuklu/+E7bTh9EpX/RdmVwKBgQC5\nvhdyRR/zsR31ygPoQQ/DD1g8C8NLRgCe7zMzbWax0dqsquM7RV8Q65PHU9x+nsT3\nM5nuzIGCln5SxkXN/vw69NKlj78DnqqhkxAARjB4tuIIO6XlEOzk6lr6BhCIZGih\nuGUO1q5JTsYLnPqGAe5zRx3sN8v85IehGjkI4wZ9mwKBgHBmuY1fbNf5mV/6mtGX\n6pQA+ogSC/rZwA71THZvSZLI2u29VAvfIuAPuImMkrOP4N1q4IgL0Q89tUhKcJu/\ng6IfjrqOblmiUSNSbMYUscgUaeuKO/Sc6mQAUZRLq/uXllr/XynGxTlSwZ67lG86\n+oef7amQHsRuD/w384nGGNPd\n-----END PRIVATE KEY-----\n",
      "client_email": "chatapp-59ea9@appspot.gserviceaccount.com",
      "client_id": "109074675272913276670",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/chatapp-59ea9%40appspot.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    // Create credentials from the JSON
    final credentials = ServiceAccountCredentials.fromJson(serviceAccount);

    // Define the required scopes
    const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    // Create an authenticated HTTP client
    final client = await clientViaServiceAccount(credentials, scopes);

    // Return the access token
    return (await client.credentials.accessToken).data;
  } catch (e) {
    print('Error retrieving access token: $e');
    rethrow;
  }
}