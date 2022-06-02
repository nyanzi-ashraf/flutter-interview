import 'package:amazcart/AppConfig/app_config.dart';

mixin URLs {
  static const String HOST = AppConfig.hostUrl;

  static const String API_URL = HOST + '/api';

  static const String ALL_PRODUCTS = '$API_URL/seller/products';

  static const String SELLER_PROFILE = '$API_URL/seller-profile';

  static const String ALL_GIFT_CARDS = '$API_URL/gift-card/list';

  static const String GIFT_CARD = '$API_URL/gift-card';

  static const String MY_PURCHASED_GIFT_CARDS =
      '$API_URL/gift-card/my-purchased/list';

  static const String PRODUCT_PRICE_SKU_WISE =
      '$API_URL/seller/product/get-sku-wise-price';

  static const String ALL_CATEGORY = '$API_URL/product/category';

  static const String TOP_CATEGORY = '$API_URL/product/category/filter/top';

  static const String ALL_RECOMMENDED =
      '$API_URL/seller/product/recomanded-product';

  static const String ALL_TOP_PICKS = '$API_URL/seller/product/top-picks';

  static const String ALL_SLIDERS = '$API_URL/appearance/sliders';

  static const String ALL_BRAND = '$API_URL/product/brand';

  static const String SINGLE_TAG_PRODUCTS = '$API_URL/product/tag';

  static const String LOGIN = '$API_URL/login';

  static const String REGISTER = '$API_URL/register';

  static const String LOGOUT = '$API_URL/logout';

  static const String GET_USER = '$API_URL/get-user';

  static const String ALL_ORDER_LIST = '$API_URL/order-list';

  static const String ALL_ORDER_PENDING_LIST = '$API_URL/order-pending-list';

  static const String ALL_ORDER_CANCEL_LIST = '$API_URL/order-cancel-list';

  static const String ALL_ORDER_REFUND_LIST = '$API_URL/order-refund-list';

  static const String NEW_USER_ZONE = '$API_URL/marketing/new-user-zone';

  static const String ORDER_TO_SHIP = '$API_URL/order-to-ship';

  static const String ORDER_TO_RECEIVE = '$API_URL/order-to-receive';

  static const String ORDER_REVIEW = '$API_URL/order-review';

  static const String ADDRESS_LIST = '$API_URL/profile/address-list';

  static const String COUNTRY = '$API_URL/location/country';

  static String stateByCountry(countryId) {
    return '$API_URL/location/country/$countryId/states';
  }

  static String cityByState(stateId) {
    return '$API_URL/location/state/$stateId/cities';
  }

  static const String ADD_ADDRESS = '$API_URL/profile/address-store';

  static const String ADDRESS_SET_DEFAULT_BILLING =
      '$API_URL/profile/default-billing-address';

  static const String ADDRESS_SET_DEFAULT_SHIPPING =
      '$API_URL/profile/default-shipping-address';

  static String editAddress(addressId) {
    return '$API_URL/profile/address-update/$addressId';
  }

  static const String DELETE_ADDRESS = '$API_URL/profile/address-delete';

  static const String UPDATE_USER_PROFILE =
      '$API_URL/profile/update-information';

  static const String WAITING_FOR_REVIEW =
      '$API_URL/order-review/waiting-for-review-list';

  static const String MY_REVIEWS = '$API_URL/order-review/list';

  static const String UPDATE_PROFILE_PHOTO = '$API_URL/profile/update-photo';

  static const String MY_COUPONS = '$API_URL/coupon';
  static const String MY_COUPON_DELETE = '$API_URL/coupon/delete';

  static const String MY_WISHLIST = '$API_URL/wishlist';

  static const String MY_WISHLIST_DELETE = '$API_URL/wishlist/delete';

  static const String CART = '$API_URL/cart';
  static const String CART_QUANTITY_UPDATE = '$API_URL/cart/update-qty';
  static const String CART_SELECT_UNSELECT_ALL = '$API_URL/cart/select-all';
  static const String CART_SELECT_UNSELECT_SELLER_WISE =
      '$API_URL/cart/select-seller-item';
  static const String CART_SELECT_UNSELECT_SINGLE = '$API_URL/cart/select-item';
  static const String CART_REMOVE_ALL = '$API_URL/cart/remove-all';
  static const String CART_REMOVE_CART_ITEM = '$API_URL/cart/remove';

  static const String CART_UPDATE_SHIPPING =
      '$API_URL/cart/update-shipping-method';

  static const String FLASH_DEALS = '$API_URL/marketing/flash-deal';

  static const String CHANGE_PASSWORD = '$API_URL/change-password';

  static const String CHECKOUT = '$API_URL/checkout';

  static const String PAYMENT_GATEWAY = '$API_URL/payment-gateway';

  static const String BANK_INFO = '$API_URL/payment-gateway/bank/bank-info';

  static const String BANK_PAYMENT_DATA_STORE =
      '$API_URL/payment-gateway/bank/payment-data-store';

  static const String ORDER_STORE = '$API_URL/order-store';

  static const String ORDER_PAYMENT_STORE = '$API_URL/order-payment-info-store';

  static const String SORT_PRODUCTS =
      '$API_URL/seller/product/sort-before-filter';

  static const String SORT_ALL_PRODUCTS =
      '$API_URL/seller/product/filter/fetch-data';

  static const String FILTER_ALL_PRODUCTS =
      '$API_URL/seller/product/filter/filter-product-page-by-type';

  static const String FILTER_SELLER_PRODUCTS = '$API_URL/seller/filter-by-type';

  static const String APPLY_COUPON = '$API_URL/checkout/coupon-apply';

  static String fetchNewUserProductData(slug) {
    return '$API_URL/marketing/new-user-zone/$slug/fetch-product-data';
  }

  static String fetchNewUserCategoryAllProducts(slug) {
    return '$API_URL/marketing/new-user-zone/$slug/fetch-all-category-data';
  }

  static String fetchNewUserCouponAllProducts(slug) {
    return '$API_URL/marketing/new-user-zone/$slug/fetch-all-coupon-category-data';
  }

  static String fetchNewUserCategoryProducts(slug) {
    return '$API_URL/marketing/new-user-zone/$slug/fetch-category-data';
  }

  static String fetchNewUserCouponProducts(slug) {
    return '$API_URL/marketing/new-user-zone/$slug/fetch-coupon-category-data';
  }

  static const String CANCEL_REASONS =
      '$API_URL/order-manage/cancel-reason-list';

  static const String ORDER_CANCEL_STORE = '$API_URL/order-manage/cancel-store';

  static const String REFUND_REASONS_LIST = '$API_URL/refund/reason-list';

  static const String REFUND_STORE = '$API_URL/order-refund/store';

  static const String USER_NOTIFICATIONS = '$API_URL/user-notifications';

  static const String GENERAL_SETTINGS = '$API_URL/general-settings';

  static const String CURRENCY_LIST = '$API_URL/currency-list';

  static const String SHIPPING_LIST = '$API_URL/shipping-lists';

  static const String CUSTOMER_GET_DATA = '$API_URL/profile/get-customer-data';

  // static const String TICKET_LIST = '$API_URL/ticket-list-get-data';
  static const String TICKET_LIST = '$API_URL/ticket-list-get-data';

  static const String TICKET_CATEGORIES = '$API_URL/ticket/categories';

  static const String TICKET_PRIORITIES = '$API_URL/ticket/priorities';

  static const String TICKET_STORE = '$API_URL/ticket-store';

  static const String TICKET_SHOW = '$API_URL/ticket-show';

  static const String TICKET_REPLY = '$API_URL/ticket-show/reply';

  static const String NOTIFICATION_SETTINGS =
      '$API_URL/user-notifications-setting';
  static const String NOTIFICATION_SETTINGS_UPDATE =
      '$API_URL/user-notifications-setting/update';

  static const String LIVE_SEARCH = '$API_URL/live-search';
}

// constant for page limit & timeout
mixin AppLimit {
  static const int REQUEST_TIME_OUT = 30000;
}

const String appVersion = '0.0.1';
const String environment = 'Production';
