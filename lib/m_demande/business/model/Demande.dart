// To parse this JSON data, do
//
//     final demande = demandeFromJson(jsonString);

import 'dart:convert';

import '../../../m_user/business/model/User.dart';

Demande demandeFromJson(String str) => Demande.fromJson(json.decode(str));

String demandeToJson(Demande data) => json.encode(data.toJson());

class Demande {
  int id;
  DateTime dateDemande;
  String motif;
  String status;
  String validate;
  String ticket;
  DateTime dateDeplacement;

  String lieuDepart;
  String destination;
  int nbrePassagers;
  User? initiateur;
  User? chefCharroi;
  User? manager;
  User? chauffeur;
  String longitude;
  String latitude;
  double longitudelDepart;
  double latitudeDepart;
  double longitudelDestination;
  double latitudeDestination;
  DateTime createAt;

  Demande({
    this.id = 0,
    required this.dateDemande,
    this.motif = "",
    this.status = "",
    this.validate = "",
    this.ticket = "",
    required this.dateDeplacement,
    this.lieuDepart = "",
    this.destination = '',
    this.nbrePassagers = 0,
    required this.initiateur,
    this.manager = null,
    required this.chauffeur,
    this.longitude = "0.0",
    this.latitude = "0.0",
    this.longitudelDepart = 0.0,
    this.latitudeDepart = 0.0,
    this.longitudelDestination = 0.0,
    this.latitudeDestination = 0.0,
    required this.createAt,
    this.chefCharroi = null,
  });

  factory Demande.fromJson(Map json) => Demande(
        id: json["id"] ?? 0,
        dateDemande: json["date_demande"] != null
            ? DateTime.parse(json["date_demande"])
            : DateTime.now(),
        motif: json["motif"] ?? "",
        ticket: json["ticket"] ?? "",
        status: "${json["status"]}" ?? "",
        validate: "${json["is_validated"]}" ?? "",
        dateDeplacement: json["date_deplacement"] != null
            ? DateTime.parse(json["date_deplacement"])
            : DateTime.now(),
        lieuDepart: json["lieu_depart"] ?? "",
        destination: json["destination"] ?? "",
        nbrePassagers:
            json["nbrEtranger"] != null ? int.parse(json["nbrEtranger"]) : 0,
        chefCharroi: json["chefCharroi"] != null
            ? User.fromJson(json["chefCharroi"])
            : User(
                id: 0,
                emailVerifiedAt: DateTime.now(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
        initiateur: json["user"] != null
            ? User.fromJson(json["user"])
            : User(
                id: 0,
                emailVerifiedAt: DateTime.now(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
        manager: json["manager"] != null
            ? User.fromJson(json["manager"])
            : User(
                id: 0,
                emailVerifiedAt: DateTime.now(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
        chauffeur: json["chauffeur"] != null
            ? User.fromJson(json["chauffeur"])
            : User(
                id: 0,
                emailVerifiedAt: DateTime.now(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
        longitude: "${json["longitude"]}" ?? "",
        latitude: "${json["latitude"]}" ?? "",
        longitudelDestination: json["longitude_destination"] != null
            ? json["longitude_destination"].toDouble()
            : 0.0,
        latitudeDestination: json["latitude_destination"] != null
            ? json["latitude_destination"].toDouble()
            : 0.0,
        longitudelDepart: json["longitude_depart"] != null
            ? json["longitude_depart"].toDouble()
            : 0.0,
        latitudeDepart: json["latitude_depart"] != null
            ? json["latitude_depart"].toDouble()
            : 0.0,
        createAt: json["create_at"] != null
            ? DateTime.parse(json["create_at"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date_demande":
            "${dateDemande.year.toString().padLeft(4, '0')}-${dateDemande.month.toString().padLeft(2, '0')}-${dateDemande.day.toString().padLeft(2, '0')}",
        "motif": motif,
        "ticket": ticket,
        "status": status,
        "date_deplacement":
            "${dateDeplacement.year.toString().padLeft(4, '0')}-${dateDeplacement.month.toString().padLeft(2, '0')}-${dateDeplacement.day.toString().padLeft(2, '0')}",
        "lieu_depart_id": lieuDepart,
        "destination_id": destination,
        "nbre_passagers": nbrePassagers,
        "initiateur": initiateur,
        "manager": manager,
        "chauffeur": chauffeur,
        "chef_charroi": chefCharroi,
        "longitude": longitude,
        "latitude": latitude,
        "longitudelDepart": longitudelDepart,
        "latitudeDepart": latitudeDepart,
        "longitudelDestination": longitudelDestination,
        "latitudeDestination": latitudeDestination,
        "create_at":
            "${createAt.year.toString().padLeft(4, '0')}-${createAt.month.toString().padLeft(2, '0')}-${createAt.day.toString().padLeft(2, '0')}",
      };
}
