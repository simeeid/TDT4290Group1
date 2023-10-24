const amplifyconfig = ''' {
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "IdentityManager": {
          "Default": {}
        },
        "CredentialsProvider": {
          "CognitoIdentity": {
            "Default": {
              "PoolId": "eu-north-1:b3517300-7839-4c80-9cee-6f7de4696a4a",
              "Region": "eu-north-1"
            }
          }
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "eu-north-1_p8ymXPfR1",
            "AppClientId": "3ap54eg8fgphqt0vcfqaonmcfr",
            "Region": "eu-north-1"
          }
        },
        "Auth": {
          "Default": {
            "authenticationFlowType": "USER_SRP_AUTH",
            "OAuth": {
              "WebDomain": "https://useriotportal.auth.eu-north-1.amazoncognito.com",
              "AppClientId": "3ap54eg8fgphqt0vcfqaonmcfr",
              "SignInRedirectURI": "myapp://",
              "SignOutRedirectURI": "myapp://",
              "Scopes": [
                "phone",
                "email",
                "openid"
              ]
            }
          }
        }
      }
    }
  }
}''';
