class AppStrings {
  static const String emailEmpty = 'Email cannot be empty';
  static const String emailWrongFormat = 'Invalid email format';
  static const String passwordEmpty = 'Password cannot be empty';
  static String passwordLengthError(int length) => 'Password must be at least $length characters';

  static var onboardings = [
    ['Find the best doctors in your vicinity', 
    'With the help of our intelligent algorithms, now locate the best doctors around your vicinity at total ease'],
    ['Schedule appointments with expert doctors', 'Find experienced specialist doctors woth expert ratings and reviews and book your appointments hassle-free'],
    ['Find the best caretaker for your family members', 'Find best and experienced nuses and caretaker with expert rating and reviews']
  ];

  // failure message
  static const String noInternet = 'No internet connection. Please check your network and try again';
  static const String emailInUse = 'The account already exists for that email';
  static const String unexpectedError = 'An unexpected error occurred. Please try again later';
  static const String invalidEmail = 'Email is invalid';
  static const String operationEmailPassNotAllow = 'Email/Password are not allowed';
  static const String passwordWeak = 'Password is not strong enough';
  static const String manyRequest = 'Too many requests, please try again later';
  static const String userDisabled = 'This user has been disabled';
  static const String userNotFound = 'No user corresponding to the given email';
  static const String passwordNotMatch = 'Password is not match';
  static const String tokenExpired = 'This session is expired';
  static const String userNotSignin = 'User does not exist';

  static const String signIn = 'Sign in';
  static const String emailInput = 'Email Address';
  static const String emailHint = 'Enter email address';
  static const String continueAction = 'Continue';
  static const String nextAction = 'Next';
  static const String bookAppoimentAction = 'Book Appointment';
  static const String recomendSignUp = '''Don't have an account?''';
  static const String createAccount = 'Create Account';
  static const String or = 'Or';

  static const String passwordInput = 'Password';
  static const String passwordHint = 'Enter password';
  static const String forgotPassword = 'Forgot password?';
  static const String resetPassword = 'Reset Password';

  static const String signUp = 'Sign up';
  static const String fullNameInput = 'Full name';
  static const String fullNameHint = 'Enter full name';
  static const String recomendLogin = '''Already have an account?''';
  static const String fullNameEmpty = 'Your name cannot be empty';
  static const String invalidFullName = 'Full name is invalid';
  static const String newPassword = 'New password';
  static const String confirmPassword = 'Confirm password';
  static const String setPassword = 'Set Password';

  static const String success = 'Success';
  static const String successSignUpMsg = 'Congratulations! Your account has been successfully created';
  static const String successSendEmailResetPassMsg = 'Your reset password request has been sent, please check your email';

  //navbar
  static const String home = 'Home';
  static const String bookings = 'Bookings';
  static const String chat = 'Chat';
  static const String profile = 'Profile';

  static const String dataNotFound = 'Data not available';
  static const String welcome = 'Welcome Back';
  static const String noName = '(No Name)';
  static const String upComApp = 'Upcoming Appointment';
  static const String category = 'Category';
  static const String seeAll = 'See all';
}
