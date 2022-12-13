class Localization {
  Localization(String? lang) : language = lang ?? defaultLanguage;
  String language;

  static const String defaultLanguage = 'en';
  static const noText = 'no_text_found';

  static const en = {
    'set_title': 'Settings',
    'set_language': 'Language',
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
    'chartsmenu_chart1': 'Event Gains and Losses',
    'chartsmenu_chart2': 'Event Frequencies',
    'chartsmenu_chart3': 'Event Rates',
    'chartsmenu_chart4': 'Gains and Losses by Day of the Week',
    'chartsmenu_chart5': 'Event Number by Day of the Week',
    'chartsmenu_chart6': 'Chart 6',
    'charts_title': 'Charts'
  };

  static const fr = {
    'set_title': 'Paramètres',
    'set_language': 'Langue',
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
    'chartsmenu_chart1': 'Gains et pertes par situation',
    'chartsmenu_chart2': 'Fréquence des situations',
    'chartsmenu_chart3': 'Intensité des situations',
    'chartsmenu_chart4': 'Gains et pertes par jour de la semaine',
    'chartsmenu_chart5': 'Nombre de situations par jour de la semaine',
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
