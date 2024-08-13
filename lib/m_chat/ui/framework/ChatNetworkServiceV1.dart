import 'dart:async';
import 'dart:convert';

import 'package:gio/gio.dart' as gio;
import 'package:odc_mobile_project/m_chat/business/model/ChatModel.dart';
import 'package:odc_mobile_project/m_chat/business/model/ChatUsersModel.dart';
import 'package:odc_mobile_project/m_chat/business/model/creerMessageRequete.dart';
import 'package:odc_mobile_project/m_chat/business/service/messageNetworkService.dart';
import 'package:odc_mobile_project/m_chat/ui/pages/Chat/chat_message_type.dart';
import 'package:odc_mobile_project/m_demande/business/model/Demande.dart';
import 'package:odc_mobile_project/m_user/business/model/User.dart';
import 'package:signals/signals_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

class ChatNetworkServiceV1 implements MessageNetworkService {
  ChatNetworkServiceV1(this.baseURL, this.socket);
  String baseURL;
  Socket socket;
  @override
  Signal<ChatModel> message = Signal(ChatModel.fromJson({}));
  Signal<int> isconnected = Signal(0);
  Signal<int> isdeconnected = Signal(0);

  @override
  Future<List<ChatUsersModel>> recupererListMessageGroupe(String token) async {
    List<ChatUsersModel> lists = <ChatUsersModel>[];
    var url = this.baseURL + '/api/demandes';

    try {
      var response = await gio.get(url);

      if (((response.statusCode == 200) || (response.statusCode == 201)) &&
          (response.headers["content-type"] == "application/json")) {
            
        List result = json.decode(response.body);
        var responseFinal = result.map((e) {
          User lastSender = User.fromJson(e["lastSender"]);
          Demande demande = Demande.fromJson({
            "id": e["demande"]["id"],
            "ticket": e["demande"]["ticket"],
            "motif": e["demande"]["motif"],
            "dateDeplacement": e["demande"]["dateDeplacement"],
            "lieuDestination": e["demande"]["lieuDestination"],
            "lieuDepart": e["demande"]["lieuDepart"],
            "status": e["demande"]["status"],
            "longitude": e["demande"]["longitude"],
            "latitude": e["demande"]["latitude"],
            "initiateur": e["demande"]["initiateur"],
            "chauffeur": e["demande"]["chauffeur"],
            "nbrEtranger": int.parse(e["demande"]["nbrEtranger"]),
            "create_at": e["demande"]["created_at"],
          });
          return ChatUsersModel.fromJson({
            "demande": demande,
            "lastSender": lastSender,
            "lastMessage": e["lastMessage"],
            "isPicture": e["isPicture"] == 1 ? true : false,
            "isVideo": e["isVideo"] == 1 ? true : false,
            "isMessageRead": e["isMessageRead"],
            "time": e["time"],
            "unread": e["unread"],
          });
        }).toList();
        lists = responseFinal;
      }
    } catch (e) {
      print(e);
    }

    return Future.value(lists);
  }

  @override
  Future<ChatUsersModel> recupererMessageGroupe(int demandeId) async {
    List<ChatUsersModel> listMessages =
        await recupererListMessageGroupe("bjhfdf");
    Iterable<ChatUsersModel> result =
        listMessages.where((x) => x.demande.id == demandeId);
    return result.single;
  }

  @override
  Future<List<ChatModel>> recupererListMessageDetail(
      ChatUsersModel data, User? auth) async {
    List<ChatModel> lists = <ChatModel>[];
    var url = this.baseURL + '/api/messages';
    await dotenv.load(fileName: ".env");
    String file = "";

    try {
      var response = await gio.get(url,
          queryParameters: {"demande_id": data.demande.id.toString()});

      if (((response.statusCode == 200) || (response.statusCode == 201)) &&
          (response.headers["content-type"] == "application/json")) {
        if (auth != null) {
          List result = json.decode(response.body);
          var responseFinal = result.map((e) {
            file = e["filepath"] != null ? e["filepath"] : "";
            User user = User.fromJson(e["user"]);
            return ChatModel.fromJson({
              "demande": data.demande,
              "user": user,
              "contenu": e["contenu"],
              "file":
                  this.baseURL + "/" + dotenv.env["DISK_STORAGE"]! + "/" + file,
              "isPicture": e["isPicture"] == 1 ? true : false,
              "isVideo": e["isVideo"] == 1 ? true : false,
              "type": (user.id == auth.id)
                  ? ChatMessageType.sent
                  : ChatMessageType.received,
              "time": DateTime.parse(e["time"]),
            });
          }).toList();
          lists = responseFinal;
        }
      }
    } catch (e) {
      print(e);
    }

    return Future.value(lists);
  }

