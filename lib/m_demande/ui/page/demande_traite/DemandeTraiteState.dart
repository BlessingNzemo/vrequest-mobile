import 'package:odc_mobile_project/m_demande/business/model/Demande.dart';

class DemandeTraiteState {
  List<Demande> listDemandes;
  bool isLoading;
  bool isEmpty;
  bool notFound;
  bool visible;
  int nbreDemande;
  List<Demande> listDemandesSearch;

  DemandeTraiteState(
      {this.listDemandes = const [],
      this.listDemandesSearch = const [],
      this.isLoading = false,
      this.isEmpty = false,
      this.visible = false,
      this.notFound = false,
      this.nbreDemande = 0});

  DemandeTraiteState copyWith({
    List<Demande>? listDemandes,
    List<Demande>? listDemandesSearch,
    bool? isLoading,
    bool? isEmpty,
    bool? visible,
    bool? notFound,
    int? nbreDemande,
  }) =>
      DemandeTraiteState(
        listDemandes: listDemandes ?? this.listDemandes,
        listDemandesSearch: listDemandesSearch ?? this.listDemandesSearch,
        isLoading: isLoading ?? this.isLoading,
        isEmpty: isEmpty ?? this.isEmpty,
        visible: visible ?? this.visible,
        notFound: notFound ?? this.notFound,
        nbreDemande: nbreDemande ?? this.nbreDemande,
      );
}
