/// Enumeration for bottom navigator tabs with their icons
enum BottomNavigatorTab {
  home('home', 'home_filled'),
  cart('cart', 'cart_filled'),
  profile('profile', 'profile_filled');

  const BottomNavigatorTab(this.icon, this.activeIcon);

  final String icon;
  final String activeIcon;

  @override
  String toString() => '$icon - $activeIcon';
}
