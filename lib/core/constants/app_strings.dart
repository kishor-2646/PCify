class AppStrings {
  // Prevent instantiation
  const AppStrings._();

  // General
  static const String appName = "PCBuilder Platform";
  static const String browseAsGuest = "Browse as Guest";
  static const String landingTagline = "Connect with Expert PC Builders\nto build your dream machine.";
  static const String orContinueWith = "Or continue with";

  // Role Selection
  static const String customerRoleTitle = "I'm Looking for a PC Builder";
  static const String customerRoleSubtitle = "Find experts to build your gaming or workstation PC";

  static const String builderRoleTitle = "I'm a PC Builder";
  static const String builderRoleSubtitle = "Join as a professional to find new clients";

  // Social Auth
  static const String google = "Google";
  static const String apple = "Apple";

  // Customer Sign Up
  static const String createAccountCustomer = "Create Your Account (Customer)";
  static const String fullName = "Full Name";
  static const String emailAddress = "Email Address";
  static const String phoneNumber = "Phone Number";
  static const String password = "Password";
  static const String confirmPassword = "Confirm Password";
  static const String signUp = "Sign Up";
  static const String alreadyHaveAccount = "Already have account? ";
  static const String signIn = "Sign In";

  static const String acceptTerms = "I accept terms & conditions";
  static const String receiveOffers = "I want offers & updates";

  // Builder Sign Up
  static const String createAccountBuilder = "Create Builder Account";
  static const String businessName = "Business Name";
  static const String gstNumber = "GST Registration Number";
  static const String aadhaarNumber = "Aadhaar Number";
  static const String yearsExperience = "Years of Experience";
  static const String serviceArea = "Service Area (Cities)";
  static const String primarySpecialization = "Primary Specialization";
  static const String acceptBuilderAgreement = "I accept builder agreement & insurance requirements";
  static const String hasLiabilityInsurance = "I have professional liability insurance";
  static const String registerAsBuilder = "Register as Builder";
  static const String alreadyRegistered = "Already registered? ";

  // OTP Verification (NEW)
  static const String verifyEmail = "Verify Your Email";
  static const String sentCodeTo = "We sent a 6-digit code to";
  static const String didntReceive = "Didn't receive code?";
  static const String resend = "Resend";
  static const String resendIn = "Resend in";
  static const String verify = "Verify";
  static const String verifyWithPhone = "Verify with phone instead";

  // Validation Messages
  static const String errRequired = "This field is required";
  static const String errEmail = "Please enter a valid email";
  static const String errPhone = "Enter valid 10-digit number";
  static const String errPasswordMatch = "Passwords do not match";
  static const String errPasswordWeak = "Password is too weak";
  static const String errGst = "Enter valid GST number";
  static const String errAadhaar = "Enter valid 12-digit Aadhaar";
  static const String errOtpIncomplete = "Please enter full 6-digit code";

  // Builder Profile Setup
  static const String builderProfileSetup = "Builder Profile Setup";
  static const String step1Basic = "Basic Info";
  static const String step2Specs = "Skills"; // Shortened for UI
  static const String step3Pricing = "Pricing";

  // Step 1
  static const String uploadPhoto = "Upload Profile Photo";
  static const String bio = "Bio";
  static const String bioHint = "Describe your experience & specialization...";
  static const String websiteLink = "Website Link (Optional)";
  static const String youtubeLink = "YouTube Channel (Optional)";
  static const String instagramLink = "Instagram Handle (Optional)";

  // Step 2
  static const String selectSpecializations = "Select Specializations (Select all that apply)";
  static const String certifications = "Certifications";
  static const String uploadCert = "Upload Certificate";
  static const String awards = "Awards / Recognition (Optional)";

  // Step 3
  static const String consultationRate = "Consultation Rate (₹/hr)";
  static const String assemblyCostBudget = "Assembly: Budget Build (₹)";
  static const String assemblyCostMid = "Assembly: Mid-Range (₹)";
  static const String assemblyCostHigh = "Assembly: High-End (₹)";
  static const String responseTime = "Response Time";
  static const String completeSetup = "Complete Setup";

  // Customer Home (NEW)
  static const String homeHeroTitle = "Find Expert PC Builders\nNear You";
  static const String homeHeroSubtitle = "Start Building Your Dream PC";
  static const String startBuilding = "Start Building";
  static const String searchHint = "Search builders, parts, or services...";

  static const String tabForYou = "For You";
  static const String tabGaming = "Gaming";
  static const String tabEditing = "Editing";
  static const String tabCoding = "Coding";
  static const String tabRecent = "Recent Views";

  static const String sectionRecentSearches = "Your Recent Searches";
  static const String viewProfile = "View Profile";
  static const String message = "Message";

  // Search & Filters (NEW)
  static const String searchBuildersHint = "Search builders, specializations...";
  static const String filterTitle = "Filters";
  static const String budgetRange = "Budget Range";
  static const String hourlyRate = "Hourly Rate";
  static const String assemblyCost = "Assembly Cost";
  static const String specializationsLabel = "Specializations";
  static const String experienceLevel = "Experience Level";
  static const String minRating = "Minimum Rating";
  static const String distanceRadius = "Distance (km)";
  static const String availability = "Availability";
  static const String serviceType = "Service Type";
  static const String resetFilters = "Reset";
  static const String applyFilters = "Apply Filters";
  static const String results = "results found";

  // Builder Profile View (NEW)
  static const String aboutBuilder = "About Builder";
  static const String buildsCompleted = "Builds Completed";
  static const String onTimeDelivery = "On-Time Delivery";
  static const String customerSatisfaction = "Customer Satisfaction";
  static const String portfolioRecentBuilds = "Portfolio (Recent Builds)";
  static const String customerReviews = "Customer Reviews";
  static const String bookConsultation = "Book Consultation";
  static const String messageBuilder = "Message Builder";
  static const String serviceDetails = "Service Details";
  static const String responseTimeLabel = "Response Time";
  static const String serviceAreasLabel = "Service Areas";

  // Booking Flow (NEW)
  static const String bookingTitle = "Book Consultation";
  static const String selectServiceType = "Select Service Type";
  static const String consultationOnly = "Consultation Only";
  static const String fullAssembly = "Full Assembly Service";
  static const String hybridService = "Hybrid (Consultation + Assembly)";
  static const String selectDateTime = "Select Date & Time";
  static const String addDetails = "Add Details";
  static const String primaryUse = "Primary Use";
  static const String buildRequirements = "Build Requirements";
  static const String estimatedBudget = "Estimated Budget";
  static const String confirmPay = "Confirm & Pay";
  static const String orderSummary = "Order Summary";
  static const String paymentMethod = "Payment Method";
  static const String payAndBook = "Pay & Book";
  static const String bookingConfirmed = "Consultation Booked!";
  static const String bookingSuccessMsg = "Your booking has been confirmed.";
  static const String goToHome = "Go to Home";

  // Chat Screen (NEW)
  static const String online = "Online";
  static const String typeMessage = "Type a message...";
  static const String viewBooking = "View Booking";
  static const String sendBuildSpec = "Send Build Spec";
  static const String askQuestion = "Ask a Question";

  // Customer Dashboard (NEW)
  static const String dashboardTitle = "My Dashboard";
  static const String tabActive = "Active";
  static const String tabHistory = "History";
  static const String tabSaved = "Saved";
  static const String tabAccount = "Account";

  static const String reschedule = "Reschedule";
  static const String cancel = "Cancel";
  static const String leaveReview = "Leave Review";
  static const String bookAgain = "Book Again";

  static const String editProfile = "Edit Profile";
  static const String paymentMethods = "Payment Methods";
  static const String notifications = "Notifications";
  static const String support = "Support";
  static const String logout = "Logout";

  // Builder Dashboard (NEW)
  static const String modeBuilder = "Mode: Builder";
  static const String kpiProfileViews = "Profile Views";
  static const String kpiInquiries = "New Inquiries";
  static const String kpiBookings = "Bookings (Week)";
  static const String kpiRating = "Rating";

  static const String upcomingConsultations = "Upcoming Consultations";
  static const String viewAllBookings = "View All Bookings";
  static const String startCall = "Start Call";
  static const String updateStatus = "Update Status";

  static const String newInquiries = "New Customer Inquiries";
  static const String acceptInquiry = "Accept";
  static const String declineInquiry = "Decline";

  static const String earningsTitle = "Earnings";
  static const String viewEarnings = "View Earnings Report";

  static const String navDashboard = "Dashboard";
  static const String navInquiries = "Inquiries";
  static const String navBookings = "Bookings";
  static const String navMessages = "Messages";
  static const String navProfile = "Profile";

  // Builder Booking Management (NEW)
  static const String manageBookings = "Manage Bookings";
  static const String tabNew = "New";
  static const String tabConfirmed = "Confirmed";
  static const String tabCompleted = "Completed";
  static const String tabCancelled = "Cancelled";

  static const String uploadBuildSpec = "Upload Build Spec";
  static const String markComplete = "Mark Complete";
  static const String updateTimeline = "Update Timeline";
  static const String shareQuotation = "Share Quotation";
  static const String viewDetails = "View Details";
  static const String viewReview = "View Review";
  static const String paymentPaid = "Paid";
  static const String paymentPending = "Pending";

  // Builder Profile Management (NEW)
  static const String editBuilderProfile = "Edit Profile & Portfolio";
  static const String tabBasic = "Basic";
  static const String tabPortfolio = "Portfolio";
  static const String tabCerts = "Certs";
  static const String tabPricing = "Pricing";
  static const String tabAvailability = "Availability";

  static const String saveChanges = "Save Changes";
  static const String addBuild = "Add New Build";
  static const String uploadCertificate = "Upload Certificate";
  static const String autoAccept = "Automatically accept inquiries";
  static const String unavailableDays = "Unavailable Days";

  // Builder Chat (NEW)
  static const String conversations = "Conversations";
  static const String searchCustomers = "Search customers...";
  static const String quickReply = "Quick Reply";

  // Builder Reviews (NEW)
  static const String reviewsAndRatings = "Reviews & Ratings";
  static const String overallRating = "Overall Rating";
  static const String basedOnReviews = "Based on 245 reviews";
  static const String catExpertise = "Expertise";
  static const String catCommunication = "Communication";
  static const String catPunctuality = "Punctuality";
  static const String catValue = "Value";
  static const String replyToReview = "Reply to review";
  static const String submitReply = "Submit Reply";

  // AI Configurator (Phase 2) - NEW
  static const String aiConfigTitle = "AI PC Configurator";
  static const String stepUse = "Use Case";
  static const String stepPerf = "Performance";
  static const String stepDisplay = "Display";
  static const String stepBudget = "Budget";
  static const String stepResult = "Recommendation";

  static const String useGaming = "Gaming";
  static const String useEditing = "Video Editing";
  static const String useCoding = "Coding";
  static const String useContent = "Content Creation";

  static const String perfFps = "FPS Target";
  static const String perfScrubbing = "Timeline Scrubbing";
  static const String perfCompile = "Compile Time";

  static const String res1080 = "1080p";
  static const String res1440 = "1440p";
  static const String res4k = "4K";
  static const String ultrawide = "Ultrawide Monitor?";

  static const String recommendedBuild = "Recommended Build";
  static const String estPerformance = "Estimated Performance";
  static const String viewSimilar = "View Similar Builds";
  static const String findBuilderForBuild = "Find Builder for This Build";
  static const String customizeBuild = "Customize This Build";

  // Benchmark Comparator (NEW)
  static const String benchmarkTitle = "Benchmark Comparator";
  static const String build1 = "Build 1";
  static const String build2 = "Build 2";
  static const String compare = "Compare";
  static const String costComparison = "Cost Comparison";
  static const String valueScore = "Value Score";
  static const String recommendation = "Recommendation";
}