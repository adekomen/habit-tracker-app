import 'package:googleapis/calendar/v3.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../models/habit.dart';

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

class CalendarService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/calendar',
    ],
  );

  Future<void> addEventToCalendar(Habit habit) async {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account == null) return;

    final authHeaders = await account.authHeaders;
    final client = GoogleAuthClient(authHeaders);
    final calendarApi = CalendarApi(client);


    final event = Event(
      summary: habit.name,
      description: habit.description,
      start: EventDateTime(
        dateTime: habit.startDate,
        timeZone: 'UTC',
      ),
      end: EventDateTime(
        dateTime: habit.targetDate ?? habit.startDate.add(Duration(hours: 1)),
        timeZone: 'UTC',
      ),
    );

    await calendarApi.events.insert(event, 'primary');
  }
}