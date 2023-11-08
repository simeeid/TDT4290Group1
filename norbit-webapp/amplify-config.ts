export const amplifyConfig = {
  Auth: {
    // REQUIRED only for Federated Authentication - Amazon Cognito Identity Pool ID
    identityPoolId: process.env.NEXT_PUBLIC_IDENTITY_POOL_ID,

    // REQUIRED - Amazon Cognito Region
    region: process.env.NEXT_PUBLIC_REGION,

    // OPTIONAL - Amazon Cognito User Pool ID
    userPoolId: process.env.NEXT_PUBLIC_USER_POOL_ID,

    // OPTIONAL - Amazon Cognito Web Client ID (26-char alphanumeric string)
    userPoolWebClientId: process.env.NEXT_PUBLIC_USER_POOL_WEB_CLIENT_ID,

    // OPTIONAL - Enforce user authentication prior to accessing AWS resources or not
    mandatorySignIn: false,

    // OPTIONAL - This is used when autoSignIn is enabled for Auth.signUp
    // 'code' is used for Auth.confirmSignUp, 'link' is used for email link verification
    signUpVerificationMethod: "code", // 'code' | 'link'

    // OPTIONAL - Hosted UI configuration
    oauth: {
      domain: process.env.NEXT_PUBLIC_COGNITO_DOMAIN,
      scope: ["phone", "email", "openid"],
      redirectSignIn: process.env.NEXT_PUBLIC_COGNITO_REDIRECT_SIGN_IN,
      redirectSignOut: process.env.NEXT_PUBLIC_COGNITO_REDIRECT_SIGN_OUT,
      responseType: "code", // or 'token', note that REFRESH token will only be generated when the responseType is code
    },
  },
};