  @override
  Future<bool> creerMessage(CreerMessageRequete data) async {
    bool added = false;
    Dio dio = Dio();

    var url = this.baseURL + '/api/messages';
    var param;
    await dotenv.load(fileName: ".env");

    try {
      if (data.isPicture || data.isVideo) {
        param = FormData.fromMap({
          "user_id": data.user.id.toString(),
          "contenu": data.contenu,
          "message_groupe_id": data.demande.id.toString(),
          'file': await MultipartFile.fromFile(
            data.file!.path,
            filename: data.file!.name,
          ),
          "isPicture": data.isPicture ? 1 : 0,
          "isVideo": data.isVideo ? 1 : 0,
        });
      } else {
        param = FormData.fromMap({
          "user_id": data.user.id.toString(),
          "contenu": data.contenu,
          "message_groupe_id": data.demande.id.toString(),
        });
      }

      var response = await dio.post(
        url,
        data: param,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            //"Accept":"image"
          },
        ),
      );

      if (response.statusCode == 200) {
        var message_resp = json.decode(response.toString());
        added = true;
        
        var donnees = {
          "user": data.user,
          "contenu": message_resp["message"]["contenu"],
          "demande": data.demande,
          "filepath": 
            (message_resp["message"]["filepath"] != null)
              ? this.baseURL +
                "/" +
                dotenv.env["DISK_STORAGE"]! +
                "/" +
                message_resp["message"]["filepath"]
              : ""
        };
        
        socket.emit('createMessage', donnees);
      }
    } catch (e) {
      print(e);
    }

    return Future.value(added);
  }

  @override
  Future<bool> supprimerMessageDetail(int messageDetailId) {
    // TODO: implement supprimerMessageDetail
    throw UnimplementedError();
  }

  @override
  Future<void> realTime(User? auth) async {
      socket.on('sendMessage', (resp) {
        if ((auth != null) ) {
          print(resp["contenu"]+"  "+message.value.message);
          print("Message received ${resp["contenu"]} ");
          User user = User.fromJson(resp["user"]);
          message.value = ChatModel.fromJson({
            "demande": Demande.fromJson({
              "id": resp["demande"]["id"],
              "date_demande": resp["demande"]["date_demande"],
              "motif": resp["demande"]["motif"],
              "status": resp["demande"]["status"],
              "date_deplacement": resp["demande"]["date_deplacement"],
              "lieu_depart": resp["demande"]["lieuDepart"],
              "destination": resp["demande"]["destination"],
              "nbre_passagers": resp["demande"]["nbre_passagers"],
              "initiateur": {
                "id": resp["demande"]["initiateur"]["id"],
                "first_name": resp["demande"]["initiateur"]["first_name"],
                "username": resp["demande"]["initiateur"]["username"],
                "last_name": resp["demande"]["initiateur"]["last_name"],
                "email": resp["demande"]["initiateur"]["email"],
                "phone": resp["demande"]["initiateur"]["phone"],
                "email_verified_at": resp["demande"]["initiateur"]
                    ["email_verified_at"],
                "created_at": resp["demande"]["initiateur"]["created_at"],
                "updated_at": resp["demande"]["initiateur"]["updated_at"],
                "role": resp["demande"]["initiateur"]["role"],
              },
              "chauffeur": {
                "id": resp["demande"]["chauffeur"]["id"],
                "first_name": resp["demande"]["chauffeur"]["first_name"],
                "username": resp["demande"]["chauffeur"]["username"],
                "last_name": resp["demande"]["chauffeur"]["last_name"],
                "email": resp["demande"]["chauffeur"]["email"],
                "phone": resp["demande"]["chauffeur"]["phone"],
                "email_verified_at": resp["demande"]["chauffeur"]
                    ["email_verified_at"],
                "created_at": resp["demande"]["chauffeur"]["created_at"],
                "updated_at": resp["demande"]["chauffeur"]["updated_at"],
                "role": resp["demande"]["chauffeur"]["role"],
              },
              "longitude": resp["demande"]["longitude"],
              "latitude": resp["demande"]["latitude"],
              "create_at": resp["demande"]["create_at"],
            }),
            "user": user,
            "contenu": resp["contenu"],
            "file": resp["filepath"],
            "type": (user.id == auth.id)
                ? ChatMessageType.sent
                : ChatMessageType.received,
            "time": DateTime.now(),
          });
          print(resp["contenu"]+"  "+message.value.message);
        }
      });
      // socket.emit('test', 'testWhoIsConnected');
      // socket.on('isConnected', (resp) {
      //   isconnected.value = resp;
      // });
      // socket.emit('test', 'testWhoIsDeconnected');
      // socket.on('isDeconnected', (resp) {
      //   isdeconnected.value = resp;
      // });
  }

  @override
  Future<bool> joinRoom(Demande demande, User? auth) async {
    var joined = false;

    socket.emit('joinRoom', [demande.id.toString(), auth?.id]);
    print("Joined");

    joined = true;

    return joined;
  }
}