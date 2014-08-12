/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of sandbox.purity.model;

class GoogleLogin extends Login{
  static Uri _AUTH_URL = new Uri.https('accounts.google.com', '/o/oauth2/auth');
  static Uri _TOKEN_URL = new Uri.https('accounts.google.com', '/o/oauth2/token');

  GoogleLogin(
    String redirectUrl,
    String clientId,
    String secret,
    List<String> scopes)
  :super(
    _AUTH_URL,
    _TOKEN_URL,
    Uri.parse(redirectUrl),
    clientId,
    secret,
    scopes);
}