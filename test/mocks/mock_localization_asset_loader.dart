import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

class MockLocalizationAssetLoader extends AssetLoader {
  MockLocalizationAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return {
      ..._auth,
      ..._cart,
      ..._catalog,
      ..._checkout,
      ..._home,
      ..._product,
      ..._profile,
      ..._search,
    };
  }

  final _auth = {
    "auth": {
      "messages": {"account_created": "Account successfully created"},
      "branding": {
        "app_name": "Flutly",
        "tagline": "Made with Flutter by BernesDev",
      },
      "actions": {
        "forgot_password": "Forgot Password?",
        "login": "Login",
        "sign_up": "Sign Up",
        "create_account": "Create Account",
      },
      "prompts": {"no_account": "Don't have an account? "},
      "fields": {
        "name": "Name",
        "email": "Email",
        "password": "Password",
        "confirm_password": "Confirm Password",
      },
      "validation": {
        "name_required": "Name is required",
        "email_required": "Email is required",
        "email_invalid": "Invalid email format",
        "password_required": "Password is required",
        "password_min_length": "Password must be at least {count} characters",
        "passwords_no_match": "Passwords do not match",
      },
      "errors": {
        "invalid_email": "The email address is badly formatted.",
        "user_disabled": "This user has been disabled.",
        "user_not_found": "No user found for that email.",
        "wrong_password": "Wrong password provided for that user.",
        "email_already_in_use": "The account already exists for that email.",
        "operation_not_allowed":
            "Operation not allowed. Please contact support.",
        "weak_password": "The password provided is too weak.",
        "invalid_credential": "The email or password is invalid.",
        "undefined": "An undefined error happened: {message}",
        "undefined_no_message": "An undefined error happened.",
        "invalid_credentials": "Invalid credentials",
        "sign_in_failed": "Sign in failed",
        "sign_up_failed_invalid_user": "Sign up failed: Invalid user",
        "sign_up_failed": "Sign up failed",
        "sign_out_failed": "Sign out failed",
        "update_failed_no_auth_user": "Update failed: No authenticated user",
        "update_failed": "Update failed",
        "save_credentials_failed": "Failed to save credentials",
        "get_credentials_failed": "Failed to get credentials",
        "clear_credentials_failed": "Failed to clear credentials",
        "sign_with_google_failed_invalid_user":
            "Sign in with Google failed: Invalid user",
        "sign_with_apple_failed_invalid_user":
            "Sign in with Apple failed: Invalid user",
        "must_be_logged_in": "You must be logged in to perform this action",
      },
      "defaults": {"user_name": "User"},
    },
  };

  final _cart = {
    "cart": {
      "title": "Shopping Cart",
      "summary": {
        "total": "Total {count} {itemLabel}",
        "item": "Item",
        "items": "Items",
        "price_usd": "USD {price}",
      },
      "empty": {
        "title": "Your Cart is Empty",
        "browse_products": "Browse Products",
      },
      "popular": {"title": "Popular Products"},
      "actions": {
        "checkout": "Checkout",
        "sign_in": "Sign In",
        "continue_guest": "Continue as Guest",
        "retry": "Retry",
      },
      "auth_required": {
        "title": "Sign In Required",
        "message": "You need to be signed in to proceed to checkout.",
      },
      "errors": {
        "loading": "Error loading cart",
        "local_get_failed": "Failed to get cart from local storage",
        "local_save_failed": "Failed to save cart to local storage",
        "local_clear_failed": "Failed to clear cart from local storage",
        "remote_clear_failed": "Failed to clear cart",
        "remote_get_failed": "Failed to get cart",
        "remote_save_failed": "Failed to save cart",
      },
    },
  };

  final _catalog = {
    "catalog": {
      "title": "Products",
      "filters": {
        "title": "Filters",
        "sort_by": "Sort By",
        "price_range": "Price Range",
        "min_price": "Min Price",
        "max_price": "Max Price",
        "apply": "Apply Filters",
        "clear": "Clear Filters",
        "sort": {
          "popularity": "Popularity",
          "price_high_to_low": "High Price",
          "price_low_to_high": "Low Price",
          "unsorted": "Unsorted",
        },
      },
      "empty": {
        "title": "No Products Found",
        "description":
            "Your search did not match any products.\nPlease try different keywords or filters.",
      },
      "errors": {
        "initial":
            "Something went wrong while loading products.\n Please try again.",
        "new_page": "Something went wrong...",
        "fetch_failed": "Failed to fetch products",
      },
      "actions": {"retry": "Retry"},
    },
  };

  final _checkout = {
    "checkout": {
      "steps": {
        "delivery": {"title": "Delivery", "action": "Proceed to Payment"},
        "payment": {"title": "Payment", "action": "Proceed to Review"},
        "review": {"title": "Order Review", "action": "Place Order"},
        "placing_order": {"title": "Placing Order", "action": ""},
      },
      "order_status": {
        "verifying": "Verifying Stock",
        "processing": "Processing Payment",
        "finalizing": "Finalizing Order",
        "completed": "Order Completed",
      },
      "validation": {"missing_info": "Some checkout information is missing."},
      "confirmation": {
        "not_found": "Order not found",
        "thank_you": "Thank you for buying with Flutly 🛍️",
        "order_number": "Order #{id}",
        "items_title": "Items",
      },
      "sections": {
        "address": "Address",
        "delivery": "Delivery",
        "payment": "Payment",
        "total": "Total",
        "shipping": "Shipping",
        "credit_card": "Credit Card",
      },
      "summary": {
        "items": "{count} Items",
        "price_usd": "USD {price}",
        "free": "Free",
        "card_mask": "•••• •••• •••• {last4}",
      },
      "actions": {"new_address": "New Address", "new_card": "New Card"},
      "placing_order": {
        "processing_message": "We're confirming your order details...",
        "completed_message": "All set! Your order is confirmed.",
      },
      "sample_data": {
        "address_home_title": "Home",
        "address_home_street": "Zagrebačka ul. 4",
        "address_home_city": "Poreč",
        "address_home_zip": "52440",
        "address_home_country": "Croatia",
        "address_home_state": "Istria",
        "address_office_title": "Office",
        "address_office_street": "Ul. Lorenza Jagera 9",
        "address_office_city": "Osijek",
        "address_office_state": "Osijek-Baranja",
        "address_office_zip": "31000",
        "address_office_country": "Croatia",
        "payment_personal_name": "Personal Card",
        "payment_business_name": "Business Card",
        "shipping_duration": "4 Days",
        "shipping_name": "Normal",
      },
    },
  };

  final _home = {
    "home": {
      "visitor": "Visitor",
      "greeting": "Hi, {name}",
      "search_prompt": "What are you looking for today?",
      "errors": {"fetch_products_failed": "Failed to fetch home products"},
    },
  };

  final _product = {
    "product": {
      "actions": {
        "add_to_cart": "Add to Cart",
        "continue_shopping": "Continue Shopping",
        "view_cart": "View Cart",
      },
      "labels": {"description": "Description"},
      "messages": {"added": "Product Added"},
      "pricing": {"price_usd": "USD {price}", "discount": "{percent}% OFF"},
      "sections": {"recommendations": "More Products"},
      "errors": {
        "id_null": "Product ID is null",
        "fetch_failed": "Failed to get product by id",
        "recommendations_failed": "Failed to get product recommendations",
      },
    },
  };

  final _profile = {
    "profile": {
      "title": "Profile",
      "user": {"guest": "Guest", "sign_in_prompt": "Sign in to your account"},
      "sections": {
        "general": "General",
        "support": "Support",
        "account": "Account",
      },
      "actions": {
        "edit_profile": "Edit Profile",
        "sign_out": "Sign Out",
        "sign_in": "Sign In",
        "report_bug": "Report a Bug",
        "save": "Save",
        "delete_account": "Delete Account",
      },
      "edit": {
        "title": "Edit Profile",
        "updated_success": "Profile updated successfully!",
      },
      "fields": {
        "name": "Name",
        "email": "Email",
        "current_password": "Current Password",
        "new_password": "New Password",
        "confirm_new_password": "Confirm New Password",
      },
      "validation": {
        "name_required": "Name is required",
        "password_min_length": "Password must be at least 6 characters",
        "password_change_current": "Enter current password to change",
        "password_change_new": "Enter new password to change",
        "passwords_no_match": "Passwords do not match",
      },
      "errors": {
        "load_user": "Error loading user data",
        "not_authenticated": "User not authenticated.",
        "report_bug_failed": "Failed to report bug. Please try again later.",
      },
      "messages": {"signed_out": "You have been signed out"},
      "report_bug": {
        "title": "Report a Bug",
        "success_message": "Thank you! Your report has been sent.",
        "fields": {
          "description_label": "What went wrong?",
          "description_hint": "Describe the issue you encountered.",
          "description_required": "Description is required",
          "description_max_length":
              "Description must be at most {length} characters long",
          "steps_label": "Steps to reproduce (Optional)",
          "steps_empty":
              "No steps added yet. Tap \"Add Step\" to include steps.",
          "expected_label": "What did you expect to happen? (Optional)",
          "expected_hint": "Tell us what you expected instead.",
          "issue_type_label": "Issue category (Optional)",
          "issue_type_hint": "Select issue category",
          "screen_label": "Where did this happen? (Optional)",
          "screen_hint": "E.g.: Cart, Checkout, Login, Product page...",
          "frequency_label": "How often does this happen? (Optional)",
          "frequency_hint": "Select frequency",
        },
        "issue_types": {
          "visual": "Visual issue",
          "feature_not_working": "Feature not working",
          "crash_freeze": "App crash or freeze",
          "performance": "Performance issue",
          "other": "Other",
        },
        "frequency_options": {
          "once": "It happened once",
          "sometimes": "It happens sometimes",
          "every_time": "It happens every time",
        },
        "steps": {"add": "Add Step", "hint": "Describe step {number}"},
        "info": {
          "usage":
              "The information you provide will be used only to improve the app.",
          "sensitive":
              "Please do not include sensitive or personal information.",
        },
        "actions": {"send": "Send Report"},
        "auth_required": {
          "title": "Sign In Required",
          "message": "You need to be signed in to report a bug.",
          "sign_in": "Sign In",
          "cancel": "Cancel",
        },
      },
    },
  };

  final _search = {
    "search": {
      "title": "Search",
      "hint": "Search...",
      "sections": {
        "related_terms": "Related Terms",
        "recent_searches": "Recent Searches",
        "popular_products": "Popular Products",
      },
      "messages": {
        "no_suggestions":
            "No suggestions found, but you can try searching for something else.",
      },
      "errors": {
        "suggestions_failed": "Failed to load search suggestions",
        "popular_products_failed": "Failed to fetch popular products",
        "save_term_failed": "Failed to save search term",
        "remove_term_failed": "Failed to remove search term",
        "get_terms_failed": "Failed to get search terms",
      },
      "suggestions": {
        "amazon": "Amazon",
        "apple": "Apple",
        "beats": "Beats",
        "monopod": "Monopod",
        "iphone": "iPhone",
        "pedestal": "Pedestal",
        "selfie_stick": "Selfie Stick",
        "case": "Case",
        "watch": "Watch",
        "airpods": "AirPods",
      },
    },
  };
}
