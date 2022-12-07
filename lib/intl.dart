class Localization {
  const Localization(this.language);
  final String language;

  static const noText = 'no_text_found';

  static const en = {
    'set_title': 'Settings',
    'set_max_spoon': 'Maximum spoon number',
    'set_reset_max':
        'Daily reset the initial spoon\nnumber to its maximum value',
    'set_enable_reminder': 'Enable reminder',
    'set_remind_every': 'Remind me for a week every',
    'set_hours': 'hour(s)',
    'set_from': 'from',
    'set_to': 'to',
    'set_daily': 'daily',
    'set_reset_file': 'Reset data file',
    'set_confirm_title': 'Warning',
    'set_confirm_body':
        'This reset will erase all the data collected until now.\n\nDo you confirm this action ?',
    'set_confirm_cancel': 'CANCEL',
    'set_confirm_ok': 'OK',
    'set_snackbar': 'Data file deleted',
    'set_nodata': 'No data avalaible',
    'main_title': 'My Daily Spoons',
    'main_label': 'No spoon yet today',
    'main_log_date': 'Last time spooned at',
    'main_snackbar': 'Spooned !',
    'chartsmenu_title': 'Charts Menu',
    'chartsmenu_chart1': 'Chart 1',
    'chartsmenu_chart2': 'Chart 2',
    'chartsmenu_chart3': 'Chart 3',
    'chartsmenu_chart4': 'Chart 4',
    'chartsmenu_chart5': 'Chart 5',
    'chartsmenu_chart6': 'Chart 6',
    'charts_title': 'Charts'
  };

  static const fr = {
    'set_title': 'Paramètres',
    'set_max_spoon': 'Nombre maximum de cuillères',
    'set_reset_max':
        'Réinitialiser tous les jours\n le nombre de cuillères à son maximum ',
    'set_enable_reminder': 'Activer le rappel automatique',
    'set_remind_every': 'Me rappeler toutes les',
    'set_hours': 'heures pendant une semaine',
    'set_from': 'de',
    'set_to': 'à',
    'set_daily': 'chaque jour',
    'set_reset_file': 'Effacer les données',
    'set_confirm_title': 'Attention',
    'set_confirm_body':
        'Cette action va supprimer toutes les données collectées jusqu\'à présent.\n\nConfirmer ?',
    'set_confirm_cancel': 'ABANDONNER',
    'set_confirm_ok': 'CONFIRMER',
    'set_snackbar': 'Fichier de données supprimé',
    'set_nodata': 'Aucune donnée disponible',
    'main_title': 'Mes cuillères du jour',
    'main_label': 'Rien encore spooné aujourd\'hui',
    'main_log_date': 'Spooné le dernier coup à',
    'main_snackbar': 'Spooné !',
    'chartsmenu_title': 'Menu Visualisation',
    'chartsmenu_chart1': 'Graphique 1',
    'chartsmenu_chart2': 'Graphique 2',
    'chartsmenu_chart3': 'Graphique 3',
    'chartsmenu_chart4': 'Graphique 4',
    'chartsmenu_chart5': 'Graphique 5',
    'chartsmenu_chart6': 'Graphique 6',
    'charts_title': 'Graphiques'
  };

  static const lexicon = {'en': en, 'fr': fr};

  String txt(String item) {
    Map<String, String> lx = lexicon[language] ?? en;
    String tx = lx[item] ?? noText;
    return tx;
  }
}
