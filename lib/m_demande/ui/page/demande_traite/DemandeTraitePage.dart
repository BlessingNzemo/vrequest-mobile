import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:odc_mobile_project/m_demande/ui/composant/MyListTile.dart';
import 'package:odc_mobile_project/m_demande/ui/page/demande_traite/DemandeTraiteCtrl.dart';
import '../../../../navigation/routers.dart';
import '../../../business/model/Demande.dart';

class DemandeTraitePage extends ConsumerStatefulWidget {
  const DemandeTraitePage({super.key});

  @override
  ConsumerState createState() => _DemandeTraitePageState();
}

class _DemandeTraitePageState extends ConsumerState<DemandeTraitePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // action initiale de la page et appel d'un controleur
      var ctrl = ref.read(demandeTraiteCtrlProvider.notifier);
      ctrl.recupererListDemande();
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(demandeTraiteCtrlProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "(${state.nbreDemande}) Demandes traitées",
        ),
        actions: [
          IconButton(
              onPressed: () {
                var ctrl = ref.read(demandeTraiteCtrlProvider.notifier);
                ctrl.recupererListDemande();
              },
              icon: Icon(
                Icons.refresh_sharp,
                size: 30,
              )),
          IconButton(
              onPressed: () {
                context.pushNamed(Urls.demande.name);
              },
              icon: Icon(
                Icons.add,
                size: 30,
              ))
        ],
      ),
      body: Stack(
        children: [
          if (state.visible) _contenuPrincipale(context, ref),
          _chargement(context, ref)
        ],
      ),
    );
  }

  _contenuPrincipale(BuildContext context, WidgetRef ref) {
    var state = ref.watch(demandeTraiteCtrlProvider);

    List<Demande> _demandes = state.listDemandesSearch;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 25, left: 25, top: 25),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              suffixIcon: Icon(Icons.search),
            ),
            onChanged: (e) {
              var ctrl = ref.read(demandeTraiteCtrlProvider.notifier);
              ctrl.filtre(e);
            },
          ),
        ),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 35),
              child: (state.notFound) ? ListView.separated(
                itemCount: _demandes.length,
                itemBuilder: (ctx, index) {
                  var demande = _demandes[index];
                  return MyListTile(demande: demande);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 10.0,
                  );
                },
              ) : Center(
                child: Text("Aucune demande correspondante", style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400
                ),),
              ),
          ),
        ),
      ],
    );
  }

  _chargement(BuildContext context, WidgetRef ref) {
    var state = ref.watch(demandeTraiteCtrlProvider);

    return Visibility(
        visible: !(state.visible),
        child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state.isLoading) CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  if (state.isLoading)
                    Text(
                      "Chargement...",
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  if (state.isEmpty)
                    Text(
                      "Aucune demande trouvée veillez rafraichir la page",
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    )
                ],
              ),
            )));
  }
}
