/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of sandbox.purity.model;

/**
 * whilst using the oauth2 package this is unlikely to be workable
 * since fb doesn't follow oauth2 standards.
 */
class FacebookLogin extends Login{
  static Uri _AUTH_URL = new Uri.https('www.facebook.com', '/dialog/oauth');
  static Uri _TOKEN_URL = new Uri.https('graph.facebook.com', '/oauth/access_token');

  FacebookLogin(
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
    scopes,
    ',');
}