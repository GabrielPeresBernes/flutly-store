import '../../../core/router/router.dart';
import '../../../features/auth/auth.dart';
import '../../../features/cart/cart.dart';
import '../../../features/catalog/catalog.dart';
import '../../../features/checkout/checkout.dart';
import '../../../features/home/home.dart';
import '../../../features/product/product.dart';
import '../../../features/profile/infra/routes/report_bug_route.dart';
import '../../../features/profile/profile.dart';
import '../../../features/search/search.dart';
import '../../widgets/main_scaffold.dart';

/// The main application router. Defines all routes and navigation structure.
final appRouter = CoreRouter(
  routes: [
    // Root Level Routes
    const CheckoutRoute(),
    const AuthRoute(),

    // Main App Route with Bottom Navigation
    CoreRouteStack(
      builder: (body, currentIndex, navigateToBranch) => MainScaffold(
        body: body,
        currentIndex: currentIndex,
        navigateToBranch: navigateToBranch,
      ),
      branches: [
        // Home Branch
        const CoreRouteBranch(
          routes: [HomeRoute(), SearchRoute(), CatalogRoute(), ProductRoute()],
        ),

        // Cart Branch
        const CoreRouteBranch(routes: [CartRoute()]),

        // Profile Branch
        const CoreRouteBranch(
          routes: [
            ProfileRoute(),
            EditProfileRoute(),
            ReportBugRoute(),
          ],
        ),
      ],
    ),
  ],
);
