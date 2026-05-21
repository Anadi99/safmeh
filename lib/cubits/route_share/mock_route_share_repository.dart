import '../../models/route_share_session.dart';
import 'route_share_cubit.dart';

class MockRouteShareRepository implements RouteShareRepository {
  final Map<String, RouteShareSession> _sessions = {};

  @override
  Future<RouteShareSession> createSession(RouteShareSession session) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final saved = session;
    _sessions[saved.id] = saved;
    return saved;
  }

  @override
  Future<void> updateSession(RouteShareSession session) async {
    _sessions[session.id] = session;
  }

  @override
  Future<void> endSession(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _sessions.remove(sessionId);
  }

  List<RouteShareSession> get activeSessions =>
      _sessions.values.where((s) => s.status == RouteShareStatus.active).toList();
}
