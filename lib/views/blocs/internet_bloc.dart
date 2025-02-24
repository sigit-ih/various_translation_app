import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

// Event
abstract class InternetEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckInternet extends InternetEvent {}

// State
abstract class InternetState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InternetInitial extends InternetState {}

class InternetConnected extends InternetState {}

class InternetDisconnected extends InternetState {}

// Bloc
class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;

  InternetBloc() : super(InternetInitial()) {
    // Cek koneksi internet pada event CheckInternet
    on<CheckInternet>((event, emit) async {
      bool isConnected = await _hasInternetConnection();
      if (isConnected) {
        emit(InternetConnected());
      } else {
        emit(InternetDisconnected());
      }
    });

    // Cek perubahan konektivitas secara real-time
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      add(CheckInternet());
    });

    // Memeriksa koneksi setelah Bloc pertama kali dibangun
    add(CheckInternet());
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com')).timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
